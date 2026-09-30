package com.sonicvault.controllers;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sonicvault.model.Product;
import com.sonicvault.service.iface.ProductService;

@Controller
public class IndexController {

    private final ProductService productService;

    public IndexController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/")
    public String home(@RequestParam(required = false) String q,
                        @RequestParam(required = false) String category,
                        Model model) {

        boolean filtering = (q != null && !q.trim().isEmpty()) || (category != null && !category.trim().isEmpty());

        if (filtering) {
            List<Product> results = productService.searchProducts(q, category, null, null);
            model.addAttribute("featuredProducts", results);
            model.addAttribute("isFiltered", true);
        } else {
            List<Product> products = productService.getAllProducts();
            List<Product> featured = products.size() > 4 ? products.subList(0, 4) : products;
            model.addAttribute("featuredProducts", featured);
            model.addAttribute("isFiltered", false);
        }

        model.addAttribute("q", q == null ? "" : q);
        model.addAttribute("selectedCategory", category == null ? "" : category);

        return "index";
    }
}