<%@page import="studex.classes.MyProfile"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="studex.classes.SessionValidator" %>
<%@ page import="studex.classes.ManageAdminStudent, java.util.List, studex.classes.Student" %>
<%
    // Perform session validation
    boolean isValidSession = SessionValidator.isSessionValid(request);

    if (!isValidSession) {
        // If session is not valid, redirect to the login page
        response.sendRedirect("index.jsp");
        return; // Stop further processing of the page
    }

    //get username
    String user_email = (String) session.getAttribute("email");
    MyProfile profile = new MyProfile();
    String user_name = profile.getMyUserName(user_email);

    //add student
    String action = request.getParameter("action");
    ManageAdminStudent manager = new ManageAdminStudent();
    String message = "";

    if ("add".equals(action)) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneNo = request.getParameter("phone_no");
        String password = request.getParameter("password");
        String userType = "Student";
        message = manager.addStudent(name, email, phoneNo, password, userType);
    } else if ("delete".equals(action)) {
        int userId = Integer.parseInt(request.getParameter("user_id"));
        message = manager.deleteStudent(userId);
    } else if ("getStudent".equals(action)) {
        int userId = Integer.parseInt(request.getParameter("user_id"));
        Student student = manager.getStudent(userId);
        if (student == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"error\":\"Student not found\"}");
            return;
        }
        String json = "{";
        json += "\"userId\":\"" + student.getUserId() + "\",";
        json += "\"name\":\"" + student.getName() + "\",";
        json += "\"email\":\"" + student.getEmail() + "\",";
        json += "\"phoneNo\":\"" + student.getPhoneNo() + "\",";
        json += "\"enrollDate\":\"" + student.getEnrollDate() + "\"";
        json += "}";
        response.setContentType("application/json");
        response.getWriter().write(json);
        return;
    } else if ("update".equals(action)) {
        int userId = Integer.parseInt(request.getParameter("user_id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneNo = request.getParameter("phone_no");
        String enrollDate = request.getParameter("enrollDate");
        String password = request.getParameter("password");

        // Update student details
        message = manager.updateStudent(userId, name, email, phoneNo, enrollDate, password);
    }

    List<Student> students = manager.getAllStudents();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta http-equiv="X-UA-Compatible" content="ie=edge" />

        <link rel="preconnect" href="https://fonts.bunny.net" />
        <link
            href="https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap"
            rel="stylesheet"
            />
        <link
            href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css"
            rel="stylesheet"
            />
        <link
            href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css"
            rel="stylesheet"
            />
        <script src="https://cdn.tailwindcss.com"></script>

        <title>Admin Panel</title>
    </head>
    <body class="text-gray-800 font-inter">
        <div
            class="fixed left-0 top-0 w-64 h-full bg-[#f8f4f3] p-4 z-50 sidebar-menu transition-transform"
            >
            <a href="#" class="flex items-center pb-4 border-b border-b-gray-800">
                <img src="./resources/images/logo/logoStudex.png" class="h-18 w-auto" />
            </a>
            <ul class="mt-4">
                <span class="text-gray-400 font-bold">ADMIN PANEL</span>
                <li class="mb-1 group">
                    <a
                        href="/Studex/admin-home.jsp"
                        class="flex font-semibold items-center py-2 px-4 text-gray-900 hover:bg-gray-950 hover:text-gray-100 rounded-md group-[.active]:bg-gray-800 group-[.active]:text-white group-[.selected]:bg-gray-950 group-[.selected]:text-gray-100"
                        >
                        <i class="ri-home-2-line mr-3 text-lg"></i>
                        <span class="text-sm">Dashboard</span>
                    </a>
                </li>
                <li class="mb-1 group">
                    <a
                        href="/Studex/admin-student.jsp"
                        class="flex font-semibold items-center py-2 px-4 text-gray-900 hover:bg-gray-950 hover:text-gray-100 rounded-md bg-gray-700 text-white group-[.selected]:bg-gray-950 group-[.selected]:text-gray-100"
                        >
                        <i class="ri-user-line mr-3 text-lg"></i>
                        <span class="text-sm">Students</span>
                    </a>
                </li>
                <li class="mb-1 group">
                    <a
                        href="/Studex/admin-teacher.jsp"
                        class="flex font-semibold items-center py-2 px-4 text-gray-900 hover:bg-gray-950 hover:text-gray-100 rounded-md group-[.active]:bg-gray-800 group-[.active]:text-white group-[.selected]:bg-gray-950 group-[.selected]:text-gray-100"
                        >
                        <i class="ri-user-2-line mr-3 text-lg"></i>
                        <span class="text-sm">Teachers</span>
                    </a>
                </li>
                <li class="mb-1 group">
                    <a
                        href="/Studex/admin-subject.jsp"
                        class="flex font-semibold items-center py-2 px-4 text-gray-900 hover:bg-gray-950 hover:text-gray-100 rounded-md group-[.active]:bg-gray-800 group-[.active]:text-white group-[.selected]:bg-gray-950 group-[.selected]:text-gray-100"
                        >
                        <i class="ri-book-line mr-3 text-lg"></i>
                        <span class="text-sm">Subjects</span>
                    </a>
                </li>
                <li class="mb-1 group">
                    <a
                        href="/Studex/admin-class.jsp"
                        class="flex font-semibold items-center py-2 px-4 text-gray-900 hover:bg-gray-950 hover:text-gray-100 rounded-md group-[.active]:bg-gray-800 group-[.active]:text-white group-[.selected]:bg-gray-950 group-[.selected]:text-gray-100"
                        >
                        <i class="ri-graduation-cap-line mr-3 text-lg"></i>
                        <span class="text-sm">Classes</span>
                    </a>
                </li>
            </ul>
        </div>
        <div
            class="fixed top-0 left-0 w-full h-full bg-black/50 z-40 md:hidden sidebar-overlay"
            ></div>

        <main
            class="w-full md:w-[calc(100%-256px)] md:ml-64 bg-gray-200 min-h-screen transition-all main"
            >
            <div
                class="py-2 px-6 bg-[#f8f4f3] flex items-center shadow-md shadow-black/5 sticky top-0 left-0 z-30"
                >
                <button
                    type="button"
                    class="text-lg text-gray-900 font-semibold sidebar-toggle"
                    ></button>

                <ul class="ml-auto flex items-center">
                    <button id="fullscreen-button">
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="24"
                            height="24"
                            class="hover:bg-gray-100 rounded-full"
                            viewBox="0 0 24 24"
                            style="fill: gray"
                            >
                        <path
                            d="M5 5h5V3H3v7h2zm5 14H5v-5H3v7h7zm11-5h-2v5h-5v2h7zm-2-4h2V3h-7v2h5z"
                            ></path>
                        </svg>
                    </button>
                    <script>
                        const fullscreenButton =
                                document.getElementById("fullscreen-button");

                        fullscreenButton.addEventListener("click", toggleFullscreen);

                        function toggleFullscreen() {
                            if (document.fullscreenElement) {
                                // If already in fullscreen, exit fullscreen
                                document.exitFullscreen();
                            } else {
                                // If not in fullscreen, request fullscreen
                                document.documentElement.requestFullscreen();
                            }
                        }
                    </script>

                    <li class="dropdown ml-3">
                        <button type="button" class="dropdown-toggle flex items-center">
                            <div class="p-2 md:block text-left">
                                <h2 class="text-sm font-semibold text-gray-800"><%= user_name != null && !user_name.isEmpty() ? user_name : "User"%></h2>
                                <p class="text-xs text-gray-500">Administrator</p>
                            </div>
                        </button>
                        <ul
                            class="dropdown-menu shadow-md shadow-black/5 z-30 hidden py-1.5 rounded-md bg-white border border-gray-100 w-full max-w-[140px]"
                            >
                            <li>
                                <a
                                    href="#"
                                    class="flex items-center text-[13px] py-1.5 px-4 text-gray-600 hover:text-[#f84525] hover:bg-gray-50"
                                    >Profile</a
                                >
                            </li>

                            <li>
                                <form method="POST" action="">
                                    <a
                                        role="menuitem"
                                        class="flex items-center text-[13px] py-1.5 px-4 text-gray-600 hover:text-[#f84525] hover:bg-gray-50 cursor-pointer"
                                        onclick="event.preventDefault();
                                                this.closest('form').submit();"
                                        >
                                        Log Out
                                    </a>
                                </form>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
            <!-- end navbar -->

            <!-- Content -->
            <div>
                <h1 class="text-4xl font-bold pl-10 pt-10">Students</h1>
            </div>
            <div class="border border-gray-300 rounded-lg shadow-md mx-10 bg-white my-10">
                <div class="container mx-auto p-10">

                    <% if (!message.isEmpty()) {%>
                    <div class="bg-green-100 text-green-700 px-4 py-2 rounded mb-4">
                        <%= message%>
                    </div>
                    <% } %>

                    <button onclick="document.getElementById('addModal').classList.remove('hidden')" 
                            class="bg-blue-500 text-white px-4 py-2 rounded mb-4">Add New Student</button>

                    <table class="table-auto w-full bg-white shadow-md rounded">
                        <thead>
                            <tr class="bg-gray-200">
                                <th class="px-4 py-2">Name</th>
                                <th class="px-4 py-2">Email</th>
                                <th class="px-4 py-2">Phone</th>
                                <th class="px-4 py-2">Enrollment Date</th>
                                <th class="px-4 py-2"></th>
                                <th class="px-4 py-2"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Student student : students) {%>
                            <tr>
                                <td class="border px-4 py-2"><%= student.getName()%></td>
                                <td class="border px-4 py-2"><%= student.getEmail()%></td>
                                <td class="border px-4 py-2"><%= student.getPhoneNo()%></td>
                                <td class="border px-4 py-2"><%= student.getEnrollDate()%></td>
                                <td class="border px-4 py-2">
                                    <form method="post" style="display:inline;" onsubmit="openUpdateModal(<%= student.getUserId()%>)">
                                        <input type="hidden" name="action" value="getStudent">
                                        <input type="hidden" name="user_id" value="<%= student.getUserId()%>">
                                        <button type="submit" class="bg-green-500 text-white px-2 py-1 rounded">Update</button>
                                    </form>
                                </td>                               
                                <td class="border px-4 py-2">
                                    <form method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="user_id" value="<%= student.getUserId()%>">
                                        <button type="submit" class="bg-red-500 text-white px-2 py-1 rounded">Delete</button>
                                    </form>
                                </td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Add Student Modal -->
            <div id="addModal" class="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center hidden">
                <div class="bg-white p-4 rounded shadow-lg w-96">
                    <h2 class="text-xl font-bold mb-4">Add New Student</h2>
                    <form method="post" action="admin-student.jsp">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-4">
                            <label class="block text-gray-700">Name</label>
                            <input type="text" name="name" class="border rounded w-full px-3 py-2">
                        </div>
                        <div class="mb-4">
                            <label class="block text-gray-700">Email</label>
                            <input type="email" name="email" class="border rounded w-full px-3 py-2">
                        </div>
                        <div class="mb-4">
                            <label class="block text-gray-700">Phone</label>
                            <input type="text" name="phone_no" class="border rounded w-full px-3 py-2">
                        </div>
                        <div class="mb-4">
                            <label class="block text-gray-700">Password</label>
                            <input type="password" name="password" class="border rounded w-full px-3 py-2">
                        </div>
                        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded">Add</button>
                        <button type="button" onclick="document.getElementById('addModal').classList.add('hidden')" class="bg-gray-500 text-white px-4 py-2 rounded">Cancel</button>
                    </form>
                </div>
            </div>

            <!-- Update Student Model -->
            <div id="updateModal" class="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center hidden">
                <div class="bg-white p-4 rounded shadow-lg w-96">
                    <h2 class="text-xl font-bold mb-4">Update Student</h2>
                    <form id="updateForm" method="post" action="admin-student.jsp">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="user_id" id="update_user_id">
                        <div class="mb-4">
                            <label class="block text-gray-700">Name</label>
                            <input type="text" name="name" id="update_name" class="border rounded w-full px-3 py-2">
                        </div>
                        <div class="mb-4">
                            <label class="block text-gray-700">Email</label>
                            <input type="email" name="email" id="update_email" class="border rounded w-full px-3 py-2">
                        </div>
                        <div class="mb-4">
                            <label class="block text-gray-700">Phone</label>
                            <input type="text" name="phone_no" id="update_phone_no" class="border rounded w-full px-3 py-2">
                        </div>
                        <div class="mb-4">
                            <label class="block text-gray-700">Enroll Date</label>
                            <input type="text" name="enrollDate" id="update_enrollDate" class="border rounded w-full px-3 py-2">
                        </div>
                        <div class="mb-4">
                            <label class="block text-gray-700">Password</label>
                            <input type="password" name="password" id="update_password" class="border rounded w-full px-3 py-2">
                        </div>
                        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded">Update</button>
                        <button type="button" onclick="document.getElementById('updateModal').classList.add('hidden')" class="bg-gray-500 text-white px-4 py-2 rounded">Cancel</button>
                    </form>
                </div>
            </div>
        </div>
        <!-- End Content -->
    </main>

    <script src="https://unpkg.com/@popperjs/core@2"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
                                // start: Sidebar
                                const sidebarToggle = document.querySelector(".sidebar-toggle");
                                const sidebarOverlay = document.querySelector(".sidebar-overlay");
                                const sidebarMenu = document.querySelector(".sidebar-menu");
                                const main = document.querySelector(".main");
                                sidebarToggle.addEventListener("click", function (e) {
                                    e.preventDefault();
                                    main.classList.toggle("active");
                                    sidebarOverlay.classList.toggle("hidden");
                                    sidebarMenu.classList.toggle("-translate-x-full");
                                });
                                sidebarOverlay.addEventListener("click", function (e) {
                                    e.preventDefault();
                                    main.classList.add("active");
                                    sidebarOverlay.classList.add("hidden");
                                    sidebarMenu.classList.add("-translate-x-full");
                                });
                                document
                                        .querySelectorAll(".sidebar-dropdown-toggle")
                                        .forEach(function (item) {
                                            item.addEventListener("click", function (e) {
                                                e.preventDefault();
                                                const parent = item.closest(".group");
                                                if (parent.classList.contains("selected")) {
                                                    parent.classList.remove("selected");
                                                } else {
                                                    document
                                                            .querySelectorAll(".sidebar-dropdown-toggle")
                                                            .forEach(function (i) {
                                                                i.closest(".group").classList.remove("selected");
                                                            });
                                                    parent.classList.add("selected");
                                                }
                                            });
                                        });
                                // end: Sidebar

                                // start: Popper
                                const popperInstance = {};
                                document.querySelectorAll(".dropdown").forEach(function (item, index) {
                                    const popperId = "popper-" + index;
                                    const toggle = item.querySelector(".dropdown-toggle");
                                    const menu = item.querySelector(".dropdown-menu");
                                    menu.dataset.popperId = popperId;
                                    popperInstance[popperId] = Popper.createPopper(toggle, menu, {
                                        modifiers: [
                                            {
                                                name: "offset",
                                                options: {
                                                    offset: [0, 8],
                                                },
                                            },
                                            {
                                                name: "preventOverflow",
                                                options: {
                                                    padding: 24,
                                                },
                                            },
                                        ],
                                        placement: "bottom-end",
                                    });
                                });
                                document.addEventListener("click", function (e) {
                                    const toggle = e.target.closest(".dropdown-toggle");
                                    const menu = e.target.closest(".dropdown-menu");
                                    if (toggle) {
                                        const menuEl = toggle
                                                .closest(".dropdown")
                                                .querySelector(".dropdown-menu");
                                        const popperId = menuEl.dataset.popperId;
                                        if (menuEl.classList.contains("hidden")) {
                                            hideDropdown();
                                            menuEl.classList.remove("hidden");
                                            showPopper(popperId);
                                        } else {
                                            menuEl.classList.add("hidden");
                                            hidePopper(popperId);
                                        }
                                    } else if (!menu) {
                                        hideDropdown();
                                    }
                                });

                                function hideDropdown() {
                                    document.querySelectorAll(".dropdown-menu").forEach(function (item) {
                                        item.classList.add("hidden");
                                    });
                                }
                                function showPopper(popperId) {
                                    popperInstance[popperId].setOptions(function (options) {
                                        return {
                                            ...options,
                                            modifiers: [
                                                ...options.modifiers,
                                                {name: "eventListeners", enabled: true},
                                            ],
                                        };
                                    });
                                    popperInstance[popperId].update();
                                }
                                function hidePopper(popperId) {
                                    popperInstance[popperId].setOptions(function (options) {
                                        return {
                                            ...options,
                                            modifiers: [
                                                ...options.modifiers,
                                                {name: "eventListeners", enabled: false},
                                            ],
                                        };
                                    });
                                }
                                // end: Popper

                                // start: Tab
                                document.querySelectorAll("[data-tab]").forEach(function (item) {
                                    item.addEventListener("click", function (e) {
                                        e.preventDefault();
                                        const tab = item.dataset.tab;
                                        const page = item.dataset.tabPage;
                                        const target = document.querySelector(
                                                '[data-tab-for="' + tab + '"][data-page="' + page + '"]'
                                                );
                                        document
                                                .querySelectorAll('[data-tab="' + tab + '"]')
                                                .forEach(function (i) {
                                                    i.classList.remove("active");
                                                });
                                        document
                                                .querySelectorAll('[data-tab-for="' + tab + '"]')
                                                .forEach(function (i) {
                                                    i.classList.add("hidden");
                                                });
                                        item.classList.add("active");
                                        target.classList.remove("hidden");
                                    });
                                });
                                // end: Tab

                                // start: Chart
                                new Chart(document.getElementById("order-chart"), {
                                    type: "line",
                                    data: {
                                        labels: generateNDays(7),
                                        datasets: [
                                            {
                                                label: "Active",
                                                data: generateRandomData(7),
                                                borderWidth: 1,
                                                fill: true,
                                                pointBackgroundColor: "rgb(59, 130, 246)",
                                                borderColor: "rgb(59, 130, 246)",
                                                backgroundColor: "rgb(59 130 246 / .05)",
                                                tension: 0.2,
                                            },
                                            {
                                                label: "Completed",
                                                data: generateRandomData(7),
                                                borderWidth: 1,
                                                fill: true,
                                                pointBackgroundColor: "rgb(16, 185, 129)",
                                                borderColor: "rgb(16, 185, 129)",
                                                backgroundColor: "rgb(16 185 129 / .05)",
                                                tension: 0.2,
                                            },
                                            {
                                                label: "Canceled",
                                                data: generateRandomData(7),
                                                borderWidth: 1,
                                                fill: true,
                                                pointBackgroundColor: "rgb(244, 63, 94)",
                                                borderColor: "rgb(244, 63, 94)",
                                                backgroundColor: "rgb(244 63 94 / .05)",
                                                tension: 0.2,
                                            },
                                        ],
                                    },
                                    options: {
                                        scales: {
                                            y: {
                                                beginAtZero: true,
                                            },
                                        },
                                    },
                                });

                                function generateNDays(n) {
                                    const data = [];
                                    for (let i = 0; i < n; i++) {
                                        const date = new Date();
                                        date.setDate(date.getDate() - i);
                                        data.push(
                                                date.toLocaleString("en-US", {
                                                    month: "short",
                                                    day: "numeric",
                                                })
                                                );
                                    }
                                    return data;
                                }
                                function generateRandomData(n) {
                                    const data = [];
                                    for (let i = 0; i < n; i++) {
                                        data.push(Math.round(Math.random() * 10));
                                    }
                                    return data;
                                }
                                // end: Chart

                                function openUpdateModal(userId) {
                                    event.preventDefault();
                                    fetch('admin-student.jsp?action=getStudent&user_id=' + userId)
                                            .then(response => response.json())
                                            .then(data => {
                                                document.getElementById('update_user_id').value = data.userId;
                                                document.getElementById('update_name').value = data.name;
                                                document.getElementById('update_email').value = data.email;
                                                document.getElementById('update_phone_no').value = data.phoneNo;
                                                document.getElementById('update_enrollDate').value = data.enrollDate;
                                                document.getElementById('updateModal').classList.remove('hidden');
                                            });
                                }
    </script>
</body>
</html>
