<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products — SonicVault Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <a href="/admin/dashboard" class="sv-back-link">&#8592; Back to Dashboard</a>

        <div class="sv-page-title">
            <h1>Manage Products</h1>
            <a href="/admin/products/add" class="sv-btn sv-btn-primary">+ Add New Product</a>
        </div>
		<div class="sv-panel" style="margin-bottom:24px;">
		    <div class="d-flex flex-wrap" style="gap:10px; margin-bottom:16px;">
		        <c:url var="urlAll" value="/admin/products">
		            <c:if test="${not empty searchTerm}"><c:param name="search" value="${searchTerm}"/></c:if>
		        </c:url>
		        <a href="${urlAll}" class="sv-btn-pill ${empty selectedCategory ? 'sv-btn-gradient' : 'sv-btn-ghost'}">All</a>

		        <c:url var="urlHeadphones" value="/admin/products">
		            <c:param name="category" value="Headphones"/>
		            <c:if test="${not empty searchTerm}"><c:param name="search" value="${searchTerm}"/></c:if>
		        </c:url>
		        <a href="${urlHeadphones}" class="sv-btn-pill ${selectedCategory == 'Headphones' ? 'sv-btn-gradient' : 'sv-btn-ghost'}">Headphones</a>

		        <c:url var="urlEarbuds" value="/admin/products">
		            <c:param name="category" value="Earbuds"/>
		            <c:if test="${not empty searchTerm}"><c:param name="search" value="${searchTerm}"/></c:if>
		        </c:url>
		        <a href="${urlEarbuds}" class="sv-btn-pill ${selectedCategory == 'Earbuds' ? 'sv-btn-gradient' : 'sv-btn-ghost'}">Earbuds</a>

		        <c:url var="urlSpeakers" value="/admin/products">
		            <c:param name="category" value="Speakers"/>
		            <c:if test="${not empty searchTerm}"><c:param name="search" value="${searchTerm}"/></c:if>
		        </c:url>
		        <a href="${urlSpeakers}" class="sv-btn-pill ${selectedCategory == 'Speakers' ? 'sv-btn-gradient' : 'sv-btn-ghost'}">Speakers</a>

		        <c:url var="urlAccessories" value="/admin/products">
		            <c:param name="category" value="Accessories"/>
		            <c:if test="${not empty searchTerm}"><c:param name="search" value="${searchTerm}"/></c:if>
		        </c:url>
		        <a href="${urlAccessories}" class="sv-btn-pill ${selectedCategory == 'Accessories' ? 'sv-btn-gradient' : 'sv-btn-ghost'}">Accessories</a>
		    </div>
		    <input type="text" id="sv-search-input" class="sv-input" placeholder="Search products..."
		           value="${searchTerm}" style="max-width:360px;">
		</div>

        <c:choose>
            <c:when test="${not empty products}">
                <div class="sv-panel">
                    <table class="sv-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Image</th>
                                <th>Name</th>
                                <th>Description</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="product" items="${products}">
                                <tr>
                                    <td>${product.id}</td>
                                    <td><img src="${product.imagePath}" alt="${product.name}" style="width:56px; height:56px; object-fit:cover; border-radius:8px;"></td>
                                    <td>${product.name}</td>
                                    <td style="max-width:280px;">${product.description}</td>
                                    <td>${product.category}</td>
                                    <td>&#8377;<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></td>
									<td class="sv-table-actions">
									    <a href="/admin/products/edit/${product.id}" class="sv-btn sv-btn-warning">Edit</a>
									    <a href="/admin/products/delete/${product.id}" class="sv-btn sv-btn-danger" onclick="return confirm('Delete this product?');">Delete</a>
									</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="sv-empty">
                    <div class="sv-empty-icon">&#128230;</div>
                    <p>No products yet.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <jsp:include page="footer.jsp" />
	<script>
	    var searchInput = document.getElementById('sv-search-input');
	    var currentCategory = "${selectedCategory}";
	    var searchDebounceTimer = null;

	    searchInput.addEventListener('input', function () {
	        clearTimeout(searchDebounceTimer);
	        var value = searchInput.value;
	        searchDebounceTimer = setTimeout(function () {
	            var params = new URLSearchParams();
	            if (currentCategory) {
	                params.set('category', currentCategory);
	            }
	            if (value.trim()) {
	                params.set('search', value.trim());
	            }
	            var query = params.toString();
	            window.location.href = '/admin/products' + (query ? '?' + query : '');
	        }, 800);
	    });
	</script>
</body>
</html>
