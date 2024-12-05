<%-- 
    Document   : admin-home
    Created on : Dec 5, 2024, 11:02:12 AM
    Author     : Chamika Niroshan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="studex.classes.SessionValidator" %>
<%
    // Perform session validation
    boolean isValidSession = SessionValidator.isSessionValid(request);

    if (!isValidSession) {
        // If session is not valid, redirect to the login page
        response.sendRedirect("login.jsp");
        return; // Stop further processing of the page
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Home</title>
    </head>
    <body>
        <h1>Welcome to Admin Home Page!</h1>
        <p>Only authorized users can see this page.</p>
    </body>
</html>
