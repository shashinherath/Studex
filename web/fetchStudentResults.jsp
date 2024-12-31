<%-- 
    Document   : fetchStudentResults
    Created on : Dec 31, 2024, 1:37:27?PM
    Author     : Chamika Niroshan
--%>
<%@ page import="java.sql.*" %>
<%@ page import="studex.classes.DBHelper" %>
<%@ page contentType="application/json" %>
<%
    String userId = request.getParameter("userId");
    String year = request.getParameter("year");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // Establish the database connection
        conn = DBHelper.getConnection();

        // SQL query to fetch grades and subject name
        String query = "SELECT Grades.*, Subject.name AS name " +
                       "FROM Grades " +
                       "JOIN Subject ON Grades.subject_id = Subject.subject_id " +
                       "WHERE Grades.user_id = ? AND year = ?";
        
        stmt = conn.prepareStatement(query);
        stmt.setInt(1, Integer.parseInt(userId));  // Set the user ID parameter
        stmt.setInt(2, Integer.parseInt(year));    // Set the year parameter
        
        rs = stmt.executeQuery();

        // StringBuilder to build the JSON response
        StringBuilder json = new StringBuilder("[");

        // Iterate over the result set and build the JSON array
        while (rs.next()) {
            if (json.length() > 1) json.append(",");
            json.append("{")
                .append("\"gradeId\":").append(rs.getInt("grade_id")).append(",")
                .append("\"userId\":").append(rs.getInt("user_id")).append(",")
                .append("\"subjectId\":").append(rs.getInt("subject_id")).append(",")
                .append("\"year\":\"").append(rs.getString("year")).append("\",")
                .append("\"semester\":\"").append(rs.getString("semester")).append("\",")
                .append("\"grade\":\"").append(rs.getString("mark")).append("\",")
                .append("\"subjectName\":\"").append(rs.getString("name")).append("\"")
                .append("}");
        }

        json.append("]");

        // Send the JSON response back to the frontend
        out.print(json.toString());
    } catch (SQLException e) {
        e.printStackTrace(); // Handle the error appropriately
        out.print("[]"); // Return an empty JSON array on error
    } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>

