package com.sonicvault.controllers;
import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import com.sonicvault.model.Product;
import com.sonicvault.service.iface.ProductService;

/**
 * Public product browsing. Guests can view /products and /products/{id}
 * without logging in (per the "Landing -> Products -> Product Details ->
 * Login/Signup" guest flow) -- only adding to a cart requires an account,
 * and that check lives in CartController.
 *
 * /products also carries the full search + filter UI (keyword, category,
 * price range) -- available to guests and logged-in users alike.
 *
 * Admin-only product management (add/edit/delete) lives under /admin/products
 * in AdminController, per the URL-organization convention:
 *   ProductController -> /products/...   (public browsing)
 *   AdminController    -> /admin/...      (management)
 */
@Controller
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/products")
    public String showProductList(@RequestParam(required = false) String q,
                                   @RequestParam(required = false) String category,
                                   @RequestParam(required = false) Double minPrice,
                                   @RequestParam(required = false) Double maxPrice,
                                   Model model) {
        List<Product> products = productService.searchProducts(q, category, minPrice, maxPrice);
        model.addAttribute("products", products);
        model.addAttribute("categories", ProductService.CATEGORIES);
        model.addAttribute("q", q == null ? "" : q);
        model.addAttribute("selectedCategory", category == null ? "" : category);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        return "product-list";
    }

    @GetMapping("/products/{id}")
    public String showProductDetails(@PathVariable int id, Model model) {
        Product product = productService.getProductById(id);
        if (product == null) {
            return "redirect:/products?error=ProductNotFound";
        }
        model.addAttribute("product", product);
        return "product-details";
    }
}
