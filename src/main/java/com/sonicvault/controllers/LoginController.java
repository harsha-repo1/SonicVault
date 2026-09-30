package com.sonicvault.controllers;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sonicvault.model.User;
import com.sonicvault.service.iface.UserService;
import com.sonicvault.service.impl.EmailService;

/**
 * Handles the public-facing authentication screen: a single page (login.jsp)
 * that shows both the Login form and the Sign Up form, switched with a
 * JS/CSS slide animation (see login.jsp). Both forms post back to this
 * controller.
 *
 * Registration always saves the new account with role=USER on the server
 * side -- the public sign-up form has no role selector, so a guest can never
 * grant themselves ADMIN. Creating ADMIN accounts is only possible from the
 * admin-only /admin/users screens (UserController).
 */
@Controller
public class LoginController {

    private final UserService userService;
    private final EmailService emailService;

    public LoginController(UserService userService, EmailService emailService) {
        this.userService = userService;
        this.emailService = emailService;
    }

    // Display the combined login / signup page
    @GetMapping("/login")
    public String showLoginPage(HttpSession session) {
        // If the user is already logged in, sending them back to /login is
        // confusing (and was one of the "broken navigation" complaints) --
        // just take them to where they belong.
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser != null) {
            return "ADMIN".equals(loggedInUser.getRole()) ? "redirect:/admin/dashboard" : "redirect:/products";
        }
        return "login"; // login.jsp
    }

    // Handle login form submission
    @PostMapping("/login")
    public String login(@RequestParam String username, @RequestParam String password, HttpSession session, Model model) {
        User user = userService.authenticate(username, password);
        if (user != null) {
            session.setAttribute("loggedInUser", user);
            session.setAttribute("role", user.getRole());
            return "ADMIN".equals(user.getRole()) ? "redirect:/admin/dashboard" : "redirect:/products";
        }
        model.addAttribute("error", "Invalid username or password.");
        model.addAttribute("activeTab", "login");
        return "login";
    }

    // Handle public self-registration (role is always USER)
    @PostMapping("/register")
    public String register(@RequestParam String username,
                            @RequestParam String password,
                            @RequestParam String confirmPassword,
                            @RequestParam String phoneNumber,
                            @RequestParam String email,
                            Model model) {

        if (!password.equals(confirmPassword)) {
            model.addAttribute("registerError", "Passwords do not match.");
            model.addAttribute("activeTab", "signup");
            return "login";
        }
        if (userService.findByUsername(username) != null) {
            model.addAttribute("registerError", "That username is already taken.");
            model.addAttribute("activeTab", "signup");
            return "login";
        }
        if (userService.findByEmail(email) != null) {
            model.addAttribute("registerError", "That email is already registered.");
            model.addAttribute("activeTab", "signup");
            return "login";
        }

        // Role is hard-coded here -- never taken from the request -- so a
        // guest can never sign themselves up as an ADMIN.
        userService.createUser(username, password, "USER", phoneNumber, email);

        // A failed welcome email should never make the user think their
        // registration itself failed (it already succeeded above), so this
        // is isolated in its own try/catch and only logged on failure.
        try {
            String subject = "Welcome to SonicVault!";
            String body = "<h1>Thanks for joining SonicVault, " + username + "!</h1>"
                    + "<p>Your account has been created. Start exploring premium audio gear now.</p>";
            emailService.sendEmail(email, subject, body);
        } catch (Exception e) {
            System.err.println("[EmailService] Welcome email could not be sent to " + email + ": " + e.getMessage());
        }

        return "redirect:/login?registered=true";
    }

    // Handle logout and invalidate session
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // Clear session so nothing from this user survives
        return "redirect:/login";
    }
}
