package dao;

import models.Cart;
import utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    // Add product to cart (or update quantity if already exists)
    public boolean addToCart(int userId, int productId, int quantity) {
        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement updateStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();

            // Check if product already in cart
            String checkSql = "SELECT quantity FROM cart WHERE user_id = ? AND product_id = ?";
            checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, userId);
            checkStmt.setInt(2, productId);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Update existing quantity
                int newQuantity = rs.getInt("quantity") + quantity;
                String updateSql = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
                updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setInt(1, newQuantity);
                updateStmt.setInt(2, userId);
                updateStmt.setInt(3, productId);
                return updateStmt.executeUpdate() > 0;
            } else {
                // Insert new item
                String insertSql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
                insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, userId);
                insertStmt.setInt(2, productId);
                insertStmt.setInt(3, quantity);
                return insertStmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(rs, checkStmt, updateStmt, insertStmt);
        }
    }

    // Get all cart items for a user
    public List<Cart> getCartItemsByUserId(int userId) {
        String sql = "SELECT c.id, c.user_id, c.product_id, c.quantity, " +
                     "p.name, p.price, p.image_url " +
                     "FROM cart c " +
                     "JOIN products p ON c.product_id = p.id " +
                     "WHERE c.user_id = ?";
        List<Cart> cartItems = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Cart cart = new Cart();
                    cart.setId(rs.getInt("id"));
                    cart.setUserId(rs.getInt("user_id"));
                    cart.setProductId(rs.getInt("product_id"));
                    cart.setQuantity(rs.getInt("quantity"));
                    // You can extend Cart model or create a CartItem view model later
                    cartItems.add(cart);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    // Update quantity of a cart item
    public boolean updateCartItemQuantity(int cartId, int quantity) {
        if (quantity <= 0) {
            return removeCartItem(cartId);
        }
        String sql = "UPDATE cart SET quantity = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setInt(2, cartId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Remove item from cart
    public boolean removeCartItem(int cartId) {
        String sql = "DELETE FROM cart WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cartId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Clear entire cart (after checkout)
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            return stmt.executeUpdate() >= 0; // OK even if cart was empty

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Utility method to close resources
    private void closeResources(ResultSet rs, PreparedStatement... statements) {
        try {
            if (rs != null && !rs.isClosed()) rs.close();
            for (PreparedStatement stmt : statements) {
                if (stmt != null && !stmt.isClosed()) stmt.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}