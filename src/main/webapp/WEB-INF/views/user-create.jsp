<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add User — SonicVault Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <a href="/admin/users" class="sv-back-link">&#8592; Back to Users</a>
        <div class="sv-page-title"><h1>Add New User</h1></div>

        <c:if test="${not empty error}">
            <div class="sv-alert sv-alert-danger">${error}</div>
        </c:if>

        <div class="sv-panel" style="max-width:520px;">
            <form action="/admin/users/create" method="post">
                <div class="sv-form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="sv-input" required>
                </div>
                <div class="sv-form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="sv-input" required>
                </div>
                <div class="sv-form-group">
                    <label for="role">Role</label>
                    <select id="role" name="role" class="sv-input" required>
                        <option value="USER">User</option>
                        <option value="ADMIN">Admin</option>
                    </select>
                </div>
                <div class="sv-form-group">
                    <label for="phone_number">Phone Number</label>
                    <input type="text" id="phone_number" name="phone_number" class="sv-input" required>
                </div>
                <div class="sv-form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" class="sv-input" required>
                </div>
                <button type="submit" class="sv-submit-btn">Create User</button>
            </form>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
