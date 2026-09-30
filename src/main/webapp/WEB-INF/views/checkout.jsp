<!-- checkout.jsp -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout</title>
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
</head>
<body>
    <h1>Payment Checkout</h1>
    <button id="rzp-button">Pay Now</button>

    <script>
        var options = {
            "key": "YOUR_API_KEY", // Enter the Key ID generated from Razorpay Dashboard
            "amount": "<%= orderDetails.amount %>", // Amount in paise
            "currency": "INR",
            "name": "My E-Commerce",
            "description": "Test Transaction",
            "order_id": "<%= orderDetails.id %>", // Pass the order ID
            "handler": function (response) {
                alert("Payment successful!");
                location.href = "/payment/verify?razorpayPaymentId=" + response.razorpay_payment_id + 
                                "&razorpayOrderId=" + response.razorpay_order_id + 
                                "&razorpaySignature=" + response.razorpay_signature;
            },
            "prefill": {
                "name": "Test User",
                "email": "testuser@example.com",
                "contact": "9876543210"
            },
            "theme": {
                "color": "#3399cc"
            }
        };
        var rzp = new Razorpay(options);
        document.getElementById('rzp-button').onclick = function (e) {
            rzp.open();
            e.preventDefault();
        }
    </script>
</body>
</html>