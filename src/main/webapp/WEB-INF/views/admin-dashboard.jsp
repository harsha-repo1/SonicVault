<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — SonicVault</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <div class="sv-page-title"><h1>Admin Dashboard</h1></div>

        <div class="sv-stats-grid">
            <div class="sv-stat-card sv-accent">
                <div class="sv-stat-label">Total Sales</div>
                <div class="sv-stat-value">&#8377;<fmt:formatNumber value="${totalSales}" pattern="#,##0.00"/></div>
            </div>
            <div class="sv-stat-card">
                <div class="sv-stat-label">Today's Sales</div>
                <div class="sv-stat-value">&#8377;<fmt:formatNumber value="${todaySales}" pattern="#,##0.00"/></div>
            </div>
            <div class="sv-stat-card">
                <div class="sv-stat-label">Last 7 Days</div>
                <div class="sv-stat-value">&#8377;<fmt:formatNumber value="${last7DaysSales}" pattern="#,##0.00"/></div>
            </div>
            <div class="sv-stat-card">
                <div class="sv-stat-label">This Month</div>
                <div class="sv-stat-value">&#8377;<fmt:formatNumber value="${thisMonthSales}" pattern="#,##0.00"/></div>
            </div>
            <div class="sv-stat-card">
                <div class="sv-stat-label">Avg. Order Value</div>
                <div class="sv-stat-value">&#8377;<fmt:formatNumber value="${avgOrderValue}" pattern="#,##0.00"/></div>
            </div>
            <div class="sv-stat-card">
                <div class="sv-stat-label">Total Orders</div>
                <div class="sv-stat-value">${totalOrders}</div>
            </div>
            <div class="sv-stat-card">
                <div class="sv-stat-label">Total Products</div>
                <div class="sv-stat-value">${totalProducts}</div>
            </div>
            <div class="sv-stat-card">
                <div class="sv-stat-label">Total Users</div>
                <div class="sv-stat-value">${totalUsers}</div>
            </div>
        </div>

        <div class="sv-admin-links">
            <div class="sv-admin-link-card">
                <h5>Manage Products</h5>
                <p>Add, edit, or remove products in the catalog.</p>
                <a href="/admin/products" class="sv-btn sv-btn-primary" style="display:inline-block;">Go to Products</a>
            </div>
            <div class="sv-admin-link-card">
                <h5>Manage Orders</h5>
                <p>Review all customer orders.</p>
                <a href="/admin/orders" class="sv-btn sv-btn-primary" style="display:inline-block;">Go to Orders</a>
            </div>
            <div class="sv-admin-link-card">
                <h5>Manage Users</h5>
                <p>Add, edit, or remove user accounts.</p>
                <a href="/admin/users" class="sv-btn sv-btn-primary" style="display:inline-block;">Go to Users</a>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <div class="sv-panel">
                    <h5 class="mb-3">Top Selling Products</h5>
                    <c:choose>
                        <c:when test="${not empty topProducts}">
                            <c:forEach var="entry" items="${topProducts}">
                                <div class="sv-bar-row">
                                    <div class="sv-bar-label">${entry.key}</div>
                                    <div class="sv-bar-track">
                                        <div class="sv-bar-fill" style="width: ${entry.value * 12 > 100 ? 100 : entry.value * 12}%;"></div>
                                    </div>
                                    <div class="sv-bar-count">${entry.value}</div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="color:var(--sv-text-muted);">No sales yet.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="col-md-6">
                <div class="sv-panel">
                    <h5 class="mb-3">Recent Orders</h5>
                    <c:choose>
                        <c:when test="${not empty recentOrders}">
                            <table class="sv-table">
                                <thead><tr><th>#</th><th>Customer</th><th>Total</th></tr></thead>
                                <tbody>
                                    <c:forEach var="order" items="${recentOrders}">
                                        <tr>
                                            <td>#${order.id}</td>
                                            <td>${order.user.username}</td>
                                            <td>&#8377;<fmt:formatNumber value="${order.totalPrice}" pattern="#,##0.00"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <p style="color:var(--sv-text-muted);">No orders yet.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
