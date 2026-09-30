<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SonicVault — Premium Audio Equipment</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <section class="sv-hero">
        <span class="sv-eyebrow">New Season Audio</span>
        <h1>Sound, <span>engineered</span> to move you.</h1>
        <p class="sv-lead">SonicVault curates premium headphones, earbuds, speakers and accessories built for people who actually listen closely.</p>
        <div class="sv-cta-row">
            <a href="/products" class="sv-btn sv-btn-primary" style="padding:13px 26px;">Shop All Products</a>
            <c:if test="${loggedInUser == null}">
                <a href="/login#signup" class="sv-btn sv-btn-outline" style="padding:13px 26px;">Create an Account</a>
            </c:if>
        </div>
    </section>

    <section class="sv-section">
        <div class="sv-section-head">
            <h2>Shop by Category</h2>
            <p>Find the right gear for the way you listen. Browse freely -- no account needed.</p>
        </div>

       

        <div class="sv-category-grid">
            <a href="/?category=Headphones&q=${q}" class="sv-category-card ${selectedCategory == 'Headphones' ? 'sv-category-active' : ''}" style="color:inherit;">
                <div class="sv-icon">&#127911;</div>
                <h5>Headphones</h5>
                <p>Over-ear &amp; on-ear, studio to lifestyle.</p>
            </a>
            <a href="/?category=Earbuds&q=${q}" class="sv-category-card ${selectedCategory == 'Earbuds' ? 'sv-category-active' : ''}" style="color:inherit;">
                <div class="sv-icon">&#127925;</div>
                <h5>Earbuds</h5>
                <p>True wireless, ANC and sport-ready.</p>
            </a>
            <a href="/?category=Speakers&q=${q}" class="sv-category-card ${selectedCategory == 'Speakers' ? 'sv-category-active' : ''}" style="color:inherit;">
                <div class="sv-icon">&#128266;</div>
                <h5>Speakers</h5>
                <p>Portable and home speaker systems.</p>
            </a>
            <a href="/?category=Accessories&q=${q}" class="sv-category-card ${selectedCategory == 'Accessories' ? 'sv-category-active' : ''}" style="color:inherit;">
                <div class="sv-icon">&#128268;</div>
                <h5>Accessories</h5>
                <p>Cables, DACs, amps and more.</p>
            </a>
        </div>
		<!-- Search box: GET so results are shareable/bookmarkable, and
		            works the same for guests and logged-in users. -->
<form action="/" method="get" class="sv-search-row" style="display:flex; gap:10px; max-width:520px; margin-left:auto; margin-right:auto; margin-top:48px; margin-bottom:0;">
			           <input type="hidden" name="category" value="${selectedCategory}">
		           <input type="text" name="q" value="${q}" placeholder="Search products…" class="sv-input" style="flex:1;">
		           <button type="submit" class="sv-btn sv-btn-primary">Search</button>
		           <c:if test="${isFiltered}">
		               <a href="/" class="sv-btn sv-btn-outline">Clear</a>
		           </c:if>
		       </form>
    </section>

    <section class="sv-section" style="background:var(--sv-bg-elevated);">
        <div class="sv-section-head">
            <c:choose>
                <c:when test="${isFiltered}">
                    <h2>Search Results</h2>
                    <p>
                        <c:if test="${not empty q}">Matching "${q}"</c:if>
                        <c:if test="${not empty q and not empty selectedCategory}"> in </c:if>
                        <c:if test="${not empty selectedCategory}">${selectedCategory}</c:if>
                    </p>
                </c:when>
                <c:otherwise>
                    <h2>Featured Products</h2>
                    <p>A few favorites from the SonicVault catalog.</p>
                </c:otherwise>
            </c:choose>
        </div>
        <c:choose>
            <c:when test="${not empty featuredProducts}">
                <div class="sv-product-grid">
                    <c:forEach var="product" items="${featuredProducts}">
                        <div class="sv-product-card">
                            <div class="sv-product-img-wrap">
                                <img src="${product.imagePath}" alt="${product.name}">
                            </div>
                            <div class="sv-product-body">
                                <h5>${product.name}</h5>
                                <p class="sv-desc">${product.description}</p>
                                <div class="sv-price">&#8377;<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></div>
                                <div class="sv-card-actions">
                                    <a href="/products/${product.id}" class="sv-btn sv-btn-outline" style="flex:1; text-align:center;">View Details</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="sv-empty">
                    <div class="sv-empty-icon">&#128230;</div>
                    <p>
                        <c:choose>
                            <c:when test="${isFiltered}">No products matched your search — try a different keyword or category.</c:when>
                            <c:otherwise>No products yet — check back soon.</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="sv-section">
        <div class="sv-section-head">
            <h2>Why SonicVault</h2>
        </div>
        <div class="sv-why-grid">
            <div class="sv-why-card">
                <div class="sv-icon">&#9989;</div>
                <h5>Curated Quality</h5>
                <p style="color:var(--sv-text-muted); font-size:0.9rem;">Every product is tested for real-world sound quality, not just specs.</p>
            </div>
            <div class="sv-why-card">
                <div class="sv-icon">&#128230;</div>
                <h5>Fast, Tracked Shipping</h5>
                <p style="color:var(--sv-text-muted); font-size:0.9rem;">Your order ships quickly, with updates every step of the way.</p>
            </div>
            <div class="sv-why-card">
                <div class="sv-icon">&#128272;</div>
                <h5>Secure Checkout</h5>
                <p style="color:var(--sv-text-muted); font-size:0.9rem;">Payments are processed securely through Razorpay.</p>
            </div>
            <div class="sv-why-card">
                <div class="sv-icon">&#128172;</div>
                <h5>Real Support</h5>
                <p style="color:var(--sv-text-muted); font-size:0.9rem;">Questions about a product? We're happy to help you choose.</p>
            </div>
        </div>
    </section>

    <div class="sv-cta-band">
        <h2>Ready to upgrade your sound?</h2>
        <p style="margin-bottom:22px;">Browse the full SonicVault catalog and find your next favorite pair.</p>
        <a href="/products" class="sv-btn" style="padding:12px 28px; font-weight:700;">Shop Now</a>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
