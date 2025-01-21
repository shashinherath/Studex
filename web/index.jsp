
<%-- 
    Document   : login
    Created on : Dec 5, 2024, 7:07:19?AM
    Author     : Chamika Niroshan
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="studex.classes.AuthHandler" %>
<%@ page import="studex.classes.SessionValidator" %>
<%
    // Perform session validation
    boolean isValidSession = SessionValidator.isSessionValid(request);

    if (isValidSession) {
        // Get the user type from the session
        String userType = SessionValidator.getUserType(request);
        // Redirect based on user type
        if ("Admin".equals(userType)) {
            // Admin user, redirect to admin home page
            response.sendRedirect("admin-home.jsp");

        } else if ("Teacher".equals(userType)) {
            // Teacher user, redirect to teacher home page
            response.sendRedirect("teacher-home.jsp");

        } else if ("Student".equals(userType)) {
            // Student user, redirect to student home page
            response.sendRedirect("student-home.jsp");

        }
        return; // Stop further processing of the page
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login - Studex</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <style>
            body {
                background-image: url('./resources/images/wallpapers/back.jpg');
                background-size: cover;
                background-position: center;
                background-repeat: no-repeat;
                background-attachment: fixed;
            }
        </style>
    </head>
    <body class="bg-gray-100">
    <body>
        <div class="flex justify-center items-center h-screen">



            <div style="background-color: rgba(255, 255, 255, 0.8); border-radius: 30px;" class="shadow-md rounded px-8 pt-6 pb-8 mb-4 w-full max-w-md">

                <h2 class="text-4xl font-bold mb-6 text-center" style="color: #a651d3;">STUDEX LOGING</h2>

                <form method="POST" action="index.jsp">
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="email">
                            Email Address
                        </label>
                        <input 
                            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" 
                            id="email" 
                            name="email" 
                            type="text" 
                            placeholder="Enter your Email Address" 
                            required>
                    </div>
                    <div class="mb-6">
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="password">
                            Password
                        </label>
                        <input 
                            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" 
                            id="password" 
                            name="password" 
                            type="password" 
                            placeholder="Enter your password" 
                            required>
                    </div>

                    <div class="flex items-center justify-center">
                        <button 
                            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline " 

                            type="submit">
                            Sign In
                        </button>
                    </div>
                </form>
                <%
                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        String email = request.getParameter("email");
                        String password = request.getParameter("password");

                        // Authenticate user using AuthHandler
                        String errorMessage = AuthHandler.authenticateUser(email, password, session);

                        if (errorMessage == null) {
                            // Get userType from session
                            String userType = (String) session.getAttribute("userType");

                            // Redirect based on userType
                            if ("Admin".equalsIgnoreCase(userType)) {
                                response.sendRedirect("admin-home.jsp");
                            } else if ("Teacher".equalsIgnoreCase(userType)) {
                                response.sendRedirect("teacher-home.jsp");
                            } else if ("Student".equalsIgnoreCase(userType)) {
                                response.sendRedirect("student-home.jsp");
                            } else {
                                // Default redirect if userType is unknown
                                response.sendRedirect("unknown-user.jsp");
                            }
                        } else {
                            // Display error message
                %>
                <p class="text-red-600 mt-4"><%= errorMessage%></p>
                <%
                        }
                    }
                %>

            </div>
        </div>
    </body>
</html>
