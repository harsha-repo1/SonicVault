<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login or Sign Up — SonicVault</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="sv-auth-wrap">
        <div class="sv-auth-card">

            <div class="sv-auth-tabs" id="svAuthTabs">
                <div class="sv-tab-slider"></div>
                <button type="button" id="svTabLogin" class="sv-tab-active" onclick="svShowLogin()">Login</button>
                <button type="button" id="svTabSignup" onclick="svShowSignup()">Sign Up</button>
            </div>

            <div class="sv-auth-forms">
                <!-- LOGIN FORM -->
                <div class="sv-auth-form" id="svLoginForm">
                    <h3>Welcome back</h3>
                    <p class="sv-subtitle">Log in to continue to SonicVault</p>

                    <c:if test="${not empty error}">
                        <div class="sv-alert sv-alert-danger">${error}</div>
                    </c:if>
                    <c:if test="${param.registered == 'true'}">
                        <div class="sv-alert sv-alert-success">Account created — please log in.</div>
                    </c:if>

                    <form action="/login" method="post">
                        <div class="sv-form-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" class="sv-input" required autocomplete="username">
                        </div>
                        <div class="sv-form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" class="sv-input" required autocomplete="current-password">
                        </div>
                        <button type="submit" class="sv-submit-btn">Log In</button>
                    </form>

                    <div class="sv-auth-switch">
                        New to SonicVault? <a href="javascript:void(0)" onclick="svShowSignup()">Create an account</a>
                    </div>
                </div>

                <!-- SIGNUP FORM -->
                <div class="sv-auth-form sv-hide-right" id="svSignupForm">
                    <h3>Create your account</h3>
                    <p class="sv-subtitle">Join SonicVault in a few seconds</p>

                    <c:if test="${not empty registerError}">
                        <div class="sv-alert sv-alert-danger">${registerError}</div>
                    </c:if>

                    <form action="/register" method="post">
                        <div class="sv-form-group">
                            <label for="reg-username">Username</label>
                            <input type="text" id="reg-username" name="username" class="sv-input" required>
                        </div>
                        <div class="sv-form-group">
                            <label for="reg-email">Email</label>
                            <input type="email" id="reg-email" name="email" class="sv-input" required>
                        </div>
                        <div class="sv-form-group">
                            <label for="reg-phone">Phone Number</label>
                            <%-- <input type="text" id="reg-phone" name="phoneNumber" class="sv-input" required> --%>
							<input type="tel" id="reg-phone" name="phoneNumber" class="sv-input"
							       pattern="[0-9]{10}" maxlength="10" inputmode="numeric"
							       title="Enter a 10-digit mobile number"
							       oninput="this.value=this.value.replace(/[^0-9]/g,'').slice(0,10)"
							       required>
                        </div>
                        <div class="sv-form-group">
                            <label for="reg-password">Password</label>
                            <input type="password" id="reg-password" name="password" class="sv-input" required>
                        </div>
                        <div class="sv-form-group">
                            <label for="reg-confirm">Confirm Password</label>
                            <input type="password" id="reg-confirm" name="confirmPassword" class="sv-input" required>
                        </div>
                        <button type="submit" class="sv-submit-btn">Create Account</button>
                    </form>

                    <div class="sv-auth-switch">
                        Already have an account? <a href="javascript:void(0)" onclick="svShowLogin()">Log in</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        var svTabs = document.getElementById('svAuthTabs');
        var svTabLogin = document.getElementById('svTabLogin');
        var svTabSignup = document.getElementById('svTabSignup');
        var svLoginForm = document.getElementById('svLoginForm');
        var svSignupForm = document.getElementById('svSignupForm');

        function svShowLogin() {
            svTabs.classList.remove('sv-show-signup');
            svTabLogin.classList.add('sv-tab-active');
            svTabSignup.classList.remove('sv-tab-active');
            svLoginForm.classList.remove('sv-hide-left');
            svSignupForm.classList.add('sv-hide-right');
            svSignupForm.classList.remove('sv-hide-left');
        }

        function svShowSignup() {
            svTabs.classList.add('sv-show-signup');
            svTabSignup.classList.add('sv-tab-active');
            svTabLogin.classList.remove('sv-tab-active');
            svSignupForm.classList.remove('sv-hide-right');
            svSignupForm.classList.remove('sv-hide-left');
            svLoginForm.classList.add('sv-hide-left');
        }

        // Deep-link support (#signup from the navbar's Sign Up button) and
        // re-opening the signup tab automatically if the server re-rendered
        // this page because of a registration error.
        var activeTab = "${activeTab}";
        if (window.location.hash === '#signup' || activeTab === 'signup') {
            svShowSignup();
        }
    </script>
</body>
</html>
