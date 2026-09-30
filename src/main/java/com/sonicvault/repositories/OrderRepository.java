package com.sonicvault.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sonicvault.model.Order;
import com.sonicvault.model.User;

@Repository
public interface OrderRepository extends JpaRepository<Order, Integer> {
    // Additional custom queries can be defined here if needed
	List<Order> findByUser(User user);
}
