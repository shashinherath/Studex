<%@page import="java.util.Enumeration"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="studex.classes.DBHelper" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%
    String message = "";
    String status = "failure";
    
    // Fetch userId, newPassword and confirmPassword from the form submission
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");
    String userIdString = request.getParameter("userId");
    System.out.println(newPassword);
    System.out.println(confirmPassword);
    
    // Validate if passwords match
    if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
        message = "Passwords do not match.";
    } else {
        try {
            // Hash the password using SHA-256
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(newPassword.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashedBytes) {
                hexString.append(Integer.toHexString(0xFF & b));
            }
            String hashedPassword = hexString.toString(); // Store this hashed password

            // Proceed with updating the password in the database
            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                // Establish database connection
                conn = DBHelper.getConnection();
                
                // SQL query to update the password
                String query = "UPDATE User SET password = ? WHERE user_id = ?";
                
                // Prepare the statement
                stmt = conn.prepareStatement(query);
                stmt.setString(1, hashedPassword);  // Set the hashed password
                stmt.setInt(2, Integer.parseInt(userIdString));  // Set the userId
                
                // Execute the update
                int rowsUpdated = stmt.executeUpdate();
                
                // Respond based on the update result
                if (rowsUpdated > 0) {
                    message = "Password updated successfully.";
                    status = "success";
                } else {
                    message = "Failed to update password.";
                }
                
            } catch (SQLException e) {
                message = "Error: " + e.getMessage();
            } finally {
                // Close resources
                if (stmt != null) {
                    try {
                        stmt.close();
                    } catch (SQLException ignored) {}
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException ignored) {}
                }
            }
        } catch (NoSuchAlgorithmException e) {
            message = "Error: Unable to hash password.";
            status = "failure";
        } catch (UnsupportedEncodingException e) {
            message = "Error: Unsupported encoding.";
            status = "failure";
        }
    }
    
    // Send the status and message back as HTML to display
    out.print("<div id='statusMessage' class='" + status + "'>" + message + "</div>");
%>
