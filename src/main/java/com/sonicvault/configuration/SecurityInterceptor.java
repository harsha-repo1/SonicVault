package com.sonicvault.configuration;

import org.springframework.web.servlet.HandlerInterceptor;

import com.sonicvault.model.User;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Central place for the two things every protected page needs:
 *
 * 1) Making sure the visitor is actually logged in (and, for /admin/**,
 *    that they are an ADMIN) before the controller method ever runs.
 * 2) Telling the browser not to cache these pages, so pressing "Back"
 *    after logout re-requests the page from the server (and gets
 *    redirected to /login) instead of showing a cached copy from the
 *    browser's history.
 *
 * Keeping this logic in one interceptor -- instead of copy-pasted
 * "if (loggedInUser == null) ..." checks inside every controller
 * method -- is what makes it possible to guarantee every /admin/**
 * and /cart, /orders, /user URL is protected the same way.
 */
public class SecurityInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        // Never let the browser cache a protected, personalized page.
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);
        User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");

        String uri = request.getRequestURI();

        if (uri.startsWith("/admin")) {
            if (loggedInUser == null) {
                response.sendRedirect("/login");
                return false;
            }
            if (!"ADMIN".equals(loggedInUser.getRole())) {
                // A logged-in, non-admin user trying to reach an admin URL directly.
                response.sendRedirect("/products?error=AccessDenied");
                return false;
            }
            return true;
        }

        // Any signed-in-only area: cart, order history, profile.
        if (uri.startsWith("/cart") || uri.startsWith("/orders") || uri.startsWith("/user")) {
            if (loggedInUser == null) {
                response.sendRedirect("/login");
                return false;
            }
        }

        return true;
    }
}
