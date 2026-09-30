<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product — SonicVault Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <a href="/admin/products" class="sv-back-link">&#8592; Back to Products</a>
        <div class="sv-page-title"><h1>Edit Product</h1></div>

        <c:if test="${param.error == 'FileUploadFailed'}">
            <div class="sv-alert sv-alert-danger">The image could not be uploaded. Please try again.</div>
        </c:if>

        <div class="sv-panel" style="max-width:560px;">
            <form action="/admin/products/edit/${product.id}" method="post" enctype="multipart/form-data">
                <input type="hidden" name="id" value="${product.id}">

                <div class="sv-form-group">
                    <label for="name">Product Name</label>
                    <input type="text" id="name" name="name" class="sv-input" value="${product.name}" required>
                </div>

                <div class="sv-form-group">
                    <label for="description">Product Description</label>
                    <textarea id="description" name="description" class="sv-input" rows="4" required>${product.description}</textarea>
                </div>

                <div class="sv-form-group">
                    <label for="price">Price</label>
                    <input type="number" id="price" name="price" class="sv-input" value="${product.price}" step="0.01" required>
                </div>

                <div class="sv-form-group">
                    <label for="category">Category</label>
                    <select id="category" name="category" class="sv-input" required>
                        <option value="" disabled ${empty product.category ? 'selected' : ''}>Select a category</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}" ${cat == product.category ? 'selected' : ''}>${cat}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="sv-form-group">
                    <label for="imageFile">Upload New Image</label>
                    <input type="file" id="imageFile" name="imageFile" class="sv-input">
                    <small style="color:var(--sv-text-muted);">Leave empty to keep the current image.</small>
                </div>

                <div class="sv-form-group">
                    <label>Current Image</label><br>
                    <img src="${product.imagePath}" alt="${product.name}" style="width:130px; border-radius:8px;">
                </div>

                <button type="submit" class="sv-submit-btn">Update Product</button>
            </form>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
