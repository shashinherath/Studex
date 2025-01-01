<%-- 
    Document   : student-home
    Created on : Dec 6, 2024, 7:13:28 PM
    Author     : Chamika Niroshan
--%>
<%@page import="studex.classes.AuthHandler"%>
<%@page import="studex.classes.AttendanceHandler"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="studex.classes.SessionValidator" %>
<%@page import="studex.classes.MyProfile"%>
<%@ page import="studex.classes.LogoutHandler" %>
<%@ page import="java.util.List" %>
<%@ page import="studex.classes.ClassDAO" %>
<%@ page import="studex.classes.ClassModel" %>
<%@ page import="studex.classes.StudentDAO" %>
<%@ page import="studex.classes.Student" %>

<%
    // Perform session validation
    boolean isValidSession = SessionValidator.isSessionValid(request);

    if (!isValidSession) {
        // If session is not valid, redirect to the login page
        response.sendRedirect("index.jsp");
        return; // Stop further processing of the page
    }

    // Get username from session
    String user_email = (String) session.getAttribute("email");
    MyProfile profile = new MyProfile();
    String user_name = profile.getMyUserName(user_email);
    String userID = profile.getMyUserId(user_email);

%>
<%    // Check if the logout action is triggered
    String action = request.getParameter("action");
    if ("logout".equals(action)) {
        // Invoke the LogoutHandler to clear session data
        LogoutHandler.logout(session);
        String logoutStatus = AuthHandler.removeTokenFromDatabase(user_email);
        System.out.println(logoutStatus);
        // Redirect to the login page after logout
        response.sendRedirect("index.jsp");
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Teacher Panel - STUDEX</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            function displayContent(contentId, tabId) {
                // Hide all content divs
                document.querySelectorAll(".dynamic-content").forEach(div => {
                    div.style.display = "none";
                });
                // Show the selected content div
                document.getElementById(contentId).style.display = "block";
                // Reset all tab buttons to default style
                document.querySelectorAll(".tab-button").forEach(button => {
                    button.style.backgroundColor = ""; // Remove background color
                    button.style.color = ""; // Reset text color
                    button.style.fontWeight = ""; // Reset font weight
                });
                // Style the selected tab
                const selectedTab = document.getElementById(tabId);
                selectedTab.style.backgroundColor = "#ddd"; // Active background color
                selectedTab.style.color = "#4b0082"; // Active text color
                selectedTab.style.fontWeight = "bold"; // Make text bold for active tab
            }

            // Initialize by displaying the Profile content by default
            window.onload = function () {
                displayContent('profile', 'profile-tab');
            }

            function toggleFullScreen() {
                if (!document.fullscreenElement) {
                    document.documentElement.requestFullscreen();
                } else {
                    if (document.exitFullscreen) {
                        document.exitFullscreen();
                    }
                }
            }

            function logout() {
                window.location.href = 'teacher-home.jsp?action=logout';
            }

            function loadProfileInfo(userId) {
                console.log("Fetching profile data for User ID:", userId);
                const profileContainer = document.getElementById('students-profile-info');
                // Fetch profile data
                fetch('fetchStudentProfileInfo.jsp?userId=' + userId)
                        .then(response => response.json()) // Parse JSON response
                        .then(profile => {
                            console.log("Profile data received:", profile); // Debug log
                            displayProfileInfo(profile); // Display profile data
                        })
                        .catch(error => {
                            console.error("Error fetching profile data:", error);
                            profileContainer.innerHTML = '<p>Error loading profile. Please try again later.</p>';
                        });
            }

            // Function to display profile info
            function displayProfileInfo(profile) {
                const profileContainer = document.getElementById('students-profile-info');
                profileContainer.innerHTML = `
            <div class="bg-white p-6 rounded-lg shadow-lg max-w-md mx-auto">
                <h2 class="text-2xl font-semibold text-gray-800 mb-4">Profile Information</h2>
                <div class="space-y-4">
                    <p class="text-gray-700"><strong class="font-medium">Name:</strong> \${profile.name}</p>
                    <p class="text-gray-700"><strong class="font-medium">Email:</strong> \${profile.email}</p>
                    <p class="text-gray-700"><strong class="font-medium">Enrollment Date:</strong> \${profile.enrollment_date}</p>
                    <p class="text-gray-700"><strong class="font-medium">Phone Number:</strong> \${profile.phone_no}</p>
                    <p class="text-gray-700"><strong class="font-medium">User Type:</strong> \${profile.user_type}</p>
                    <p class="text-gray-700"><strong class="font-medium">Guardian Name:</strong> \${profile.guardian_name}</p>
                </div>
            </div>
        `;
            }
            function loadGrades(userId) {
                console.log("Fetching Grades for User ID:", userId);
                const gradesContainer = document.getElementById('student-grades');
                // Fetch grades data from the server
                fetch('fetchGrades.jsp?userId=' + userId)
                        .then(response => response.json()) // Parse the JSON response
                        .then(grades => {
                            console.log("Grades received:", grades); // Debug log
                            displayGrades(grades); // Display grades in the container
                        })
                        .catch(error => {
                            console.error("Error fetching grades:", error);
                            gradesContainer.innerHTML = '<p>Error loading grades. Please try again later.</p>';
                        });
            }

            function displayGrades(grades) {
                const gradesContainer = document.getElementById('student-grades');
                if (grades.length === 0) {
                    gradesContainer.innerHTML = '<p>No grades found.</p>';
                    return;
                }

                // Group grades by year and semester
                const groupedGrades = grades.reduce((acc, grade) => {
                    const key = `\${grade.year}-\${grade.semester}`;
                    if (!acc[key]) {
                        acc[key] = [];
                    }
                    acc[key].push(grade);
                    return acc;
                }, {});
                // Construct the HTML structure to display grouped grades
                let gradesHtml = `
        <div class="bg-white p-6 rounded-lg shadow-lg max-w-4xl mx-auto">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">Your Academic Grades</h2>
    `;
                // Loop through each year-semester group
                for (const key in groupedGrades) {
                    const [year, semester] = key.split('-');
                    gradesHtml += `
            <div class="mb-8">
                <h3 class="text-xl font-semibold text-gray-700 mb-4">\${year} - \${semester}</h3>
                <table class="w-full table-auto border-collapse">
                    <thead>
                        <tr>
                            <th class="px-6 py-3 text-left border-b font-medium text-gray-600">Subject</th>
                            <th class="px-6 py-3 text-left border-b font-medium text-gray-600">Mark</th>
                        </tr>
                    </thead>
                    <tbody>
        `;
                    // Loop through each grade in this year-semester group
                    groupedGrades[key].forEach(grade => {
                        gradesHtml += `
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 border-b text-gray-700">\${grade.subject_name}</td>
                    <td class="px-6 py-4 border-b text-gray-700">\${grade.mark}</td>
                </tr>
            `;
                    });
                    gradesHtml += `
                    </tbody>
                </table>
            </div>
        `;
                }

                gradesHtml += `
        </div>
    `;
                // Insert the generated HTML into the container
                gradesContainer.innerHTML = gradesHtml;
            }

            function changePassword(userId) {
                // Show the password change form when the user clicks the change password button
                const formContainer = document.getElementById('Change-Password');
                formContainer.style.display = 'block'; // Show the form

                // Create the form structure dynamically with Tailwind styling
                formContainer.innerHTML = `
        <div class="max-w-sm w-full mx-auto bg-white p-6 rounded-lg shadow-lg">
            <h2 class="text-2xl font-semibold text-center mb-4 text-gray-700">Change Password</h2>
            <form id="changePasswordForm">
                <div class="mb-4">
                    <label for="newPassword" class="block text-sm font-medium text-gray-600">New Password:</label>
                    <input type="password" id="newPassword" name="newPassword" required class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                </div>

                <div class="mb-4">
                    <label for="confirmPassword" class="block text-sm font-medium text-gray-600">Confirm Password:</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                </div>

                <button type="button" id="submitPasswordChange" class="w-full bg-blue-500 text-white py-2 rounded-md hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500">Change Password</button>
            </form>

            <div id="statusMessage" class="mt-4 text-center"></div> <!-- Status message container -->
        </div>
    `;

                // Add event listener for the button to handle the password change
                document.getElementById("submitPasswordChange").addEventListener("click", function () {
                    const newPassword = document.getElementById("newPassword").value;
                    const confirmPassword = document.getElementById("confirmPassword").value;

                    // Validate passwords
                    if (newPassword !== confirmPassword) {
                        document.getElementById("statusMessage").innerHTML = "Passwords do not match.";
                        const statusMessageContainer = document.getElementById("statusMessage");
                        statusMessageContainer.classList.add('text-red-600', 'bg-red-100', 'border', 'border-red-500', 'p-2', 'rounded-md');
                        statusMessageContainer.classList.remove('text-green-600', 'bg-green-100', 'border-green-500');
                        return;
                    }

                    // Send the password change request using fetch
                    const url = `changePassword.jsp?userId=\${userId}&newPassword=\${encodeURIComponent(newPassword)}&confirmPassword=\${encodeURIComponent(confirmPassword)}`;

                    fetch(url, {method: 'POST'})
                            .then(response => response.text())
                            .then(responseText => {
                                const statusMessageContainer = document.getElementById('statusMessage');
                                statusMessageContainer.innerHTML = responseText;

                                // Style the status message based on success or failure
                                if (responseText.includes('success')) {
                                    statusMessageContainer.classList.add('text-green-600', 'bg-green-100', 'border', 'border-green-500', 'p-2', 'rounded-md');
                                    statusMessageContainer.classList.remove('text-red-600', 'bg-red-100', 'border-red-500');
                                } else {
                                    statusMessageContainer.classList.add('text-red-600', 'bg-red-100', 'border', 'border-red-500', 'p-2', 'rounded-md');
                                    statusMessageContainer.classList.remove('text-green-600', 'bg-green-100', 'border-green-500');
                                }
                            })
                            .catch(error => {
                                console.error("Error:", error);
                                const statusMessageContainer = document.getElementById('statusMessage');
                                statusMessageContainer.innerHTML = "An error occurred. Please try again.";
                                statusMessageContainer.classList.add('text-red-600', 'bg-red-100', 'border', 'border-red-500', 'p-2', 'rounded-md');
                                statusMessageContainer.classList.remove('text-green-600', 'bg-green-100', 'border-green-500');
                            });
                });
            }






            // Initialize by displaying the Profile content and loading profile info
            window.onload = function () {
                displayContent('profile', 'profile-tab');
                loadProfileInfo(<%= userID%>); // Load profile info when the page loads
            }
        </script>

        <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet" />
    </head>
    <body class="font-sans bg-gray-100" >

        <!-- Main Container -->
        <div class="flex h-screen">

            <!-- Sidebar -->
            <div class="w-64 bg-white shadow-md h-full">
                <div class="p-6">
                    <a href="teacher-home.jsp" class="flex items-center pb-4 border-b border-b-gray-800">
                        <img src="./resources/images/logo/logoStudex.png" class="h-18 w-auto" />
                    </a>
                    <h2 class="mt-4 text-lg font-bold text-gray-400">Student PANEL</h2>
                </div>
                <nav class="mt-6">
                    <button id="profile-tab" class="tab-button block w-full text-left px-6 py-3 hover:bg-purple-100 text-gray-800 text-xs" onclick="displayContent('profile', 'profile-tab');
                            loadProfileInfo(<%= userID%>);">
                        <i class="ri-home-2-line mr-3 text-lg"></i>View My Profile Info
                    </button>
                    <button id="password-tab" class="tab-button block w-full text-left px-6 py-3 hover:bg-purple-100 text-gray-800 text-xs" onclick="displayContent('password', 'password-tab');
                            changePassword(<%= userID%>);">
                        <i class="ri-user-line mr-3 text-lg"></i>Change Password
                    </button>
                    <button id="grade-tab" class="tab-button block w-full text-left px-6 py-3 hover:bg-purple-100 text-gray-800 text-xs" onclick="displayContent('grade', 'grade-tab');
                            loadGrades(<%= userID%>);">
                        <i class="ri-user-2-line mr-3 text-lg"></i>View Grades
                    </button>
                </nav>
            </div>

            <!-- Main Content Area -->
            <div class="flex-1 flex flex-col">

                <!-- Navbar -->
                <div class="flex items-center justify-between px-6 py-4">
                    <div>
                        <h1 class="text-gray-700 font-semibold"><%= user_name != null && !user_name.isEmpty() ? user_name : "User"%></h1>
                        <p class="text-sm text-gray-500">Student</p>
                    </div>
                    <div>
                        <button id="fullscreen-button" onclick="toggleFullScreen()" class="px-4 py-2 bg-gray-100 rounded hover:bg-gray-200">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="hover:bg-gray-100 rounded-full" viewBox="0 0 24 24" style="fill: gray">
                            <path d="M5 5h5V3H3v7h2zm5 14H5v-5H3v7h7zm11-5h-2v5h-5v2h7zm-2-4h2V3h-7v2h5z"></path>
                            </svg>
                        </button>
                        <button class="px-4 py-2 bg-red-100 rounded hover:bg-red-400" onclick="logout()">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="hover:bg-red-400 rounded-full" viewBox="0 0 24 24" style="fill: gray">
                            <path d="M14 7l-1.41 1.41L16.17 12H8v2h8.17l-3.59 3.59L14 17l5-5-5-5zM19 3h-8c-1.1 0-2 .9-2 2v3h2V5h8v14h-8v-3h-2v3c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"></path>
                            </svg>
                        </button>
                    </div>
                </div>

                <!-- Dynamic Content -->
                <div class="flex-1 overflow-y-auto p-6 bg-gray-200">
                    <!-- Dashboard Content -->
                    <div id="profile" class="dynamic-content">
                        <h2 class="text-2xl font-bold text-gray-800">View My Profile Info</h2>
                        <div class="p-8">
                            <div id="students-profile-info"></div>
                        </div>
                    </div>

                    <!-- Students Content -->
                    <div id="password" class="dynamic-content" style="display: none;">
                        <h2 class="text-2xl font-bold text-gray-800">Change Password</h2>
                        <div class="p-8">
                            <div id="Change-Password"></div>
                        </div>
                    </div>

                    <div id="grade" class="dynamic-content" style="display: none;">
                        <h2 class="text-2xl font-bold text-gray-800">View Grades</h2>
                        <div class="p-8">
                            <div id="student-grades"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
