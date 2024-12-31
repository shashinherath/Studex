<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="studex.classes.AttendanceHandler" %>

<%
    String classId = request.getParameter("classId");
    String date = request.getParameter("date");
    Map<String, String> attendanceData = new HashMap(); // Avoiding diamond operator

    // Retrieve attendance data from the request
    Map<String, String[]> parameterMap = request.getParameterMap();
    Set<String> keys = parameterMap.keySet();
    for (String key : keys) {
        if (key.startsWith("attendance[")) {
            String userId = key.substring(key.indexOf("[") + 1, key.indexOf("]"));
            String[] values = parameterMap.get(key);
            if (values != null && values.length > 0) {
                attendanceData.put(userId, values[0]);
            }
        }
    }

    // Debugging output for confirmation
    out.println("<h2>Received Parameters:</h2>");
    out.println("<p>classId : " + classId + "</p>");
    out.println("<p>date : " + date + "</p>");
    for (Map.Entry<String, String> entry : attendanceData.entrySet()) {
        out.println("<p>attendance[" + entry.getKey() + "] : " + entry.getValue() + "</p>");
    }

    // Updating database using AttendanceHandler
    AttendanceHandler handler = new AttendanceHandler();
    boolean isUpdated = handler.updateAttendance(classId, attendanceData);

    // Display the result
    out.println("<h3>Database Update:</h3>");
    if (isUpdated) {
        out.println("<p>Attendance records have been successfully updated!</p>");
    } else {
        out.println("<p>Failed to update attendance records.</p>");
    }
%>
