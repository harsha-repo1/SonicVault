<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products — SonicVault</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <a href="/" class="sv-back-link">&#8592; Back to Home</a>

        <div class="sv-page-title">
            <h1>All Products</h1>
            <c:if test="${loggedInUser != null && loggedInUser.role == 'ADMIN'}">
                <a href="/admin/products/add" class="sv-btn sv-btn-primary">+ Add New Product</a>
            </c:if>
        </div>

        <!-- Search + filter: GET to /products so results are shareable and
             work identically for guests and logged-in users. -->
        <form action="/products" method="get" class="sv-panel" style="display:flex; flex-wrap:wrap; gap:12px; align-items:flex-end; margin-bottom:24px;">
            <div class="sv-form-group" style="flex:2; min-width:180px; margin:0;">
                <label for="q">Search</label>
                <input type="text" id="q" name="q" value="${q}" placeholder="Search products…" class="sv-input">
            </div>
            <div class="sv-form-group" style="flex:1; min-width:150px; margin:0;">
                <label for="category">Category</label>
                <select id="category" name="category" class="sv-input">
                    <option value="">All Categories</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat}" ${cat == selectedCategory ? 'selected' : ''}>${cat}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="sv-form-group" style="flex:1; min-width:110px; margin:0;">
                <label for="minPrice">Min Price</label>
                <input type="number" id="minPrice" name="minPrice" value="${minPrice}" step="0.01" min="0" class="sv-input">
            </div>
            <div class="sv-form-group" style="flex:1; min-width:110px; margin:0;">
                <label for="maxPrice">Max Price</label>
                <input type="number" id="maxPrice" name="maxPrice" value="${maxPrice}" step="0.01" min="0" class="sv-input">
            </div>
            <button type="submit" class="sv-btn sv-btn-primary">Apply</button>
            <a href="/products" class="sv-btn sv-btn-outline">Clear</a>
        </form>

        <c:choose>
            <c:when test="${not empty products}">
                <div class="sv-product-grid">
                    <c:forEach var="product" items="${products}">
                        <div class="sv-product-card">
                            <a href="/products/${product.id}">
                                <div class="sv-product-img-wrap">
                                    <img src="${product.imagePath}" alt="${product.name}">
                                </div>
                            </a>
                            <div class="sv-product-body">
                                <h5><a href="/products/${product.id}" style="color:inherit;">${product.name}</a></h5>
                                <p class="sv-desc">${product.description}</p>
                                <div class="sv-price">&#8377;<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></div>

                                <c:if test="${loggedInUser == null || loggedInUser.role != 'ADMIN'}">
                                    <form class="sv-add-to-cart-form sv-card-actions" data-product-id="${product.id}">
                                        <input type="number" name="quantity" value="1" min="1" class="sv-qty-input">
                                        <button type="submit" class="sv-btn sv-btn-primary">
                                            <c:choose>
                                                <c:when test="${loggedInUser != null}">Add to Cart</c:when>
                                                <c:otherwise>Login to Buy</c:otherwise>
                                            </c:choose>
                                        </button>
                                    </form>
                                </c:if>

                                <c:if test="${loggedInUser != null && loggedInUser.role == 'ADMIN'}">
                                    <div class="sv-card-actions">
                                        <a href="/admin/products/edit/${product.id}" class="sv-btn sv-btn-warning">Edit</a>
                                        <a href="/admin/products/delete/${product.id}" class="sv-btn sv-btn-danger" onclick="return confirm('Delete this product?');">Delete</a>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="sv-empty">
                    <div class="sv-empty-icon">&#128230;</div>
                    <p>No products available right now.</p>
                </div>
            </c:otherwise>
        </c:choose>

        <c:if test="${loggedInUser != null && loggedInUser.role != 'ADMIN'}">
            <div class="text-right mt-4">
                <a href="/cart" class="sv-btn sv-btn-outline">View Cart &#8594;</a>
            </div>
        </c:if>
    </div>

    <div id="sv-toast"></div>

    <jsp:include page="footer.jsp" />

    <script>
        var isLoggedIn = ${not empty loggedInUser};

        function showToast(message) {
            var toast = document.getElementById('sv-toast');
            toast.innerHTML = message;
            toast.classList.add('sv-toast-show');
            clearTimeout(window._svToastTimer);
            window._svToastTimer = setTimeout(function () {
                toast.classList.remove('sv-toast-show');
            }, 2800);
        }

        // Seamless shopping: adding an item stays on the product grid --
        // no redirect to /cart -- and just updates the cart badge + shows a
        // toast, per the "Products -> Add to Cart -> Stay on Products" flow.
        document.querySelectorAll('.sv-add-to-cart-form').forEach(function (form) {
            form.addEventListener('submit', function (e) {
                e.preventDefault();

                if (!isLoggedIn) {
                    window.location.href = '/login';
                    return;
                }					var button = form.querySelector('button[type="submit"]');
					if (button.disabled) {
					    return;
					}
					button.disabled = true;

                var productId = form.getAttribute('data-product-id');
                var quantity = form.querySelector('input[name="quantity"]').value || 1;

                fetch('/cart/add', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: 'productId=' + encodeURIComponent(productId) + '&quantity=' + encodeURIComponent(quantity)
                })
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    if (data.success) {
                        showToast('<strong>' + data.productName + '</strong> added to cart');
                        var badge = document.querySelector('.sv-navbar a[href="/cart"] .sv-cart-badge');
                        if (badge) {
                            badge.textContent = data.cartCount;
                        } else {
                            var cartLink = document.querySelector('.sv-navbar a[href="/cart"]');
                            if (cartLink) {
                                var span = document.createElement('span');
                                span.className = 'sv-cart-badge';
                                span.textContent = data.cartCount;
                                cartLink.appendChild(span);
                            }
                        }
                    } else {
                        showToast( 'added item to cart.');
                    }
                })
                .catch(function () {
                    showToast('Something went wrong adding this item.');
                }).finally(function () {
					    button.disabled = false;
					});
				;
            });
        });
    </script>
</body>
</html>
