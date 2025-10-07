package dao;

import models.Message;
import utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    // Send a new message
    public boolean sendMessage(int senderId, int receiverId, Integer productId, String message) {
        String sql = "INSERT INTO messages (sender_id, receiver_id, product_id, message) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, senderId);
            stmt.setInt(2, receiverId);
            stmt.setObject(3, productId); // Use setObject to handle null
            stmt.setString(4, message);

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all messages between two users (conversation)
    public List<Message> getConversation(int userId1, int userId2) {
        String sql = "SELECT id, sender_id, receiver_id, product_id, message, sent_at, is_read " +
                     "FROM messages " +
                     "WHERE (sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?) " +
                     "ORDER BY sent_at ASC";
        List<Message> messages = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId1);
            stmt.setInt(2, userId2);
            stmt.setInt(3, userId2);
            stmt.setInt(4, userId1);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Message msg = new Message();
                    msg.setId(rs.getInt("id"));
                    msg.setSenderId(rs.getInt("sender_id"));
                    msg.setReceiverId(rs.getInt("receiver_id"));
                    msg.setProductId(rs.getObject("product_id", Integer.class)); // Handles null
                    msg.setMessage(rs.getString("message"));
                    msg.setSentAt(rs.getTimestamp("sent_at"));
                    msg.setRead(rs.getBoolean("is_read"));
                    messages.add(msg);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }

    // Get inbox: all messages received by a user (with sender info)
    public List<Message> getInboxWithSender(int receiverId) {
        String sql = "SELECT m.id, m.sender_id, m.receiver_id, m.product_id, m.message, " +
                     "m.sent_at, m.is_read, u.name AS sender_name " +
                     "FROM messages m " +
                     "JOIN users u ON m.sender_id = u.id " +
                     "WHERE m.receiver_id = ? " +
                     "ORDER BY m.sent_at DESC";
        List<Message> messages = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, receiverId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Message msg = new Message();
                    msg.setId(rs.getInt("id"));
                    msg.setSenderId(rs.getInt("sender_id"));
                    msg.setReceiverId(rs.getInt("receiver_id"));
                    msg.setProductId(rs.getObject("product_id", Integer.class));
                    msg.setMessage(rs.getString("message"));
                    msg.setSentAt(rs.getTimestamp("sent_at"));
                    msg.setRead(rs.getBoolean("is_read"));
                    // You can extend this model or create a view object to include sender_name
                    messages.add(msg);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }

    // Mark all messages from a sender as read
    public boolean markAsRead(int senderId, int receiverId) {
        String sql = "UPDATE messages SET is_read = TRUE " +
                     "WHERE sender_id = ? AND receiver_id = ? AND is_read = FALSE";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, senderId);
            stmt.setInt(2, receiverId);
            stmt.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get number of unread messages for a user
    public int getUnreadMessageCount(int receiverId) {
        String sql = "SELECT COUNT(*) AS count FROM messages " +
                     "WHERE receiver_id = ? AND is_read = FALSE";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, receiverId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}