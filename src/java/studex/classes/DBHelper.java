package studex.classes;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBHelper {

    private static final Logger logger = Logger.getLogger(DBHelper.class.getName());
    private static final String DB_URL = "jdbc:mysql://localhost:3306/studex_db?useSSL=false"; // Update with your DB URL
    private static final String DB_USER = "root"; // Your DB username
    private static final String DB_PASSWORD = "1234"; // Your DB password

    // Method to establish and return a database connection
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    // Method to test the connection to the database
    public static String checkConnection() {
        String message = "Connection failed.";
        try (Connection conn = getConnection()) {
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
}
