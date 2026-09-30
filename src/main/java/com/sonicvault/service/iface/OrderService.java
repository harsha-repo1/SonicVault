package com.sonicvault.service.iface;
import java.util.List;
import com.sonicvault.model.Order;
import com.sonicvault.model.User;
public interface OrderService {
    void saveOrder(Order order);
    List<Order> getOrdersForUser(User user);
    Order getOrderById(int id);
    List<Order> getAllOrders();
}
