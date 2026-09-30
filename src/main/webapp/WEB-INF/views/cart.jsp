<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart — SonicVault</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <a href="/products" class="sv-back-link">&#8592; Back to Products</a>
        <div class="sv-page-title"><h1>Your Cart</h1></div>

        <c:if test="${not empty cartItems}">
            <div class="sv-panel">
                <table class="sv-table">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Subtotal</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${cartItems}">
                            <tr>
                                <td>${item.product.name}</td>
                                <td>&#8377;<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
                                <td>
                                    <form action="/cart/update" method="post" class="d-inline-flex" style="gap:8px;">
                                        <input type="hidden" name="productId" value="${item.product.id}">
                                        <input type="number" name="quantity" value="${item.quantity}" min="0" class="sv-qty-input">
                                        <button type="submit" class="sv-btn sv-btn-outline">Update</button>
                                    </form>
                                </td>
                                <td>$<fmt:formatNumber value="${item.price * item.quantity}" pattern="#,##0.00"/></td>
                                <td>
                                    <form action="/cart/update" method="post">
                                        <input type="hidden" name="productId" value="${item.product.id}">
                                        <input type="hidden" name="quantity" value="0">
                                        <button type="submit" class="sv-btn sv-btn-danger">Remove</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="text-right mt-4">
                    <h4>Total: &#8377;<fmt:formatNumber value="${totalPrice}" pattern="#,##0.00"/></h4>
                    <a href="/products" class="sv-btn sv-btn-outline mr-2">Continue Shopping</a>
                    <button id="checkoutButton" class="sv-btn sv-btn-primary" style="flex:none;">Checkout</button>
                </div>
            </div>
        </c:if>

        <c:if test="${empty cartItems}">
            <div class="sv-empty">
                <div class="sv-empty-icon">&#128722;</div>
                <p>Your cart is empty.</p>
                <a href="/products" class="sv-btn sv-btn-primary" style="display:inline-block; padding:11px 24px;">Continue Shopping</a>
            </div>
        </c:if>
    </div>

    <jsp:include page="footer.jsp" />

    <script>
        var checkoutButton = document.getElementById('checkoutButton');
        if (checkoutButton) {
            checkoutButton.onclick = function (e) {
                e.preventDefault();

                fetch('/cart/razorpayOrder', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' }
                })
                .then(function (response) { return response.json(); })
                .then(function (data) {
                    if (data && data.id) {
                        var options = {
                            key: "${razorpayKey}",
                            amount: data.amount,
                            currency: data.currency,
                            name: "SonicVault",
                            description: "Order Payment",
                            order_id: data.id,
                            handler: function () {
                                // Persist the order in our own database (this
                                // clears the session cart and shows the
                                // order-confirmation page), then send the
                                // shopper to the payment-success screen.
                                var form = document.createElement('form');
                                form.method = 'POST';
                                form.action = '/cart/checkout';
                                document.body.appendChild(form);
                                form.submit();
                            },
                            theme: { color: "#6c5ce7" }
                        };
                        var razorpay = new Razorpay(options);
                        razorpay.open();
                    } else {
                        alert("Failed to start checkout. Please try again.");
                    }
                })
                .catch(function () {
                    alert("An error occurred while processing your payment.");
                });
            };
        }
    </script>
</body>
</html>
