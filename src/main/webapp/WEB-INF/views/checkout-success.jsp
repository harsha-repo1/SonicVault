<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed — SonicVault</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <a href="/orders" class="sv-back-link">&#8592; Back to Orders</a>

        <div class="sv-panel text-center" style="max-width:700px; margin:0 auto 24px;">
            <div style="font-size:2.4rem; margin-bottom:10px;">&#9989;</div>
            <h1 style="font-size:1.7rem;">Thank you for your order!</h1>
            <p style="color:var(--sv-text-muted);">Order #${order.id} has been placed successfully.</p>
        </div>

        <div class="sv-panel" style="max-width:700px; margin:0 auto;">
            <table class="sv-table">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Qty</th>
                        <th>Price</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${order.orderItems}">
                        <tr>
                            <td>${item.product.name}</td>
                            <td>${item.quantity}</td>
                            <td>$<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
                            <td>$<fmt:formatNumber value="${item.price * item.quantity}" pattern="#,##0.00"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="text-right mt-3">
                <h4>Total: &#8377;<fmt:formatNumber value="${order.totalPrice}" pattern="#,##0.00"/></h4>
                <span class="sv-badge sv-badge-status">${order.orderStatus}</span>
            </div>
            <div class="text-center mt-4">
                <a href="/products" class="sv-btn sv-btn-primary" style="display:inline-block; padding:11px 24px;">Continue Shopping</a>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
