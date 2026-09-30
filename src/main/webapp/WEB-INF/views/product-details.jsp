<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} — SonicVault</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <a href="/products" class="sv-back-link">&#8592; Back to Products</a>

        <div class="row sv-panel">
            <div class="col-md-6 mb-4">
                <img src="${product.imagePath}" alt="${product.name}" style="width:100%; border-radius:12px; object-fit:cover; max-height:420px;">
            </div>
            <div class="col-md-6">
                <h1 style="font-size:1.9rem;">${product.name}</h1>
                <div class="sv-price" style="font-size:1.6rem;">&#8377;<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></div>
                <p style="color:var(--sv-text-muted); line-height:1.6;">${product.description}</p>

                <c:choose>
                    <c:when test="${loggedInUser != null && loggedInUser.role != 'ADMIN'}">
                        <form action="/cart/add" method="post" class="sv-card-actions" style="max-width:280px;">
                            <input type="hidden" name="productId" value="${product.id}">
                            <input type="number" name="quantity" value="1" min="1" class="sv-qty-input">
                            <button type="submit" class="sv-btn sv-btn-primary">Add to Cart</button>
                        </form>
                    </c:when>
                    <c:when test="${loggedInUser == null}">
                        <a href="/login" class="sv-btn sv-btn-primary" style="display:inline-block; padding:11px 22px;">Login to Buy</a>
                    </c:when>
                    <c:otherwise>
                        <div class="sv-card-actions">
                            <a href="/admin/products/edit/${product.id}" class="sv-btn sv-btn-warning">Edit</a>
                            <a href="/admin/products/delete/${product.id}" class="sv-btn sv-btn-danger" onclick="return confirm('Delete this product?');">Delete</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
