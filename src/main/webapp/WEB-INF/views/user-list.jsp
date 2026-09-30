<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users — SonicVault Admin</title>
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
            <h1>Manage Users</h1>
            <a href="/admin/users/create" class="sv-btn sv-btn-primary">+ Add New User</a>
        </div>

        <div class="sv-panel">
            <table class="sv-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Phone Number</th>
                        <th>Email</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>${user.id}</td>
                            <td>${user.username}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.role == 'ADMIN'}">
                                        <span class="sv-badge sv-badge-admin">ADMIN</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="sv-badge sv-badge-user">USER</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${user.phone_number}</td>
                            <td>${user.email}</td>
                            <td>
                                <a href="/admin/users/edit/${user.id}" class="sv-btn sv-btn-warning">Edit</a>
                                <a href="/admin/users/delete/${user.id}" class="sv-btn sv-btn-danger" onclick="return confirm('Delete this user?');">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
