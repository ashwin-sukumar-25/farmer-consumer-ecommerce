package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/farmer_consumer_db";
    private static final String USERNAME = "root";  // Change as per your setup
    private static final String PASSWORD = "root"; // Change to your MySQL password

    private static Connection connection = null;

    // Private constructor to prevent instantiation
    private DatabaseConnection() {}

    // Method to get the connection (Singleton pattern)
    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            } catch (ClassNotFoundException e) {
                throw new SQLException("MySQL Driver not found", e);
            } catch (SQLException e) {
                throw new SQLException("Database connection failed", e);
            }
        }
        return connection;
    }

    // Optional: Close connection (usually managed by connection pool in production)
    public static void closeConnection() throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }
}