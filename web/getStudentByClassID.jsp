<%-- 
    Document   : getStudentByClassID
    Created on : Dec 16, 2024, 10:45:16?AM
    Author     : Chamika Niroshan
--%>
<%@ page import="studex.classes.StudentDAO" %>
<%@ page import="studex.classes.Student" %>
<%@ page contentType="application/json" %>
<%@ page import="java.util.List" %>
<%
    String classId = request.getParameter("classId");
    System.out.println("Received class ID: " + classId);  // Debugging line
    if (classId != null) {
        StudentDAO studentDAO = new StudentDAO();
        List<Student> students = studentDAO.getStudentsByClassId(Integer.parseInt(classId));
        System.out.println("Number of students retrieved: " + (students != null ? students.size() : "null"));

        if (students != null && !students.isEmpty()) {
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < students.size(); i++) {
                Student student = students.get(i);
                json.append("{")
                        .append("\"userId\":").append(student.getUserId()).append(",")
                        .append("\"name\":\"").append(student.getName()).append("\",")
                        .append("\"email\":\"").append(student.getEmail()).append("\",")
                        .append("\"phoneNo\":\"").append(student.getPhoneNo()).append("\",")
                        .append("\"enrollmentDate\":\"").append(student.getEnrollDate()).append("\",")
                        .append("\"guardianName\":\"").append(student.getGuardianName()).append("\"")
                        .append("}");
                if (i < students.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            out.print(json.toString());
        } else {
            out.print("[]"); // Return an empty array if no students found
        }
    } else {
        out.print("[]"); // Return an empty array if classId is null
    }
%>

