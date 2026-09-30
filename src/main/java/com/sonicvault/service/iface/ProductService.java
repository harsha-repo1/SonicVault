package com.sonicvault.service.iface;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.sonicvault.model.Product;

public interface ProductService {

    // Fixed category list used by both the admin "Add/Edit Product" dropdown
    // and the customer-facing category filter, so the two always stay in
    // sync. Add new categories here in one place.
    List<String> CATEGORIES = Arrays.asList("Headphones", "Earbuds", "Speakers", "Accessories", "Other");

    List<Product> getAllProducts();

    /**
     * Filters the catalog for the search/filter UI on the homepage and the
     * /products page. Any argument may be null/blank to skip that filter.
     */
    List<Product> searchProducts(String keyword, String category, Double minPrice, Double maxPrice);
    List<Product> getFilteredProducts(String category, String search);
    Product getProductById(int id);

    void saveProduct(Product product);

    void deleteProduct(int id);
    public String saveProductImage(MultipartFile imageFile) throws IOException;

	


  //  void updateProductStock(int productId, int quantity);
}
