<%-- 
    Document   : teacher-home
    Created on : Dec 6, 2024, 7:12:45 PM
    Author     : Chamika Niroshan
--%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
%>
<%
    // Check if the logout action is triggered
    String action = request.getParameter("action");
    if ("logout".equals(action)) {
        // Invoke the LogoutHandler to clear session data
        LogoutHandler.logout(session);

        // Redirect to the login page after logout
        response.sendRedirect("index.jsp");
    }
%>
<%
    ClassDAO classDAO = new ClassDAO();
    List<ClassModel> classes = classDAO.getAvailableClasses();
%>
<%
    String classId = request.getParameter("classId");
    if (classId != null) {
        // Create a StudentDAO object to get students for the class
        StudentDAO studentDAO = new StudentDAO();
        List<Student> students = studentDAO.getStudentsByClassId(Integer.parseInt(classId));

        // Log the retrieved students (Server log)
        System.out.println("Class ID: " + classId);
        System.out.println("Number of students retrieved: " + (students != null ? students.size() : "null"));

        if (students != null) {
            for (Student student : students) {
                System.out.println("Student ID: " + student.getUserId()
                        + ", Name: " + student.getName()
                        + ", Email: " + student.getEmail()
                        + ", Phone: " + student.getPhoneNo()
                        + ", Enrollment Date: " + student.getEnrollDate());
            }
        } else {
            System.out.println("No students found or error in retrieving students.");
        }

        // Set the students as an attribute to be used in the JSP
        request.setAttribute("students", students);
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

            // Initialize by displaying the Dashboard content by default
            window.onload = function () {
                displayContent('dashboard', 'dashboard-tab');
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

        </script>

        <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet" />
    </head>
    <body class="font-sans bg-gray-100">

        <!-- Main Container -->
        <div class="flex h-screen">

            <!-- Sidebar -->
            <div class="w-64 bg-white shadow-md h-full">
                <div class="p-6">
                    <a href="teacher-home.jsp" class="flex items-center pb-4 border-b border-b-gray-800">
                        <img src="./resources/images/logo/logoStudex.png" class="h-18 w-auto" />
                    </a>
                    <h2 class="mt-4 text-lg font-bold text-gray-400">Teacher PANEL</h2>
                </div>
                <nav class="mt-6">
                    <button id="dashboard-tab" class="tab-button block w-full text-left px-6 py-3 hover:bg-purple-100 text-gray-800 text-xs" onclick="displayContent('dashboard', 'dashboard-tab')">
                        <i class="ri-home-2-line mr-3 text-lg"></i>View Student Information
                    </button>
                    <button id="students-tab" class="tab-button block w-full text-left px-6 py-3 hover:bg-purple-100 text-gray-800 text-xs" onclick="displayContent('students', 'students-tab')">
                        <i class="ri-user-line mr-3 text-lg"></i>Manage Class Attendance
                    </button>
                    <button id="teachers-tab" class="tab-button block w-full text-left px-6 py-3 hover:bg-purple-100 text-gray-800 text-xs" onclick="displayContent('teachers', 'teachers-tab')">
                        <i class="ri-user-2-line mr-3 text-lg"></i>View and Enter Grades
                    </button>
                    <button id="subjects-tab" class="tab-button block w-full text-left px-6 py-3 hover:bg-purple-100 text-gray-800 text-xs" onclick="displayContent('subjects', 'subjects-tab')">
                        <i class="ri-book-line mr-3 text-lg"></i>Review Student Performance
                    </button>
                    <button id="classes-tab" class="tab-button block w-full text-left px-6 py-3 hover:bg-purple-100 text-gray-800 text-xs" onclick="displayContent('classes', 'classes-tab')">
                        <i class="ri-graduation-cap-line mr-3 text-lg"></i>Classes
                    </button>
                </nav>
            </div>

            <!-- Main Content Area -->
            <div class="flex-1 flex flex-col">

                <!-- Navbar -->
                <div class="flex items-center justify-between px-6 py-4">
                    <div>
                        <h1 class="text-gray-700 font-semibold"><%= user_name != null && !user_name.isEmpty() ? user_name : "User"%></h1>
                        <p class="text-sm text-gray-500">Teacher</p>
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
                    <div id="dashboard" class="dynamic-content">
                        <h2 class="text-2xl font-bold text-gray-800">Student Info</h2>
                        <div class="p-8">
                            <h1 class="text-3xl font-semibold mb-6">Registered Classes</h1>

                            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                                <% for (ClassModel classModel : classes) {%>
                                <div class="bg-white shadow-lg rounded-lg overflow-hidden">
                                    <div class="p-6">
                                        <h2 class="text-xl font-semibold mb-2"><%= classModel.getClassName()%></h2>
                                        <p class="text-gray-600">Year: <%= classModel.getYear()%></p>
                                    </div>
                                    <div class="px-6 py-4 bg-gray-50 text-center">
                                        <!-- Button to fetch student data -->
                                        <button 
                                            id="viewStudentsBtn" 
                                            data-class-id="<%= classModel.getClassId()%>" 
                                            class="bg-blue-500 text-white py-2 px-4 rounded hover:bg-blue-600"
                                            onclick="fetchStudentInfo(<%= classModel.getClassId()%>)">
                                            View Students
                                        </button>
                                    </div>
                                    <div id="students-container-<%= classModel.getClassId()%>"></div>
                                </div>
                                <% }%>
                            </div>
                        </div>
                        <div class="p-4">
                            <!-- Input for filtering students by name -->
                            <div class="mb-4">
                                <label for="filter-input" class="block text-sm font-medium text-gray-700 mb-2">
                                    Filter Student by Name:
                                </label>
                                <div class="flex space-x-2">
                                    <input
                                        type="text"
                                        id="filter-input"
                                        placeholder="Enter student's name"
                                        class="border border-gray-300 rounded-lg px-4 py-2 w-full focus:ring-cyan-500 focus:border-cyan-500"
                                        />
                                    <button
                                        onclick="filterStudentsByName()"
                                        class="bg-cyan-600 text-white px-4 py-2 rounded-lg hover:bg-cyan-700 focus:ring-2 focus:ring-cyan-500 focus:outline-none"
                                        >
                                        Filter
                                    </button>
                                </div>
                            </div>

                            <!-- Container for displaying student records -->
                            <div id="Student-Records"></div>
                        </div>
                        <script>
                            let allStudents = []; // To store all students fetched from the server

                            function fetchStudentInfo(classId) {
                                console.log("Fetching students for class ID:", classId);

                                const studentsContainer = document.getElementById('Student-Records');
                                studentsContainer.innerHTML = ''; // Clear previous content

                                // Fetch student data
                                fetch('getStudentByClassID.jsp?classId=' + classId)
                                        .then(response => response.json()) // Parse JSON response
                                        .then(students => {
                                            console.log("Data received:", students); // Debug log for the received data
                                            allStudents = students; // Store fetched students globally
                                            displayStudents(students); // Display all students
                                        })
                                        .catch(error => {
                                            console.error("Error fetching student data:", error);
                                            studentsContainer.innerHTML = '<p>Error loading students. Please try again later.</p>';
                                        });
                            }

                            function displayStudents(students) {
                                const studentsContainer = document.getElementById('Student-Records');
                                studentsContainer.innerHTML = ''; // Clear previous content

                                if (students.length > 0) {
                                    // Create a table to display student data
                                    const table = document.createElement('table');
                                    table.classList.add('min-w-full', 'table-auto', 'border-collapse', 'shadow-md', 'border', 'border-gray-200');

                                    // Create the table header
                                    const thead = document.createElement('thead');
                                    thead.classList.add('bg-gray-100');
                                    thead.innerHTML = `
                <tr>
                    <th class="px-4 py-2 border-b text-left">Name</th>
                    <th class="px-4 py-2 border-b text-left">Email</th>
                    <th class="px-4 py-2 border-b text-left">Phone</th>
                    <th class="px-4 py-2 border-b text-left">Enrollment Date</th>
                    <th class="px-4 py-2 border-b text-left">Guardian Name</th>
                </tr>
            `;
                                    table.appendChild(thead);

                                    // Create the table body
                                    const tbody = document.createElement('tbody');

                                    // Loop through students and add each to the table
                                    students.forEach(student => {
                                        const tr = document.createElement('tr');
                                        tr.classList.add('hover:bg-gray-50');

                                        tr.innerHTML = `
                    <td class="px-4 py-2 border-b text-cyan-600">\${student.name}</td>
                    <td class="px-4 py-2 border-b">\${student.email}</td>
                    <td class="px-4 py-2 border-b">\${student.phoneNo}</td>
                    <td class="px-4 py-2 border-b">\${student.enrollmentDate}</td>
                    <td class="px-4 py-2 border-b">\${student.guardianName}</td>
                `;
                                        tbody.appendChild(tr);
                                    });

                                    table.appendChild(tbody);
                                    studentsContainer.appendChild(table);
                                } else {
                                    studentsContainer.innerHTML = '<p class="text-gray-500">No students found for this class.</p>';
                                }
                            }

                            function filterStudentsByName() {
                                const filterValue = document.getElementById('filter-input').value.trim().toLowerCase();

                                if (!filterValue) {
                                    alert('Please enter a name to filter!');
                                    return;
                                }

                                // Filter students by matching the name
                                const filteredStudents = allStudents.filter(student =>
                                    student.name.toLowerCase() === filterValue
                                );

                                if (filteredStudents.length > 0) {
                                    displayStudents(filteredStudents);
                                } else {
                                    document.getElementById('Student-Records').innerHTML = '<p class="text-gray-500">No student found with the given name.</p>';
                                }
                            }
                        </script>
                    </div>

                    <!-- Students Content -->
                    <div id="students" class="dynamic-content" style="display: none;">
                        <h2 class="text-2xl font-bold text-gray-800">Students</h2>
                        <p class="mt-4 text-gray-600">Here is the list of students.</p>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
