package com.sonicvault.service.impl;
import java.util.List;

import org.springframework.stereotype.Service;
import com.sonicvault.model.Order;
import com.sonicvault.model.User;
import com.sonicvault.repositories.OrderRepository;
import com.sonicvault.service.iface.OrderService;
@Service
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;

    public OrderServiceImpl(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    @Override
    public void saveOrder(Order order) {
        orderRepository.save(order);
    }

    @Override
    public List<Order> getOrdersForUser(User user) {
        return orderRepository.findByUser(user);
    }

    @Override
    public Order getOrderById(int id) {
        return orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + id));
    }

    @Override
    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }
}
