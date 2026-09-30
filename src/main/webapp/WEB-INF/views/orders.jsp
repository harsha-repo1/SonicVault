<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Orders — SonicVault</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <a href="/products" class="sv-back-link">&#8592; Back to Products</a>
        <div class="sv-page-title"><h1>Your Orders</h1></div>

        <c:choose>
            <c:when test="${not empty orders}">
                <div class="sv-panel">
                    <table class="sv-table">
                        <thead>
                            <tr>
                                <th>Order #</th>
                                <th>Items</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>#${order.id}</td>
                                    <td>${fn:length(order.orderItems)} item(s)</td>
                                    <td>&#8377;<fmt:formatNumber value="${order.totalPrice}" pattern="#,##0.00"/></td>
                                    <td><span class="sv-badge sv-badge-status">${order.orderStatus}</span></td>
                                    <td><a href="/orders/${order.id}" class="sv-btn sv-btn-outline">View</a></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="sv-empty">
                    <div class="sv-empty-icon">&#128230;</div>
                    <p>You haven't placed any orders yet.</p>
                    <a href="/products" class="sv-btn sv-btn-primary" style="display:inline-block; padding:11px 24px;">Start Shopping</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
