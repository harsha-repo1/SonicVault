<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  Shared navbar fragment. Included via <jsp:include> (not the static
  <%@ include %> directive) by every page, right after <body> opens, so it
  always renders as valid, in-place HTML instead of leaking a <style> block
  above <!DOCTYPE html> like the previous version did.

  Nav links change based on who's logged in, per the spec:
    Guest  -> Home | Products | Login | Sign Up
    User   -> Home | Products | Cart | Orders | Profile | Logout
    Admin  -> Dashboard | Products | Orders | Users | Logout
--%>
<header class="sv-navbar">
    <a href="/" class="sv-brand">&#127911; SonicVault</a>

    <nav class="sv-links">
        <c:choose>
            <c:when test="${loggedInUser != null && loggedInUser.role == 'ADMIN'}">
                <a href="/admin/dashboard">Dashboard</a>
                <a href="/admin/products">Products</a>
                <a href="/admin/orders">Orders</a>
                <a href="/admin/users">Users</a>
                <a href="/logout" class="sv-btn-pill sv-btn-ghost">Logout</a>
            </c:when>
            <c:when test="${loggedInUser != null}">
                <a href="/">Home</a>
                <a href="/products">Products</a>
                <a href="/cart">Cart
                    <c:if test="${not empty sessionScope.cartItems}">
                        <span class="sv-cart-badge">${fn:length(sessionScope.cartItems)}</span>
                    </c:if>
                </a>
                <a href="/orders">Orders</a>
                <a href="/user/profile">Profile</a>
                <a href="/logout" class="sv-btn-pill sv-btn-ghost">Logout</a>
            </c:when>
            <c:otherwise>
                <a href="/">Home</a>
                <a href="/products">Products</a>
                <a href="/login" class="sv-btn-pill sv-btn-ghost">Login</a>
                <a href="/login#signup" class="sv-btn-pill sv-btn-gradient">Sign Up</a>
            </c:otherwise>
        </c:choose>
    </nav>
</header>
