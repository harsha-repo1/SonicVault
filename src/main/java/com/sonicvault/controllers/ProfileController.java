package com.sonicvault.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.sonicvault.model.User;

import jakarta.servlet.http.HttpSession;

/**
 * A signed-in customer's own account details. Protected by
 * SecurityInterceptor (path /user/**).
 */
@Controller
public class ProfileController {

    @GetMapping("/user/profile")
    public String profile(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        model.addAttribute("user", loggedInUser);
        return "profile";
    }
}
