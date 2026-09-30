package com.sonicvault.service.impl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.sonicvault.model.Product;
import com.sonicvault.repositories.ProductRepository;
import com.sonicvault.service.iface.ProductService;

@Service
public class ProductServiceImpl implements ProductService {
	
	
	// Injecting the upload directory from application.properties
    @Value("${file.upload-dir}")
    private String uploadDir;

    private final ProductRepository productRepository;

    public ProductServiceImpl(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Override
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    // Keyword -> category matching is no longer needed: Product now has a
    // real `category` column (set from the admin Add/Edit Product form),
    // so filtering is a direct, exact match against it.
    @Override
    public List<Product> searchProducts(String keyword, String category, Double minPrice, Double maxPrice) {
        String kw = keyword == null ? "" : keyword.trim().toLowerCase();
        String cat = category == null ? "" : category.trim();

        return productRepository.findAll().stream()
                .filter(p -> kw.isEmpty()
                        || (p.getName() != null && p.getName().toLowerCase().contains(kw))
                        || (p.getDescription() != null && p.getDescription().toLowerCase().contains(kw)))
                .filter(p -> cat.isEmpty() || cat.equalsIgnoreCase(p.getCategory()))
                .filter(p -> minPrice == null || p.getPrice() >= minPrice)
                .filter(p -> maxPrice == null || p.getPrice() <= maxPrice)
                .collect(Collectors.toList());
    }

    @Override
    public Product getProductById(int id) {
        // Returns null (rather than throwing) when the product isn't found
        // so callers -- e.g. ProductController -- can redirect cleanly with
        // a friendly "ProductNotFound" message instead of a 500 error page.
        return productRepository.findById(id).orElse(null);
    }

    @Override
    public void saveProduct(Product product) {
        productRepository.save(product);
    }

    @Override
    public void deleteProduct(int id) {
        productRepository.deleteById(id);
    }

    @Override
    public List<Product> getFilteredProducts(String category, String search) {
        String cat = category == null ? "" : category.trim();
        String term = search == null ? "" : search.trim().toLowerCase();

        return productRepository.findAll().stream()
                .filter(p -> cat.isEmpty() || cat.equalsIgnoreCase(p.getCategory()))
                .filter(p -> term.isEmpty()
                        || (p.getName() != null && p.getName().toLowerCase().contains(term))
                        || (p.getDescription() != null && p.getDescription().toLowerCase().contains(term)))
                .collect(java.util.stream.Collectors.toList());
    }
	/*
	 * @Override public void updateProductStock(int productId, int quantity) {
	 * Product product = getProductById(productId); // int updatedStock =
	 * product.getStock() - quantity; if (updatedStock < 0) { throw new
	 * RuntimeException("Insufficient stock for product ID: " + productId); } //
	 * product.setStock(updatedStock); productRepository.save(product); }
	 */
    
    
    // Method to save product image
    public String saveProductImage(MultipartFile imageFile) throws IOException {
        // Create a path using the directory from properties
        Path path = Paths.get(uploadDir, imageFile.getOriginalFilename());

        // Create the directory if it doesn't exist
        Files.createDirectories(path.getParent());

        // Transfer the file to the specified path
        imageFile.transferTo(path);

        // Return a root-relative URL ("/uploads/images/<filename>") instead
        // of the raw filesystem path. WebConfig maps "/uploads/images/**" to
        // this folder -- the previous version returned the bare filesystem
        // path (e.g. "uploads/images/foo.jpg", with OS-specific separators
        // on Windows), which browsers resolve relative to the *current*
        // page URL rather than the site root, so uploaded product images
        // broke on some pages depending on which URL they were viewed from.
        return "/uploads/images/" + imageFile.getOriginalFilename();
    }
    
   

   
    
    
    
}
