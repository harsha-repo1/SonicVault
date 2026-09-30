package com.sonicvault.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sonicvault.model.Order;
import com.sonicvault.model.OrderItem;
import com.sonicvault.model.Product;
import com.sonicvault.service.iface.OrderService;
import com.sonicvault.service.iface.ProductService;
import com.sonicvault.service.iface.UserService;

/**
 * Everything an administrator does lives under /admin/... here, per the
 * project's URL-organization convention. Every URL in this controller is
 * already protected by SecurityInterceptor (see WebConfig), which redirects
 * anyone who isn't a logged-in ADMIN before these methods even run -- so the
 * methods themselves can stay focused on the actual work.
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    private final ProductService productService;
    private final OrderService orderService;
    private final UserService userService;

    public AdminController(ProductService productService, OrderService orderService, UserService userService) {
        this.productService = productService;
        this.orderService = orderService;
        this.userService = userService;
    }

    // ---------- Dashboard ----------

    @GetMapping("/dashboard")
    public String adminDashboard(Model model) {
        List<Product> products = productService.getAllProducts();
        List<Order> orders = orderService.getAllOrders();

        model.addAttribute("totalProducts", products.size());
        model.addAttribute("totalUsers", userService.getAllUsers().size());
        model.addAttribute("totalOrders", orders.size());

        BigDecimal totalSales = orders.stream()
                .map(o -> o.getTotalPrice() == null ? BigDecimal.ZERO : o.getTotalPrice())
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        model.addAttribute("totalSales", totalSales);

        LocalDate today = LocalDate.now();
        LocalDate weekAgo = today.minusDays(7);
        LocalDate monthStart = today.withDayOfMonth(1);

        model.addAttribute("todaySales", sumSince(orders, today.atStartOfDay()));
        model.addAttribute("last7DaysSales", sumSince(orders, weekAgo.atStartOfDay()));
        model.addAttribute("thisMonthSales", sumSince(orders, monthStart.atStartOfDay()));

        BigDecimal avgOrderValue = orders.isEmpty() ? BigDecimal.ZERO
                : totalSales.divide(BigDecimal.valueOf(orders.size()), 2, java.math.RoundingMode.HALF_UP);
        model.addAttribute("avgOrderValue", avgOrderValue);

        model.addAttribute("topProducts", topSellingProducts(orders, 5));

        List<Order> recentOrders = orders.stream()
                .sorted(Comparator.comparing(Order::getId).reversed())
                .limit(5)
                .collect(Collectors.toList());
        model.addAttribute("recentOrders", recentOrders);

        return "admin-dashboard";
    }

    private BigDecimal sumSince(List<Order> orders, LocalDateTime since) {
        return orders.stream()
                .filter(o -> o.getCreatedAt() != null && !o.getCreatedAt().isBefore(since))
                .map(o -> o.getTotalPrice() == null ? BigDecimal.ZERO : o.getTotalPrice())
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private List<Map.Entry<String, Integer>> topSellingProducts(List<Order> orders, int limit) {
        Map<String, Integer> unitsSold = new LinkedHashMap<>();
        for (Order order : orders) {
            if (order.getOrderItems() == null) continue;
            for (OrderItem item : order.getOrderItems()) {
                String name = item.getProduct() != null ? item.getProduct().getName() : "Unknown";
                unitsSold.merge(name, item.getQuantity(), Integer::sum);
            }
        }
        return unitsSold.entrySet().stream()
                .sorted((a, b) -> b.getValue() - a.getValue())
                .limit(limit)
                .collect(Collectors.toList());
    }

    // ---------- Product management (moved from ProductController so every
    //            admin-only URL consistently lives under /admin/...) ----------

    @GetMapping("/products")
    public String manageProducts(@RequestParam(required = false) String category,
                                  @RequestParam(required = false) String search,
                                  Model model) {
        model.addAttribute("products", productService.getFilteredProducts(category, search));
        model.addAttribute("selectedCategory", category == null ? "" : category);
        model.addAttribute("searchTerm", search == null ? "" : search);
        return "admin-products";
    }

    @GetMapping("/products/add")
    public String showAddProductPage(Model model) {
        model.addAttribute("categories", ProductService.CATEGORIES);
        return "add-product";
    }

    @PostMapping("/products/add")
    public String addNewProduct(@ModelAttribute Product product) {
        try {
            if (product.getImageFile() != null && !product.getImageFile().isEmpty()) {
                String imagePath = productService.saveProductImage(product.getImageFile());
                product.setImagePath(imagePath);
            }
            productService.saveProduct(product);
        } catch (IOException e) {
            e.printStackTrace();
            return "redirect:/admin/products/add?error=FileUploadFailed";
        }
        return "redirect:/admin/products";
    }

    @GetMapping("/products/edit/{id}")
    public String showEditProductPage(@PathVariable int id, Model model) {
        Product product = productService.getProductById(id);
        if (product == null) {
            return "redirect:/admin/products?error=ProductNotFound";
        }
        model.addAttribute("product", product);
        model.addAttribute("categories", ProductService.CATEGORIES);
        return "edit-product";
    }

    @PostMapping("/products/edit/{id}")
    public String updateProduct(@PathVariable int id, @ModelAttribute Product product) {
        try {
            Product existingProduct = productService.getProductById(id);
            if (existingProduct == null) {
                return "redirect:/admin/products?error=ProductNotFound";
            }
            if (product.getImageFile() != null && !product.getImageFile().isEmpty()) {
                String imagePath = productService.saveProductImage(product.getImageFile());
                product.setImagePath(imagePath);
            } else {
                product.setImagePath(existingProduct.getImagePath());
            }
            product.setId(id);
            productService.saveProduct(product);
        } catch (IOException e) {
            e.printStackTrace();
            return "redirect:/admin/products/edit/" + id + "?error=FileUploadFailed";
        }
        return "redirect:/admin/products";
    }

    @GetMapping("/products/delete/{id}")
    public String deleteProduct(@PathVariable int id) {
        productService.deleteProduct(id);
        return "redirect:/admin/products";
    }

    // ---------- Orders ----------

    @GetMapping("/orders")
    public String manageOrders(Model model) {
        List<Order> orders = orderService.getAllOrders().stream()
                .sorted(Comparator.comparing(Order::getId).reversed())
                .collect(Collectors.toList());
        model.addAttribute("orders", orders);
        return "admin-orders";
    }
}
