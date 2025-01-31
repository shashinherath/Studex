<%-- 
    Document   : teacher-home
    Created on : Dec 6, 2024, 7:12:45 PM
    Author     : Chamika Niroshan
--%><%@page import="studex.classes.AuthHandler"%>
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
    String teacherID = profile.getTeacherId(userID);
    String classID = profile.getClassId(teacherID);
    String className = profile.getClassName(teacherID);

    AttendanceHandler Attendance = new AttendanceHandler();
    boolean todayAttendance = Attendance.checkAttendanceMarkStatus(classID);
%>
<%
    // Check if the logout action is triggered
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
                    <a href="teacher-home.jsp" class="flex items-center pb-2">
                        <img src="./resources/images/logo/logoStudex.png" class="h-12 w-auto" />
                    </a>
                    <h2 class="mt-4 text-lg text-center font-bold text-gray-400">Teacher PANEL</h2>
                </div>
                <nav class="mt-2">
                    <button id="dashboard-tab" class="tab-button block w-full text-left px-6 py-3 m-2 rounded-l-xl hover:bg-purple-100 text-gray-800 text-sm" onclick="displayContent('dashboard', 'dashboard-tab')">
                        <i class="ri-home-2-line mr-3 text-lg"></i>View Student Information
                    </button>
                    <button id="attendance-tab" class="tab-button block w-full text-left px-6 py-3 m-2 rounded-l-xl hover:bg-purple-100 text-gray-800 text-sm" onclick="displayContent('attendance', 'attendance-tab')">
                        <i class="ri-user-line mr-3 text-lg"></i>Manage Class Attendance
                    </button>
                    <button id="teachers-tab" class="tab-button block w-full text-left px-6 py-3 m-2 rounded-l-xl hover:bg-purple-100 text-gray-800 text-sm" onclick="displayContent('teachers', 'teachers-tab')">
                        <i class="ri-user-2-line mr-3 text-lg"></i>View and Enter Grades
                    </button>
                    <button id="subjects-tab" class="tab-button block w-full text-left px-6 py-3 m-2 rounded-l-xl hover:bg-purple-100 text-gray-800 text-sm" onclick="displayContent('subjects', 'subjects-tab')">
                        <i class="ri-book-line mr-3 text-lg"></i>Review Student Performance
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
                        <button class="px-4 py-2 bg-purple-100 rounded hover:bg-purple-200" onclick="logout()">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" class="hover:bg-purple-200 rounded-full" viewBox="0 0 24 24" style="fill: gray">
                            <path d="M14 7l-1.41 1.41L16.17 12H8v2h8.17l-3.59 3.59L14 17l5-5-5-5zM19 3h-8c-1.1 0-2 .9-2 2v3h2V5h8v14h-8v-3h-2v3c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"></path>
                            </svg>
                        </button>
                    </div>
                </div>

                <!-- Dynamic Content -->
                <div class="flex-1 overflow-y-auto p-6 bg-[url('./resources/images/wallpapers/bg.png')] bg-cover bg-center">
                    <!-- Dashboard Content -->
                    <div id="dashboard" class="dynamic-content">
                        <h2 class="text-4xl text-center font-bold text-gray-800">View Student Information</h2>
                        <div class="p-8">
                            <h1 class="text-3xl font-semibold mb-6">Registered Classes</h1>

                            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                                <% for (ClassModel classModel : classes) {%>
                                <div class="bg-white shadow-xl rounded-lg overflow-hidden">
                                    <div class="p-6">
                                        <h2 class="text-xl font-semibold mb-2"><%= classModel.getClassName()%></h2>
                                        <p class="text-gray-600">Year: <%= classModel.getYear()%></p>
                                    </div>
                                    <div class="px-6 py-4 bg-gray-100  text-center">
                                        <!-- Button to fetch student data -->
                                        <button 
                                            id="viewStudentsBtn" 
                                            data-class-id="<%= classModel.getClassId()%>" 
                                            class="bg-purple-600 text-white py-2 px-4 rounded hover:bg-purple-700"
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
                                        class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 focus:ring-2 focus:ring-cyan-500 focus:outline-none"
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
                                        tr.classList.add(' bg-gray-50 hover:bg-gray-100');

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
                                    studentsContainer.innerHTML = '<p class="text-red-500">No students found for this class.</p>';
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
                                    document.getElementById('Student-Records').innerHTML = '<p class="text-red-500">No student found with the given name.</p>';
                                }
                            }




                            /*-------------------------------------------------------------------------------------------------------*/


                            let attendanceStatus = {}; // Object to store attendance status for each student
                            let classID = "";

                            // Fetch student data by class ID (called when the user clicks on "Mark Attendance")
                            function fetchStudentInfoForAttendance(classId) {
                                console.log("Fetching students for class ID:", classId);

                                const studentsContainer = document.getElementById('attendanceFormContainer');
                                studentsContainer.innerHTML = ''; // Clear previous content

                                // Fetch student data
                                fetch('getStudentByClassID.jsp?classId=' + classId)
                                        .then(response => response.json()) // Parse JSON response
                                        .then(students => {
                                            console.log("Data received:", students); // Debug log for the received data
                                            allStudents = students; // Store fetched students globally
                                            attendanceStatus = {}; // Reset the attendance status object
                                            displayAttendanceForm(students); // Display the form for marking attendance
                                        })
                                        .catch(error => {
                                            console.error("Error fetching student data:", error);
                                            studentsContainer.innerHTML = '<p>Error loading students. Please try again later.</p>';
                                        });
                            }

                            // Display the table for marking attendance
                            function displayAttendanceForm(students) {
                                const studentsContainer = document.getElementById('attendanceFormContainer');
                                studentsContainer.innerHTML = ''; // Clear previous content

                                if (students.length > 0) {
                                    const table = document.createElement('table');
                                    table.classList.add('min-w-full', 'table-auto', 'border-collapse', 'shadow-md', 'border', 'border-gray-200');

                                    const thead = document.createElement('thead');
                                    thead.classList.add('bg-gray-100');
                                    thead.innerHTML = `
                <tr>
                    <th class="px-4 py-2 border-b text-left">Name</th>
                    <th class="px-4 py-2 border-b text-left">Attendance</th>
                </tr>
            `;
                                    table.appendChild(thead);

                                    const tbody = document.createElement('tbody');

                                    // Loop through students and add each to the table with buttons for attendance
                                    students.forEach(student => {
                                        const tr = document.createElement('tr');
                                        tr.id = `student-\${student.userId}`; // Add a unique ID for each row to highlight it
                                        tr.innerHTML = `
                    <td class=" bg-white px-4 py-2 border-b text-cyan-600">\${student.name}</td>
                    <td class="px-4 py-2 border-b">
                        <button id="present-\${student.userId}" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600" onclick="markAttendanceForStudent('\${student.userId}', 'Present')">Present</button>
                        <button id="absent-\${student.userId}" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600" onclick="markAttendanceForStudent('\${student.userId}', 'Absent')">Absent</button>
                    </td>
                `;
                                        tbody.appendChild(tr);
                                    });

                                    table.appendChild(tbody);
                                    studentsContainer.appendChild(table);

                                    // Add the submit button after the table
                                    const submitButton = document.createElement('button');
                                    submitButton.classList.add('mt-4', 'bg-blue-500', 'text-white', 'p-2', 'rounded');
                                    submitButton.innerText = 'Submit Attendance';
                                    submitButton.onclick = submitAttendance;
                                    studentsContainer.appendChild(submitButton);
                                } else {
                                    studentsContainer.innerHTML = '<p class="text-gray-500">No students found for this class.</p>';
                                }
                            }

                            // Mark attendance for a student (Present or Absent)
                            function markAttendanceForStudent(studentId, status) {
                                attendanceStatus[studentId] = status;
                                // Disable the attendance buttons for this student to prevent further changes
                                document.getElementById(`present-\${studentId}`).disabled = true;
                                document.getElementById(`absent-\${studentId}`).disabled = true;

                                // Highlight the student row based on the attendance status
                                const studentRow = document.getElementById(`student-\${studentId}`);
                                if (status === 'Present') {
                                    studentRow.classList.add('bg-green-100'); // Green background for Present
                                } else if (status === 'Absent') {
                                    studentRow.classList.add('bg-red-100'); // Red background for Absent
                                }

                                // Optionally add a checkmark icon or text to show the status
                                const presentButton = document.getElementById(`present-\${studentId}`);
                                const absentButton = document.getElementById(`absent-\${studentId}`);

                                if (status === 'Present') {
                                    presentButton.innerHTML = '✓ Present'; // Add checkmark for Present
                                } else {
                                    absentButton.innerHTML = '✓ Absent'; // Add checkmark for Absent
                                }
                            }

                            // Submit the attendance to the server
                            // Submit the attendance to the server
                            function submitAttendance() {
                                // Check if all students have marked attendance
                                if (Object.keys(attendanceStatus).length === allStudents.length) {
                                    const formData = new FormData();
                                    formData.append('classId', classID); // Add the class ID to the FormData
                                    formData.append('date', new Date().toISOString().split('T')[0]); // Add the date in 'YYYY-MM-DD' format

                                    // Add attendance data for each student to the FormData
                                    for (let studentId in attendanceStatus) {
                                        formData.append(`attendance[\${studentId}]`, attendanceStatus[studentId]);
                                    }
                                    // Log the contents of the FormData
                                    for (let pair of formData.entries()) {
                                        console.log(pair[0] + ': ' + pair[1]);
                                    }
                                    const urlParams = new URLSearchParams(formData); // Convert FormData to URLSearchParams

                                    fetch('submitAttendance.jsp', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/x-www-form-urlencoded',
                                        },
                                        body: urlParams.toString(), // Send as URL-encoded string
                                    })
                                            .then(response => response.text()) // Parse JSON response
                                            .then(data => {
                                                alert('Attendance submitted successfully');
                                                location.reload();

                                                // Optionally, handle success response (e.g., show a success message or redirect)
                                            })

                                            .catch(error => {
                                                console.error("Error fetching student data:", error);
                                            });
                                } else {
                                    alert('Please mark attendance for all students before submitting.');
                                }
                            }


                            // This function gets called when the user clicks the "Mark Attendance" button
                            function markAttendance(classId) {
                                classID = classId;
                                fetchStudentInfoForAttendance(classId);
                                document.getElementById('attendanceFormContainer').classList.remove('hidden');
                            }
                            function fetchStudentInfo_2(classId, year, className) {
                                const studentsContainer = document.getElementById('students-container-for-results');
                                studentsContainer.innerHTML = ''; // Clear previous content

                                // Fetch student data
                                fetch(`getStudentByClassID.jsp?classId=\${classId}`)
                                        .then(response => response.json()) // Parse JSON response
                                        .then(students => {
                                            console.log("Data received:", students); // Debug log for the received data
                                            allStudents = students; // Store fetched students globally
                                            displayStudents_2(students, classId, year, className); // Pass classId and year to the function
                                        })
                                        .catch(error => {
                                            console.error("Error fetching student data:", error);
                                            studentsContainer.innerHTML = '<p>Error loading students. Please try again later.</p>';
                                        });
                            }

                            function displayStudents_2(students, classId, year, className) {
                                const studentsContainer = document.getElementById('students-container-for-results');
                                studentsContainer.innerHTML = ''; // Clear previous content

                                // Add class name at the top
                                const classNameHeading = document.createElement('h3');
                                classNameHeading.classList.add('text-2xl', 'font-bold', 'mb-4', 'text-gray-800');
                                classNameHeading.textContent = `Class: \${className}`;
                                studentsContainer.appendChild(classNameHeading);

                                if (students.length > 0) {
                                    // Create a table element
                                    const table = document.createElement('table');
                                    table.classList.add('min-w-full', 'table-auto', 'border-collapse', 'shadow-md', 'border','bg-white','bg-opacity-80', 'border-gray-200');

                                    // Create the table header
                                    const thead = document.createElement('thead');
                                    thead.classList.add('bg-gray-100');
                                    thead.innerHTML = `
            <tr>
                <th class="px-4 py-2 border-b text-left">Name</th>
                <th class="px-4 py-2 border-b text-left">Actions</th>
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
                <td class="px-4 py-2 border-b">
                    <div class="flex space-x-4">
                        <button 
                            class="bg-green-500 text-white py-2 px-4 rounded hover:bg-green-600"
                            onclick="viewStudentResults('\${student.name}', '\${classId}', '\${year}', '\${student.userId}')">
                            View Results
                        </button>
                        <button 
                            class="bg-blue-500 text-white py-2 px-4 rounded hover:bg-blue-600"
                            onclick="enterNewResult('\${student.name}', '\${classId}', '\${year}', '\${student.userId}')">
                            Enter New Result
                        </button>
                    </div>
                </td>
            `;
                                        tbody.appendChild(tr);
                                    });

                                    table.appendChild(tbody);
                                    studentsContainer.appendChild(table);
                                } else {
                                    studentsContainer.innerHTML = '<p class="text-gray-500">No students found for this class.</p>';
                                }
                            }



                            function viewStudentResults(studentName, classId, year, userId) {
                                // Fetch results from the JSP page
                                fetch(`fetchStudentResults.jsp?userId=\${userId}&year=\${year}`)
                                        .then(response => response.json())
                                        .then(results => {
                                            // Call a function to display the results
                                            displayStudentResults(results, studentName);
                                        })
                                        .catch(error => {
                                            console.error('Error fetching student results:', error);
                                        });
                            }
                            function displayStudentResults(results, studentName) {
                                const resultsContainer = document.getElementById('students-container-for-results-2');
                                resultsContainer.innerHTML = ''; // Clear previous content

                                // Add a heading
                                const heading = document.createElement('h3');
                                heading.classList.add('text-2xl', 'font-bold', 'mb-4', 'text-gray-800');
                                heading.textContent = `Results for: \${studentName}`;
                                resultsContainer.appendChild(heading);

                                if (results.length > 0) {
                                    // Create a table
                                    const table = document.createElement('table');
                                    table.classList.add('min-w-full', 'table-auto', 'border-collapse', 'shadow-md', 'border', 'bg-white','bg-opacity-80', 'border-gray-200');

                                    // Table header
                                    table.innerHTML = `
            <thead class="bg-gray-100">
                <tr>
                    <th class="px-4 py-2 border-b">Subject</th>
                    <th class="px-4 py-2 border-b">Year</th>
                    <th class="px-4 py-2 border-b">Semester</th>
                    <th class="px-4 py-2 border-b">Grade</th>
                </tr>
            </thead>
        `;

                                    // Table body
                                    const tbody = document.createElement('tbody');
                                    results.forEach(result => {
                                        const row = document.createElement('tr');
                                        row.classList.add('hover:bg-gray-50');

                                        row.innerHTML = `
                <td class="px-4 py-2 border-b">\${result.subjectName}</td>
                <td class="px-4 py-2 border-b">\${result.year}</td>
                <td class="px-4 py-2 border-b">\${result.semester}</td>
                <td class="px-4 py-2 border-b">\${result.grade}</td>
            `;
                                        tbody.appendChild(row);
                                    });

                                    table.appendChild(tbody);
                                    resultsContainer.appendChild(table);
                                } else {
                                    resultsContainer.innerHTML = '<p class="text-gray-500">No results found for this student.</p>';
                                }
                            }



                            // Function to display the form for entering new results
                            function enterNewResult(studentName, classId, year, userId) {

                                // Create the form and table for subject selection and input
                                let container = document.getElementById("students-container-for-results-2");
                                container.innerHTML = ""; // Clear the container before adding new rows

                                // Add a heading
                                const heading = document.createElement('h3');
                                heading.classList.add('text-2xl', 'font-bold', 'mb-4', 'text-gray-800');
                                heading.textContent = `Add Results for: \${studentName}`;
                                container.appendChild(heading);

                                // Create the semester dropdown
                                let semesterLabel = document.createElement('label');
                                semesterLabel.textContent = "Select Semester: ";
                                semesterLabel.classList.add('block', 'text-lg', 'font-semibold', 'mb-2');
                                let semesterSelect = document.createElement('select');
                                semesterSelect.id = "semester-select";
                                semesterSelect.required = true;
                                semesterSelect.classList.add('block', 'w-full', 'p-2', 'mb-4', 'border', 'border-gray-300', 'rounded-md', 'focus:outline-none', 'focus:ring-2', 'focus:ring-blue-500');

                                // Populate the semester dropdown
                                let semesters = ["First-Semester", "Mid-Semester", "End-Semester"];
                                semesters.forEach((semester, index) => {
                                    let option = document.createElement('option');
                                    option.value = semester;
                                    option.textContent = semester;
                                    semesterSelect.appendChild(option);
                                });

                                // Append the semester label and dropdown to the container
                                container.appendChild(semesterLabel);
                                container.appendChild(semesterSelect);

                                // Create table for subjects and marks
                                let table = document.createElement('table');
                                table.classList.add('min-w-full', 'mt-6', 'border-collapse', 'bg-white', 'bg-opacity-80', 'table-auto');

                                let header = table.createTHead();
                                let headerRow = header.insertRow();
                                headerRow.classList.add('bg-gray-200');
                                headerRow.insertCell().textContent = "Subject Name";
                                headerRow.insertCell().textContent = "Marks (Required)";

                                // List of subjects to pre-fill
                                let subjects = [
                                    {id: 1, name: "Mathematics"},
                                    {id: 2, name: "Physics"},
                                    {id: 3, name: "Chemistry"},
                                    {id: 4, name: "Biology"},
                                    {id: 5, name: "History"},
                                    {id: 6, name: "Geography"}
                                ];

                                let tbody = table.createTBody();

                                // Populate the table with subjects and marks dropdowns
                                subjects.forEach((subject) => {
                                    let row = tbody.insertRow();

                                    // Subject Name (Pre-filled)
                                    let subjectCell = row.insertCell();
                                    subjectCell.textContent = subject.name;
                                    subjectCell.classList.add('px-4', 'py-2', 'border', 'border-gray-300', 'text-left');

                                    // Marks (Required dropdown)
                                    let marksCell = row.insertCell();
                                    let marksSelect = document.createElement('select');
                                    marksSelect.id = `marks-\${subject.id}`; // Unique id for each subject
                                    marksSelect.required = true;
                                    marksSelect.classList.add('block', 'w-full', 'p-2', 'mt-2', 'border', 'border-gray-300', 'rounded-md', 'focus:outline-none', 'focus:ring-2', 'focus:ring-blue-500');

                                    // Define marks dropdown options
                                    let marksOptions = ["A", "B", "C", "D", "F"];
                                    marksOptions.forEach((mark) => {
                                        let option = document.createElement('option');
                                        option.value = mark;
                                        option.textContent = mark;
                                        marksSelect.appendChild(option);
                                    });

                                    marksCell.appendChild(marksSelect);
                                });

                                // Append the table to the container
                                container.appendChild(table);

                                // Create the submit button
                                let submitButton = document.createElement('button');
                                submitButton.textContent = "Submit Results";
                                submitButton.classList.add('mt-6', 'px-6', 'py-3', 'bg-blue-500', 'text-white', 'font-semibold', 'rounded-lg', 'hover:bg-blue-600', 'focus:outline-none', 'focus:ring-2', 'focus:ring-blue-500');
                                submitButton.onclick = function () {
                                    submitResults(classId, year, userId);
                                };
                                container.appendChild(submitButton);
                            }

