package com.sonicvault.service.impl;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class RazorpayService {

    @Value("${razorpay.key}")
    private String razorpayKey;

    @Value("${razorpay.secret}")
    private String razorpaySecret;

    public Order createOrder(double amount, String currency, String receipt) throws Exception {
        // Initialize the Razorpay client
        RazorpayClient client = new RazorpayClient(razorpayKey, razorpaySecret);

        // Prepare order options as a JSONObject
        JSONObject options = new JSONObject();
        options.put("amount", (int) (amount * 100)); // Amount in paise (e.g., ₹1 = 100 paise)
        options.put("currency", currency);
        options.put("receipt", receipt);

        // Create the order using the Razorpay client
        return client.orders.create(options);
    }
}
