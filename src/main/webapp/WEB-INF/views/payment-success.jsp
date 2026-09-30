<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment Successful — SonicVault</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="container">
        <div class="sv-panel text-center" style="max-width:560px; margin:60px auto;">
            <div style="font-size:2.4rem; margin-bottom:10px;">&#9989;</div>
            <h1 style="font-size:1.6rem;">Payment Successful!</h1>
            <p style="color:var(--sv-text-muted);">${message}</p>
            <a href="/products" class="sv-btn sv-btn-primary" style="display:inline-block; padding:11px 24px; margin-top:10px;">Continue Shopping</a>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>
