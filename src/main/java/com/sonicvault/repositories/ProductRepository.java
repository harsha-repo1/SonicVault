package com.sonicvault.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sonicvault.model.Product;

public interface ProductRepository extends JpaRepository<Product, Integer> {}