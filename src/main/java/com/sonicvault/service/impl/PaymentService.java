package com.sonicvault.service.impl;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import org.json.JSONObject;
import org.springframework.stereotype.Service;
@Service
public class PaymentService {

    private RazorpayClient razorpayClient;

    public PaymentService() throws Exception {
        this.razorpayClient = new RazorpayClient("YOUR_API_KEY", "YOUR_API_SECRET");
    }

    public String createOrder(double amount) throws Exception {
        JSONObject options = new JSONObject();
        options.put("amount", (int) (amount * 100)); // Amount in paise
        options.put("currency", "INR");
        options.put("receipt", "txn_123456");

        Order order = razorpayClient.orders.create(options);
        return order.toString();
    }
}