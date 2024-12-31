<%@ page contentType="application/json" %>
<%@ page import="java.sql.*" %>
<%@ page import="studex.classes.DBHelper" %>
<%
    // Parse the received JSON data (from the frontend)
    String jsonData = request.getReader().lines().collect(java.util.stream.Collectors.joining());

    // Print the received data for debugging
    System.out.println("Received data: " + jsonData);

    // Create connection variables
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // Establish the database connection
        conn = DBHelper.getConnection();

        // Remove any enclosing brackets ([]) and split the data on '},{' to process each object
        jsonData = jsonData.replace("[", "").replace("]", "");
        String[] resultsData = jsonData.split("},\\{");

        // Prepare the insert statement
        String query = "INSERT INTO Grades (user_id, subject_id, year, semester, mark) VALUES ";

        StringBuilder values = new StringBuilder();

        // Loop through each result and build the SQL statement dynamically
        for (String result : resultsData) {
            try {
                // Print the result for debugging
                System.out.println("Processing: " + result);

                // Clean up the data by manually extracting and parsing each field
                // Extract subjectId - Assuming it is the first key-value pair in the object
                int subjectId = Integer.parseInt(result.split(",")[0].split(":")[1].replaceAll("[^0-9]", ""));

                // Extract semester
                String semester = result.split(",")[2].split(":")[1].replaceAll("[^a-zA-Z]", "");

                // Extract marks
                String marks = result.split(",")[3].split(":")[1].replaceAll("[^a-zA-Z]", "");

                // Extract userId
                int userId = Integer.parseInt(result.split(",")[4].split(":")[1].replaceAll("[^0-9]", ""));

                // Extract year
                String year = result.split(",")[5].split(":")[1].replaceAll("[^0-9]", "");

                // Print the cleaned values for debugging
                System.out.println("Parsed values - SubjectId: " + subjectId + ", Semester: " + semester + ", Marks: " + marks + ", UserId: " + userId + ", Year: " + year);

                // Prepare the value string for the insert query
                if (values.length() > 0) {
                    values.append(", ");
                }
                values.append("(")
                      .append(userId).append(", ")  // user_id
                      .append(subjectId).append(", ") // subject_id
                      .append(year).append(", ")      // year
                      .append("'").append(semester).append("', ") // semester
                      .append("'").append(marks).append("'") // marks
                      .append(")");

            } catch (Exception e) {
                // Print the error and the result causing the issue
                System.out.println("Error processing result: " + result);
                System.out.println("Exception: " + e.getMessage());

                // Send the error response
                out.print("{\"status\": \"error\", \"message\": \"Invalid data format in JSON: " + e.getMessage() + "\"}");
                return;
            }
        }

        // Complete the query by appending the values
        query += values.toString();

        // Execute the insert query
        System.out.println("Query: " + query);
        stmt = conn.prepareStatement(query);
        int rowsInserted = stmt.executeUpdate();

        // Respond with success message
        if (rowsInserted > 0) {
            out.print("{\"status\": \"success\"}");
        } else {
            out.print("{\"status\": \"failure\", \"message\": \"No records inserted.\"}");
        }

    } catch (SQLException e) {
        e.printStackTrace();  // Handle the error appropriately
        out.print("{\"status\": \"error\", \"message\": \"" + e.getMessage() + "\"}");
    } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
