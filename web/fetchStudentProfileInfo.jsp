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

        // SQL query to fetch profile data
        String query = "SELECT " +
                       "    User.user_id, " +
                       "    User.email, " +
                       "    User.name, " +
                       "    User.enrollment_date, " +
                       "    User.phone_no, " +
                       "    User.user_type, " +
                       "    Student.guardian_name " +
                       "FROM " +
                       "    User " +
                       "JOIN " +
                       "    Student ON User.user_id = Student.user_id " +
                       "WHERE " +
                       "    User.user_id = ?";

        stmt = conn.prepareStatement(query);
        stmt.setInt(1, Integer.parseInt(userId)); // Set the user ID parameter

        rs = stmt.executeQuery();

        // Build the JSON response
        if (rs.next()) {
            StringBuilder json = new StringBuilder("{");
            json.append("\"user_id\":").append(rs.getInt("user_id")).append(",");
            json.append("\"email\":\"").append(rs.getString("email")).append("\",");
            json.append("\"name\":\"").append(rs.getString("name")).append("\",");
            json.append("\"enrollment_date\":\"").append(rs.getDate("enrollment_date")).append("\",");
            json.append("\"phone_no\":\"").append(rs.getString("phone_no")).append("\",");
            json.append("\"user_type\":\"").append(rs.getString("user_type")).append("\",");
            json.append("\"guardian_name\":\"").append(rs.getString("guardian_name")).append("\"");
            json.append("}");

            out.print(json.toString());
        } else {
            out.print("{}"); // Return empty JSON if no data found
        }
    } catch (SQLException e) {
        e.printStackTrace(); // Log the error
        out.print("{}"); // Return empty JSON on error
    } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
