<%-- 
    Document   : fetchStudentResultByClass
    Created on : Dec 31, 2024, 3:50:00 PM
    Author     : Chamika Niroshan
--%>
<%@ page import="java.sql.*" %>
<%@ page import="studex.classes.DBHelper" %>
<%@ page contentType="application/json" %>
<%
    String classId = request.getParameter("classId");
    String year = request.getParameter("year");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // Establish the database connection
        conn = DBHelper.getConnection();

        // SQL query to fetch student results by class and year
        String query = "SELECT " +
                       "    s.student_id, " +
                       "    u.name AS student_name, " +
                       "    c.name AS class_name, " +
                       "    sub.name AS subject_name, " +
                       "    g.year, " +
                       "    g.semester, " +
                       "    g.mark " +
                       "FROM " +
                       "    Grades g " +
                       "JOIN Subject sub ON g.subject_id = sub.subject_id " +
                       "JOIN Student s ON g.user_id = s.user_id " +
                       "JOIN Enrolled e ON s.student_id = e.student_id " +
                       "JOIN Class c ON e.class_id = c.class_id " +
                       "JOIN User u ON s.user_id = u.user_id " +
                       "WHERE " +
                       "    c.class_id = ? " +
                       "    AND g.year = ? " +
                       "ORDER BY " +
                       "    s.student_id, g.semester, sub.name";

        stmt = conn.prepareStatement(query);
        stmt.setInt(1, Integer.parseInt(classId)); // Set the class ID parameter
        stmt.setInt(2, Integer.parseInt(year));    // Set the year parameter

        rs = stmt.executeQuery();

        // StringBuilder to build the JSON response
        StringBuilder json = new StringBuilder("[");

        // Iterate over the result set and build the JSON array
        while (rs.next()) {
            if (json.length() > 1) json.append(",");
            json.append("{")
                .append("\"studentId\":").append(rs.getInt("student_id")).append(",")
                .append("\"studentName\":\"").append(rs.getString("student_name")).append("\",")
                .append("\"className\":\"").append(rs.getString("class_name")).append("\",")
                .append("\"subjectName\":\"").append(rs.getString("subject_name")).append("\",")
                .append("\"year\":\"").append(rs.getString("year")).append("\",")
                .append("\"semester\":\"").append(rs.getString("semester")).append("\",")
                .append("\"mark\":\"").append(rs.getString("mark")).append("\"")
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


