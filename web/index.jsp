<%-- 
    Document   : index
    Created on : Dec 3, 2024, 9:14:46 PM
    Author     : Shashin Malinda
--%>

<%@page import="studex.classes.DBHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String errorMessage = null;
    String connectionStatus = DBHelper.checkConnection();

    if (username != null && password != null) {
        // Validate user credentials only if both fields are filled
        errorMessage = DBHelper.validateUser(username, password);
        if (errorMessage == null) {
            // Redirect to the home page if login is successful
            response.sendRedirect("admin-home.jsp");
            return;
        }
    }
%>

<!DOCTYPE html>
<html class="h-full bg-gray-50">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
            .overlay {
                background: rgba(4, 4, 4, 0.237);
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                z-index: 1;
            }
        </style>
    </head>

    <body class="h-full w-full relative">
        <!-- Background Image with Gradient Overlay -->
        <div class="absolute inset-0 bg-cover bg-center" style="background-image: url('resources/images/wallpapers/login_background.jpg');">
            <div class="overlay"></div>
        </div>

        <!-- Centered Sign-In Container -->
        <div class="flex min-h-full flex-col justify-center items-center z-10 relative">
            <div class="sm:mx-auto sm:w-full sm:max-w-md text-center mb-4">
                <img src="resources/images/logo/logoStudex.png" alt="Logo" class="mx-auto h-28  mb-4">
              
            </div>

            <!-- Sign-In Form Card -->
            <div class="mt-6 sm:mx-auto sm:w-full sm:max-w-[400px]">
                <div class="bg-white/80 px-8 py-10 shadow-xl rounded-lg sm:px-10">
                    <% if (errorMessage != null) { %>
                        <!-- Display Error Message -->
                        <div class="text-red-600 text-sm font-semibold mb-4">
                            <%= errorMessage %>
                        </div>
                    <% } %>
                    <form class="space-y-6" action="index.jsp" method="POST">
                        <!-- Username Field -->
                        <div>
                            <label for="username" class="block text-sm font-medium text-gray-900">User Name</label>
                            <input id="username" name="username" type="text" required
                                   class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm px-3 py-2">
                        </div>

                        <!-- Password Field -->
                        <div>
                            <label for="password" class="block text-sm font-medium text-gray-900">Password</label>
                            <input id="password" name="password" type="password" required
                                   class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm px-3 py-2">
                        </div>

                        <!-- Sign In Button -->
                        <div>
                            <button type="submit"
                                    class="flex w-full justify-center rounded-lg bg-indigo-600 py-2 px-4 text-white font-semibold hover:bg-indigo-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                                Sign in
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>