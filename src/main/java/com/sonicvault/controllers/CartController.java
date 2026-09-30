package com.sonicvault.controllers;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.http.HttpHeaders;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.sonicvault.model.Order;
import com.sonicvault.model.OrderItem;
import com.sonicvault.model.Product;
import com.sonicvault.model.User;
import com.sonicvault.service.iface.OrderService;
import com.sonicvault.service.iface.ProductService;
import com.sonicvault.service.impl.RazorpayService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@Controller
@RequestMapping("/cart")
public class CartController {

    private final ProductService productService;
    private final OrderService orderService;
    private final RazorpayService razorpayService;

    @Value("${razorpay.key}")
    private String razorpayKey;

    public CartController(ProductService productService, OrderService orderService,RazorpayService razorpayService) {
        this.productService = productService;
        this.orderService = orderService;
        this. razorpayService=razorpayService;
    }

    @GetMapping
    public String viewCart(HttpSession session, Model model) {
        List<OrderItem> cartItems = getCartItemsFromSession(session);

        double totalPrice = 0;
        for (OrderItem item : cartItems) {
            totalPrice += item.getPrice() * item.getQuantity();
        }

        model.addAttribute("cartItems", cartItems);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("razorpayKey", razorpayKey);
        return "cart"; // JSP to display cart contents
    }

    // Adding an item to the cart no longer redirects to /cart. Product-list.jsp
    // calls this with fetch() and sends "X-Requested-With: XMLHttpRequest";
    // this returns the updated cart count as JSON so the page can show a
    // toast and update the cart badge without leaving the product grid. A
    // plain (non-JS) form submission still works and falls back to the old
    // redirect-to-cart behaviour.
    @PostMapping("/add")
    public ResponseEntity<?>  addToCart(@RequestParam int productId, @RequestParam(defaultValue = "1") int quantity,
                             HttpSession session,
                             @RequestHeader(value = "X-Requested-With", required = false) String requestedWith,
                             HttpServletResponse response) throws IOException {

        List<OrderItem> cartItems = getCartItemsFromSession(session);

        Product product = productService.getProductById(productId);
        Map<String, Object> jsonBody = new HashMap<>();
        boolean isAjax = "XMLHttpRequest".equals(requestedWith);

        if (product == null) {
        	if (isAjax) {
        	    Map<String, Object> body = new HashMap<>();
        	    body.put("success", false);
        	    body.put("message", "Product not found.");
        	    return ResponseEntity.ok(body);
        	}
            throw new IllegalArgumentException("Invalid product ID");
        }

        boolean productExists = false;
        for (OrderItem item : cartItems) {
            if (item.getProduct().getId() == productId) {
                item.setQuantity(item.getQuantity() + quantity);
                productExists = true;
                break;
            }
        }

        if (!productExists) {
            OrderItem newItem = new OrderItem();
            newItem.setProduct(product);
            newItem.setPrice(product.getPrice());
            newItem.setQuantity(quantity);
            cartItems.add(newItem);
        }

        session.setAttribute("cartItems", cartItems);

        if (isAjax) {
            Map<String, Object> body = new HashMap<>();
            body.put("success", false);
            body.put("message", "Product not found.");
            return ResponseEntity.ok(body);
        }
        // No @ResponseBody on this method anymore, so this string is correctly
        // resolved as a real HTTP redirect instead of being printed as text.
        return ResponseEntity.status(HttpStatus.FOUND)
                .header("Location", "/cart")
                .build();
    }

    // Small helper so the AJAX branch can write a JSON body by hand, since the
    // method itself is no longer globally @ResponseBody.
    
    @PostMapping("/update")
    public String updateCart(@RequestParam int productId, @RequestParam int quantity, HttpSession session) {
        List<OrderItem> cartItems = getCartItemsFromSession(session);

        List<OrderItem> toRemove = new ArrayList<>();
        for (OrderItem item : cartItems) {
            if (item.getProduct().getId() == productId) {
                if (quantity == 0) {
                	toRemove.add(item);
                } else {
                    item.setQuantity(quantity);
                }
            }
        }

        cartItems.removeAll(toRemove);
        session.setAttribute("cartItems", cartItems);

        return "redirect:/cart";
    }

    @PostMapping("/checkout")
    public String checkout(HttpSession session, Model model) {
        @SuppressWarnings("unchecked")
        List<OrderItem> cartItems = (List<OrderItem>) session.getAttribute("cartItems");
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (cartItems == null || cartItems.isEmpty() || loggedInUser == null) {
            return "redirect:/cart";
        }

        Order order = new Order();
        order.setUser(loggedInUser);
        order.setOrderStatus("COMPLETED");

        double totalPrice = 0;
        for (OrderItem item : cartItems) {
            item.setOrder(order);
            totalPrice += item.getPrice() * item.getQuantity();
        }

        order.setTotalPrice(BigDecimal.valueOf(totalPrice));
        order.setOrderItems(cartItems);

        orderService.saveOrder(order);
        session.removeAttribute("cartItems");

        model.addAttribute("order", order);
        return "checkout-success";
    }

    @SuppressWarnings("unchecked")
    private List<OrderItem> getCartItemsFromSession(HttpSession session) {
        List<OrderItem> cartItems = (List<OrderItem>) session.getAttribute("cartItems");
        if (cartItems == null) {
            cartItems = new ArrayList<>();
            session.setAttribute("cartItems", cartItems);
        }
        return cartItems;
    }

    @GetMapping("/payment-success")
    public String showPaymentSuccessPage(HttpSession session, Model model) {
        session.removeAttribute("cartItems");
        model.addAttribute("message", "Your payment was successful, and your cart has been cleared!");
        return "payment-success";
    }


    @PostMapping("/razorpayOrder")
    @ResponseBody
    public Map<String, Object> createRazorpayOrder(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            List<OrderItem> cartItems = getCartItemsFromSession(session);
            if (cartItems == null || cartItems.isEmpty()) {
                throw new IllegalStateException("Cart is empty");
            }

            double totalPrice = cartItems.stream()
                    .mapToDouble(item -> item.getPrice() * item.getQuantity())
                    .sum();

            com.razorpay.Order razorpayOrder = razorpayService.createOrder(totalPrice, "INR", "OrderReceipt#123");

            response.put("id", razorpayOrder.get("id"));
            response.put("amount", razorpayOrder.get("amount"));
            response.put("currency", razorpayOrder.get("currency"));
        } catch (Exception e) {
            e.printStackTrace();
            response.put("error", "Failed to create Razorpay order: " + e.getMessage());
        }
        return response;
    }
}