// Submit function remains the same, no changes required here

                            function submitResults(classId, year, userId) {
                                let semester = document.getElementById("semester-select").value;
                                let subjects = [
                                    {id: 1, name: "Mathematics"},
                                    {id: 2, name: "Physics"},
                                    {id: 3, name: "Chemistry"},
                                    {id: 4, name: "Biology"},
                                    {id: 5, name: "History"},
                                    {id: 6, name: "Geography"}
                                ];

                                let results = [];

                                // Loop through each subject and get the selected marks
                                subjects.forEach(subject => {
                                    let marks = document.getElementById(`marks-\${subject.id}`).value;

                                    // If marks are not selected, alert the user and stop further submission
                                    if (!marks) {
                                        alert(`Please select marks for \${subject.name}`);
                                        return;
                                    }

                                    results.push({
                                        subjectId: subject.id,
                                        subjectName: subject.name,
                                        semester: semester,
                                        marks: marks,
                                        userId: userId,
                                        year: year
                                    });
                                });

                                // If results array is empty (due to early return in case of missing marks), do not proceed
                                if (results.length === 0) {
                                    return; // Prevent sending empty results
                                }

                                // Send the results to `updateStudentResults.jsp`
                                fetch('updateStudentResults.jsp', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json'
                                    },
                                    body: JSON.stringify(results)
                                })
                                        .then(response => response.json())
                                        .then(data => {
                                            alert('Results submitted successfully');
                                            location.reload();

                                            // Optionally, handle success response (e.g., show a success message or redirect)
                                        })
                                        .catch(error => {
                                            alert('Error submitting results');
                                            console.error(error);
                                        });
                            }


                            function fetchStudentResultByClass(classId, year, className) {
                                // Fetch results from the JSP page
                                fetch(`fetchStudentResultByClass.jsp?classId=\${classId}&year=\${year}`)
                                        .then(response => response.json())
                                        .then(results => {
                                            // Call a function to display the results
                                            displayClassPerformance(results, classId, year, className);
                                        })
                                        .catch(error => {
                                            console.error('Error fetching student results:', error);
                                        });

                            }

                            function displayClassPerformance(results, classId, year, className) {
                                // Get the container element
                                const container = document.getElementById('students-container-for-performance');

                                // Clear existing content
                                container.innerHTML = '';

                                // Create a header for the class and year
                                const header = document.createElement('h2');
                                header.textContent = `Class \${className} - Academic Performance (\${year})`;
                                header.classList.add('text-2xl', 'font-bold', 'mb-4', 'text-center', 'text-gray-800');
                                container.appendChild(header);

                                // Group results by semester and subject
                                const semesterGroups = results.reduce((groups, result) => {
                                    if (!groups[result.semester]) {
                                        groups[result.semester] = {};
                                    }
                                    if (!groups[result.semester][result.subjectName]) {
                                        groups[result.semester][result.subjectName] = [];
                                    }
                                    groups[result.semester][result.subjectName].push(result.mark);
                                    return groups;
                                }, {});

                                // Display results semester by semester
                                for (const [semester, subjects] of Object.entries(semesterGroups)) {
                                    // Create a section for the semester
                                    const semesterSection = document.createElement('div');
                                    semesterSection.classList.add('semester-section', 'mb-6', 'bg-white', 'bg-opacity-80', 'shadow', 'rounded', 'p-4');

                                    // Add a title for the semester
                                    const semesterTitle = document.createElement('h3');
                                    semesterTitle.textContent = `\${semester}`;
                                    semesterTitle.classList.add('text-xl', 'font-semibold', 'mb-3', 'text-gray-700');
                                    semesterSection.appendChild(semesterTitle);

                                    // Create a table to display results
                                    const table = document.createElement('table');
                                    table.classList.add('performance-table', 'w-full', 'border-collapse', 'table-auto', 'text-gray-800');

                                    // Add table headers
                                    const tableHeader = document.createElement('thead');
                                    tableHeader.innerHTML = `
            <tr class="bg-gray-100 text-left">
                <th class="border px-4 py-2">Subject</th>
                <th class="border px-4 py-2">Average Mark</th>
            </tr>
        `;
                                    table.appendChild(tableHeader);

                                    // Add table body
                                    const tableBody = document.createElement('tbody');
                                    for (const [subjectName, marks] of Object.entries(subjects)) {
                                        const averageMark = (marks.reduce((sum, mark) => sum + parseMark(mark), 0) / marks.length).toFixed(2);
                                        const row = document.createElement('tr');
                                        row.innerHTML = `
                <td class="border px-4 py-2">\${subjectName}</td>
                <td class="border px-4 py-2">\${averageMark}</td>
            `;
                                        tableBody.appendChild(row);
                                    }
                                    table.appendChild(tableBody);

                                    // Append the table to the semester section
                                    semesterSection.appendChild(table);

                                    // Add a description below the table
                                    const description = document.createElement('p');
                                    description.textContent = `Note: The average marks are calculated by converting grades into numeric values (A=4, B=3, C=2, D=1, F=0) and averaging them for each subject.`;
                                    description.classList.add('text-sm', 'text-gray-600', 'mt-2');
                                    semesterSection.appendChild(description);

                                    // Append the semester section to the container
                                    container.appendChild(semesterSection);
                                }
                            }

