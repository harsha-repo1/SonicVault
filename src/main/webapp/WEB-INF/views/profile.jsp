<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Profile — SonicVault</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <a href="/products" class="sv-back-link">&#8592; Back to Products</a>
        <div class="sv-page-title"><h1>Your Profile</h1></div>

        <div class="sv-panel" style="max-width:520px;">
            <div class="sv-form-group">
                <label>Username</label>
                <div class="sv-input" style="background:var(--sv-bg-elevated);">${user.username}</div>
            </div>
            <div class="sv-form-group">
                <label>Email</label>
                <div class="sv-input" style="background:var(--sv-bg-elevated);">${user.email}</div>
            </div>
            <div class="sv-form-group">
                <label>Phone Number</label>
                <div class="sv-input" style="background:var(--sv-bg-elevated);">${user.phone_number}</div>
            </div>
            <div class="sv-form-group">
                <label>Role</label>
                <span class="sv-badge sv-badge-user">${user.role}</span>
            </div>
            <a href="/orders" class="sv-btn sv-btn-primary" style="display:inline-block; padding:11px 22px; margin-top:10px;">View Order History</a>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
