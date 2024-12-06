package studex.classes;

import java.sql.*;
import javax.servlet.http.HttpSession;  // Add this import for HttpSession

public class AuthHandler {

    // Method to authenticate user with username and password
    public static String authenticateUser(String email, String password, HttpSession session) {
        String errorMessage = null;
        String query = "SELECT * FROM user WHERE email = ? AND password = ?";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            // Set parameters for the query
            stmt.setString(1, email);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    // Valid user, generate token and save to session
                    String sessionToken = TokenUtils.generateToken(email);
                    session.setAttribute("email", email);
                    session.setAttribute("sessionToken", sessionToken);
                    saveTokenToDatabase(email, sessionToken);  // Save the token in the database
                    return null; // No error, credentials are valid
                } else {
                    errorMessage = "Invalid email address or password!";
                }
            }
        } catch (SQLException e) {
            // Log the error message and stack trace if user validation fails
            errorMessage = "Error: Unable to validate user credentials! Please check your database.";
        }

        return errorMessage;
    }

    // Method to save the generated token to the database
    private static void saveTokenToDatabase(String email, String sessionToken) {
        String updateQuery = "UPDATE user SET token = ? WHERE email = ?";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(updateQuery)) {

            // Set the token and username in the query parameters
            stmt.setString(1, sessionToken);
            stmt.setString(2, email);

            // Execute the update query
            int rowsUpdated = stmt.executeUpdate();

            // Check if any rows were affected (i.e., the token was updated)
            if (rowsUpdated > 0) {
                System.out.println("Token updated successfully for user: " + email);
            } else {
                System.out.println("No rows updated. Check if the user exists in the database.");
            }

        } catch (SQLException e) {
            // Log the exception with the full stack trace for debugging
            System.err.println("Error updating token for user: " + email);
            e.printStackTrace();
        }
    }
}
