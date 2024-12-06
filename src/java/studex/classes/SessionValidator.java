package studex.classes;

import java.sql.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class SessionValidator {

    // Method to validate the session and user authorization
    public static boolean isSessionValid(HttpServletRequest request) {
        // Get the session object
        HttpSession session = request.getSession(false); // false means don't create a new session if it doesn't exist
        
        System.out.println("SessionValidator: Checking session validity...");

        if (session != null) {
            // Get the session token from the session
            String sessionToken = (String) session.getAttribute("sessionToken");
            String email = (String) session.getAttribute("email");

            System.out.println("SessionValidator: Found session, email: " + email);
            System.out.println("SessionValidator: Session token: " + sessionToken);

            // Check if sessionToken exists and if the token is valid
            if (sessionToken != null && !sessionToken.isEmpty()) {
                System.out.println("SessionValidator: Session token is not null or empty.");

                // Optionally, check if the token exists in the database (to confirm validity)
                String storedToken = getSessionTokenFromDatabase(email);
                System.out.println("SessionValidator: Stored token from DB: " + storedToken);

                if (sessionToken.equals(storedToken)) {
                    System.out.println("SessionValidator: Token match successful. Valid session.");
                    return true; // Valid session and user
                } else {
                    System.out.println("SessionValidator: Token mismatch. Invalid session.");
                }
            } else {
                System.out.println("SessionValidator: Session token is null or empty.");
            }
        } else {
            System.out.println("SessionValidator: No session found.");
        }
        
        return false; // Invalid session
    }

    // Method to retrieve the session token from the database
    private static String getSessionTokenFromDatabase(String email) {
        String sessionToken = null;
        String query = "SELECT token FROM user WHERE email = ?";

        System.out.println("SessionValidator: Retrieving session token from database for username: " + email);

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    sessionToken = rs.getString("token");
                    System.out.println("SessionValidator: Found session token in database: " + sessionToken);
                } else {
                    System.out.println("SessionValidator: No session token found in database for username: " + email);
                }
            }

        } catch (SQLException e) {
            System.out.println("SessionValidator: Error while retrieving session token from database.");
            e.printStackTrace();
        }

        return sessionToken;
    }
}
