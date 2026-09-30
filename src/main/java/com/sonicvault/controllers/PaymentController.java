package com.sonicvault.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sonicvault.service.impl.PaymentService;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    // NOTE: this controller is a legacy/alternate checkout path that isn't
    // linked from any page in the current UI (CartController's Razorpay
    // flow is what the Cart page actually uses). It's left in place rather
    // than deleted outright, but the one real bug in it -- returning a
    // non-existent "error" view, which would 500/white-page -- is fixed so
    // it at least fails safely if something still calls it directly.
    @GetMapping("/checkout")
    public String checkout(@RequestParam double amount, Model model) {
        try {
            String orderDetails = paymentService.createOrder(amount);
            model.addAttribute("orderDetails", orderDetails);
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/cart?error=PaymentUnavailable";
        }
        return "checkout"; // JSP for payment page
    }

    @PostMapping("/verify")
    public String verifyPayment(@RequestParam String razorpayPaymentId,
                                @RequestParam String razorpayOrderId,
                                @RequestParam String razorpaySignature,
                                Model model) {
        // Payment verification logic (optional)
        model.addAttribute("paymentId", razorpayPaymentId);
        return "success"; // Success JSP
    }
}
