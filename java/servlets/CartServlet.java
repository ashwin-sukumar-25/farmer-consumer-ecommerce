
package servlets;

import dao.CartDAO;
import dao.ProductDAO;
import models.Cart;
import models.Product;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/consumer/cart-servlet")
public class CartServlet extends HttpServlet {
    private CartDAO cartDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        productDAO = new ProductDAO();
    }

 // Inside CartServlet.java
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
        int userId = user.getId();

        // Default: view cart
        if (action == null) {
            forwardToCartPage(request, response, userId);
            return;
        }

        switch (action) {
            case "add":
                handleAddToCart(request, response, userId);
                break;
            case "update":
                handleUpdateCart(request, response);
                break;
            case "remove":
                handleRemoveFromCart(request, response);
                break;
            default:
                forwardToCartPage(request, response, userId);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to GET for consistency
        doGet(request, response);
    }

 // Inside CartServlet.java - handleAddToCart()
    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");

        if (productIdStr == null || quantityStr == null) {
            request.setAttribute("error", "Invalid request.");
            new ProductServlet().doGet(request, response); // Forward to product loader
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);

            Product product = productDAO.getProductById(productId);
            if (product == null) {
                request.setAttribute("error", "Product not found.");
                new ProductServlet().doGet(request, response);
                return;
            }

            if (product.getQuantity() < quantity) {
                request.setAttribute("error", "Not enough stock.");
                new ProductServlet().doGet(request, response);
                return;
            }

            boolean success = cartDAO.addToCart(userId, productId, quantity);
            if (success) {
                request.setAttribute("msg", "✅ Added to cart!");
            } else {
                request.setAttribute("error", "Failed to add.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid input.");
        }

        // ✅ Forward to ProductServlet (which loads products)
        new ProductServlet().doGet(request, response);
    }

 // Inside CartServlet.java
    private void handleUpdateCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String cartIdStr = request.getParameter("cartId");
        String quantityStr = request.getParameter("quantity");

        if (cartIdStr == null || quantityStr == null) {
            request.setAttribute("error", "Invalid request.");
            forwardToCartPage(request, response, getUserIdFromSession(request));
            return;
        }

        try {
            int cartId = Integer.parseInt(cartIdStr);
            int quantity = Integer.parseInt(quantityStr);

            boolean success = cartDAO.updateCartItemQuantity(cartId, quantity);

            // ✅ Always forward, never redirect with messages
            if (success) {
                request.setAttribute("msg", "Cart updated!");
            } else {
                request.setAttribute("error", "Failed to update.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid quantity.");
        }

        forwardToCartPage(request, response, getUserIdFromSession(request));
    }
    private int getUserIdFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        return user.getId();
    }
    
    private void handleRemoveFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String cartIdStr = request.getParameter("cartId");
        if (cartIdStr == null) {
            request.setAttribute("error", "Invalid request.");
            forwardToCartPage(request, response, getUserIdFromSession(request));
            return;
        }

        try {
            int cartId = Integer.parseInt(cartIdStr);
            boolean removed = cartDAO.removeCartItem(cartId);

            if (removed) {
                request.setAttribute("msg", "Item removed.");
            } else {
                request.setAttribute("error", "Failed to remove.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid item.");
        }

        // ✅ Forward back to cart (not redirect)
        forwardToCartPage(request, response, getUserIdFromSession(request));
    }

    private void forwardToCartPage(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {
        List<Cart> cartItems = cartDAO.getCartItemsByUserId(userId);
        double totalAmount = 0.0;

        for (Cart item : cartItems) {
            Product product = productDAO.getProductById(item.getProductId());
            if (product != null) {
                double price = product.getPrice();
                totalAmount += price * item.getQuantity();

                // ✅ Set dynamic attributes for JSP
                request.setAttribute("productName_" + item.getProductId(), product.getName());
                request.setAttribute("productImage_" + item.getProductId(), 
                    product.getImageUrl() != null ? product.getImageUrl() : "https://via.placeholder.com/60x60");
                request.setAttribute("price_" + item.getProductId(), price);
            }
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);

        // ✅ Forward to JSP
        request.getRequestDispatcher("/consumer/cart.jsp").forward(request, response);
    }
}