// Helper function to parse marks (convert grades to numeric values)
                            function parseMark(grade) {
                                const gradeMapping = {
                                    'A': 4.0,
                                    'B': 3.0,
                                    'C': 2.0,
                                    'D': 1.0,
                                    'F': 0.0
                                };
                                return gradeMapping[grade] || 0.0;
                            }






                        </script>
                    </div>

                    <!-- Students Content -->
                    <div id="attendance" class="dynamic-content" style="display: none;">
                        <h2 class="text-4xl text-center font-bold text-gray-800">Manage Class Attendance</h2>
                        <p class="mt-4 text-center text-gray-600">Attendance of students</p>
                        <div class="mt-6 max-w-sm bg-white p-6 rounded-xl shadow-lg">
                            <h3 class="text-xl text-center font-semibold text-gray-800">User Details</h3>

                            <!-- User details inside card -->
                            <div class="mt-4">
                                <p class="text-gray-600"><strong>User Name:</strong> <%= user_name%></p>
                                <p class="text-gray-600"><strong>Teacher ID:</strong> <%= teacherID%></p>
                                <p class="text-gray-600"><strong>Assigned Class:</strong> <%= className%></p>
                            </div>
                        </div>
                        <!-- Attendance Status Message -->
                        <div class="mt-6 justify-center flex">
                            <div class="">
                                <%
                                    if (todayAttendance) {
                                %>
                                <p class="text-green-600 font-semibold ">Attendance has already been marked for today.</p>
                                <%
                                } else {
                                %>
                                <p class="text-red-600 font-semibold">Attendance has not been marked for today.</p>
                                <!-- Optional: Call another function or display a message -->
                                <button class="mt-4 bg-blue-500 text-white p-2 rounded" onclick="markAttendance(<%= classID%>)">Mark Attendance</button>
                                <%
                                    }
                                %>
                            </div>

                        </div>
                        <div id="attendanceFormContainer" class="hidden mt-6"></div>
                    </div>

                    <div id="teachers" class="dynamic-content" style="display: none;">
                        <h2 class="text-4xl text-center font-bold text-gray-800">View and Enter Grades</h2>
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
                                        <button 
                                            data-class-id="<%= classModel.getClassId()%>" 
                                            data-class-year="<%= classModel.getYear()%>"
                                            class="bg-purple-600 text-white py-2 px-4 rounded hover:bg-purple-700"
                                            onclick="fetchStudentInfo_2('<%= classModel.getClassId()%>', '<%= classModel.getYear()%>', '<%= classModel.getClassName()%>')">
                                            View Students
                                        </button>
                                    </div>
                                </div>
                                <% }%>
                            </div>
                        </div>
                        <div id="students-container-for-results"></div>
                        <div id="students-container-for-results-2"class="mt-5"></div>
                    </div>

                    <div id="subjects" class="dynamic-content" style="display: none;">
                        <h2 class="text-4xl text-center font-bold text-gray-800">Review Student Performance</h2>
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
                                        <button 
                                            data-class-id="<%= classModel.getClassId()%>" 
                                            data-class-year="<%= classModel.getYear()%>"
                                            class="bg-purple-600 text-white py-2 px-4 rounded hover:bg-purple-700"
                                            onclick="fetchStudentResultByClass('<%= classModel.getClassId()%>', '<%= classModel.getYear()%>', '<%= classModel.getClassName()%>')">
                                            View Class Academic Performance 
                                        </button>
                                    </div>
                                </div>
                                <% }%>
                            </div>
                        </div>
                        <div id="students-container-for-performance"></div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
