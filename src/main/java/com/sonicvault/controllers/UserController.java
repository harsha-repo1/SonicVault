package com.sonicvault.controllers;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.sonicvault.model.User;
import com.sonicvault.service.iface.UserService;
import com.sonicvault.service.impl.EmailService;

/**
 * Admin-only user management (list / create / edit / delete ANY user,
 * including other admins). Lives under /admin/users so it's covered by
 * SecurityInterceptor's admin-only check -- previously these methods had
 * no authorization check at all, so any visitor who guessed the URL could
 * create, edit or delete accounts.
 *
 * This is intentionally separate from public self-registration, which is
 * handled by LoginController's POST /register and always forces role=USER.
 */
@Controller
@RequestMapping("/admin/users")
public class UserController {

	 @Autowired
	    private EmailService emailService;

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    // Display list of users
    @GetMapping
    public String listUsers(Model model) {
        List<User> users = userService.getAllUsers();
        model.addAttribute("users", users);
        return "user-list"; // JSP page to list users
    }

    // Show user creation form
    @GetMapping("/create")
    public String showCreateUserForm(Model model) {
        model.addAttribute("user", new User()); // For binding form input
        return "user-create"; // JSP page to create a new user
    }

    // Handle user creation form submission
 // Handle user creation form submission
    @PostMapping("/create")
    public String createUser(@ModelAttribute User user, Model model) {
        try {
            // Save the user to the database
            userService.createUser(user.getUsername(), user.getPassword(), user.getRole(), user.getPhone_number(), user.getEmail());

            try {
                String subject = "Welcome to SonicVault!";
                String body = "<h1>Welcome to SonicVault, " + user.getUsername() + "!</h1>"
                        + "<p>An account has been created for you.</p>"
                        + "<p><strong>Username:</strong> " + user.getUsername() + "<br>"
                        + "<strong>Password:</strong> " + user.getPassword() + "</p>"
                        + "<p>Please log in and change your password.</p>";
                emailService.sendEmail(user.getEmail(), subject, body);
            } catch (Exception e) {
                System.err.println("[EmailService] Welcome email could not be sent to " + user.getEmail() + ": " + e.getMessage());
            }

            return "redirect:/admin/users";
        } catch (Exception e) {
            model.addAttribute("error", "Failed to create user: " + e.getMessage());
            return "user-create";
        }
    }
    // Show user edit form
    @GetMapping("/edit/{id}")
    public String showEditUserForm(@PathVariable("id") int id, Model model) {
        User user = userService.getUserById(id);
        model.addAttribute("user", user); // Populate form with existing user data
        return "user-edit"; // JSP page to edit the user
    }

    // Handle user update form submission
    @PostMapping("/update/{id}")
    public String updateUser(@PathVariable("id") int id, @ModelAttribute User user) {
        userService.updateUser(id, user.getUsername(), user.getPassword(), user.getRole(), user.getPhone_number(), user.getEmail());
        return "redirect:/admin/users"; // After updating, redirect to user list
    }

    // Handle user deletion
    @GetMapping("/delete/{id}")
    public String deleteUser(@PathVariable("id") int id) {
        userService.deleteUser(id);
        return "redirect:/admin/users"; // After deleting, redirect to user list
    }
}
