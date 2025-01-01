<%-- 
    Document   : fetchGrades
    Created on : Jan 1, 2025, 8:58:20?PM
    Author     : Chamika Niroshan
--%>

<%@ page import="java.sql.*" %>
<%@ page import="studex.classes.DBHelper" %>
<%@ page contentType="application/json" %>
<%
    String userId = request.getParameter("userId");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // Establish the database connection
        conn = DBHelper.getConnection();

        // SQL query to fetch grades
        String query = "SELECT " +
                       "    Grades.grade_id, " +
                       "    Grades.year, " +
                       "    Grades.semester, " +
                       "    Grades.mark, " +
                       "    Subject.name AS subject_name " +
                       "FROM " +
                       "    Grades " +
                       "JOIN " +
                       "    Subject ON Grades.subject_id = Subject.subject_id " +
                       "WHERE " +
                       "    Grades.user_id = ?";

        stmt = conn.prepareStatement(query);
        stmt.setInt(1, Integer.parseInt(userId)); // Set the user ID parameter

        rs = stmt.executeQuery();

        // Build the JSON response
        StringBuilder json = new StringBuilder("[");
        while (rs.next()) {
            if (json.length() > 1) json.append(","); // Add a comma between records
            json.append("{");
            json.append("\"grade_id\":").append(rs.getInt("grade_id")).append(",");
            json.append("\"year\":\"").append(rs.getString("year")).append("\",");
            json.append("\"semester\":\"").append(rs.getString("semester")).append("\",");
            json.append("\"mark\":\"").append(rs.getString("mark")).append("\",");
            json.append("\"subject_name\":\"").append(rs.getString("subject_name")).append("\"");
            json.append("}");
        }
        json.append("]");

        out.print(json.toString());
    } catch (SQLException e) {
        e.printStackTrace(); // Log the error
        out.print("[]"); // Return empty JSON array on error
    } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
