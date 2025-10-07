
package servlets;

import dao.*;
import models.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/consumer/order-servlet", "/farmer/order-servlet"})
public class OrderServlet extends HttpServlet {
    private CartDAO cartDAO;
    private ProductDAO productDAO;
    private OrderDAO orderDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("../login.jsp?error=Please login first.");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"consumer".equals(user.getRole())) {
            response.sendRedirect("../login.jsp?error=Access denied.");
            return;
        }

        String action = request.getParameter("action");
        if ("place".equals(action)) {
            placeOrder(request, response, user);
        } else {
            response.sendRedirect("cart.jsp?error=Invalid action.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("../login.jsp?error=Please login first.");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String role = user.getRole();
        String action = request.getParameter("action");
        if ("showCheckout".equals(action)) {
            forwardToCheckout(request, response, user.getId());
            return;
        }
        if ("consumer".equals(role)) {
            // Consumer: View their own orders
            List<Order> orders = orderDAO.getOrdersByConsumerId(user.getId());
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/consumer/view-orders.jsp").forward(request, response);

        } else if ("farmer".equals(role)) {
            // Farmer: View orders for their products
            List<Order> orders = orderDAO.getOrdersByFarmerId(user.getId());

            // Enrich with product and consumer names
            for (Order order : orders) {
                Product product = productDAO.getProductById(order.getProductId());
                User consumer = userDAO.getUserById(order.getConsumerId());

                if (product != null) {
                    request.setAttribute("productName_" + order.getId(), product.getName());
                }
                if (consumer != null) {
                    request.setAttribute("consumerName_" + order.getId(), consumer.getName());
                }
            }

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/farmer/view-orders.jsp").forward(request, response);

        } else {
            response.sendRedirect("../index.jsp");
        }
     // Inside OrderServlet.java doGet()
        
    }
    private void forwardToCheckout(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {
        List<Cart> cartItems = cartDAO.getCartItemsByUserId(userId);
        double totalAmount = 0.0;

        for (Cart item : cartItems) {
            Product product = productDAO.getProductById(item.getProductId());
            if (product != null) {
                totalAmount += product.getPrice() * item.getQuantity();
            }
        }

        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("/consumer/checkout.jsp").forward(request, response);
        // ✅ No more code after forward
    }
    private void placeOrder(HttpServletRequest request, HttpServletResponse response, User consumer)
            throws ServletException, IOException {
        List<Cart> cartItems = cartDAO.getCartItemsByUserId(consumer.getId());
        if (cartItems.isEmpty()) {
            response.sendRedirect("cart.jsp?error=Your cart is empty.");
            return;
        }

        boolean allOrdersPlaced = true;
        double totalOrderAmount = 0.0;

        for (Cart cartItem : cartItems) {
            Product product = productDAO.getProductById(cartItem.getProductId());
            if (product == null) {
                allOrdersPlaced = false;
                continue;
            }

            if (product.getQuantity() < cartItem.getQuantity()) {
                request.setAttribute("error", "Not enough stock for: " + product.getName());
                request.getRequestDispatcher("/consumer/cart.jsp").forward(request, response);
                return;
            }

            double totalPrice = product.getPrice() * cartItem.getQuantity();
            boolean success = orderDAO.placeOrder(
                consumer.getId(),
                product.getId(),
                cartItem.getQuantity(),
                totalPrice
            );

            if (success) {
                // Update product quantity
                int newQuantity = product.getQuantity() - cartItem.getQuantity();
                productDAO.updateProductQuantity(product.getId(), newQuantity);
                totalOrderAmount += totalPrice;
            } else {
                allOrdersPlaced = false;
            }
        }

        if (allOrdersPlaced) {
            // Clear cart
            cartDAO.clearCart(consumer.getId());

            // ✅ Forward to checkout with total amount
            request.setAttribute("totalAmount", totalOrderAmount);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/consumer/checkout.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendRedirect("cart.jsp?error=Some items failed to order.");
        }
    }
}