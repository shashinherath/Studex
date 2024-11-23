/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package studex.classes;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBHelper {

    private static final Logger logger = Logger.getLogger(DBHelper.class.getName());
    private static final String DB_URL = "jdbc:mysql://localhost:3306/studex_db?useSSL=false"; // Update with your DB URL
    private static final String DB_USER = "root"; // Your DB username
    private static final String DB_PASSWORD = "1234"; // Your DB password

    // Method to test the connection to the database
    public static String checkConnection() {
        String message = "Connection failed.";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            if (conn != null) {
                message = "Database connected successfully!";
            }
        } catch (SQLException e) {
            // Log the error message with the stack trace
            logger.log(Level.SEVERE, "Error: Unable to connect to the database!", e);
            message = "Error: Unable to connect to the database! Check the details below.";
        }
        return message;
    }

    // This method will validate the user credentials
    public static String validateUser(String username, String password) {
        String errorMessage = null;
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD); PreparedStatement stmt = conn.prepareStatement(query)) {

            // Set parameters for the query
            stmt.setString(1, username);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return null; // No error, credentials are valid
                } else {
                    errorMessage = "Invalid username or password!";
                }
            }

        } catch (SQLException e) {
            // Log the error message and stack trace if user validation fails
            logger.log(Level.SEVERE, "Error: Unable to validate user credentials! Please check your database.", e);
            errorMessage = "Error: Unable to validate user credentials! Please check your database.";
        }

        return errorMessage;
    }
}
