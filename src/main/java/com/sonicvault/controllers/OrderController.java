package com.sonicvault.controllers;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sonicvault.model.Order;
import com.sonicvault.model.User;
import com.sonicvault.service.iface.OrderService;

import jakarta.servlet.http.HttpSession;

/**
 * A signed-in customer's own order history. /orders/** is protected by
 * SecurityInterceptor (requires a logged-in user), and every method here
 * additionally scopes the query to the current session's user so one
 * customer can never view another customer's order by guessing an id.
 */
@Controller
@RequestMapping("/orders")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @GetMapping
    public String myOrders(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        List<Order> orders = orderService.getOrdersForUser(loggedInUser).stream()
                .sorted(Comparator.comparing(Order::getId).reversed())
                .collect(Collectors.toList());
        model.addAttribute("orders", orders);
        return "orders";
    }

    @GetMapping("/{id}")
    public String orderDetails(@PathVariable int id, HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        Order order = orderService.getOrderById(id);

        // Ownership check: a USER may only look at their own orders. Admins
        // may look at any order (they already manage /admin/orders).
        boolean isOwner = order != null && order.getUser() != null && order.getUser().getId() == loggedInUser.getId();
        boolean isAdmin = "ADMIN".equals(loggedInUser.getRole());
        if (order == null || !(isOwner || isAdmin)) {
            return "redirect:/orders?error=OrderNotFound";
        }

        model.addAttribute("order", order);
        return "checkout-success";
    }
}
