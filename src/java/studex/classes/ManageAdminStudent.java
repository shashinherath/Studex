package studex.classes;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ManageAdminStudent {

    public String addStudent(String name, String email, String phoneNo, String password, String userType, String classId, String guardianName) {
        String message = "Student added successfully!";
        String insertUserQuery = "INSERT INTO user (name, email, phone_no, password, user_type, enrollment_date) VALUES (?, ?, ?, ?, ?, CURDATE())";
        String insertStudentQuery = "INSERT INTO student (user_id, guardian_name) VALUES (?, ?)";
        String insertEnrolledQuery = "INSERT INTO enrolled (student_id, class_id) VALUES (?, ?)";

        try (Connection conn = DBHelper.getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            // Step 1: Insert into `user` table and retrieve `user_id`
            int userId = 0;
            try (PreparedStatement userStmt = conn.prepareStatement(insertUserQuery, Statement.RETURN_GENERATED_KEYS)) {
                userStmt.setString(1, name);
                userStmt.setString(2, email);
                userStmt.setString(3, phoneNo);
                userStmt.setString(4, password);
                userStmt.setString(5, userType);
                userStmt.executeUpdate();

                try (ResultSet rs = userStmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        userId = rs.getInt(1);
                    }
                }
            }

            // Step 2: Insert into `student` table and retrieve `student_id`
            int studentId = 0;
            try (PreparedStatement studentStmt = conn.prepareStatement(insertStudentQuery, Statement.RETURN_GENERATED_KEYS)) {
                studentStmt.setInt(1, userId);
                studentStmt.setString(2, guardianName);
                studentStmt.executeUpdate();

                try (ResultSet rs = studentStmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        studentId = rs.getInt(1);
                    }
                }
            }

            // Step 3: Insert into `enrolled` table
            try (PreparedStatement ownStmt = conn.prepareStatement(insertEnrolledQuery)) {
                ownStmt.setInt(1, studentId);
                ownStmt.setString(2, classId);
                ownStmt.executeUpdate();
            }

            conn.commit(); // Commit transaction
        } catch (SQLException e) {
            message = "Error: Unable to add student!";
            e.printStackTrace();
            try (Connection conn = DBHelper.getConnection()) {
                conn.rollback(); // Rollback transaction on failure
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
        }

        return message;
    }

    public String deleteStudent(int userId) {
        String message = "Student deleted successfully!";
        String query = "DELETE FROM user WHERE user_id = ?";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            message = "Error: Unable to delete student!";
            e.printStackTrace();
        }
        return message;
    }

    public Student getStudent(int userId) {
        Student student = null;
        String sql = "SELECT u.user_id, u.name, u.email, u.phone_no, u.enrollment_date, e.class_id, s.guardian_name "
                + "FROM user u "
                + "JOIN student s ON u.user_id = s.user_id "
                + "LEFT JOIN enrolled e ON s.student_id = e.student_id "
                + "WHERE u.user_id = ?";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                student = new Student(
                        rs.getInt("user_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("phone_no"),
                        rs.getString("enrollment_date"),
                        rs.getString("class_id"),
                        rs.getString("guardian_name")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return student;
    }

    public String updateStudent(int userId, String name, String email, String phoneNo, String enrollDate, String classId, String guardianName, String password) {
        String message = "Student updated successfully!";
        StringBuilder query = new StringBuilder("UPDATE user SET ");
        boolean first = true;

        if (name != null && !name.isEmpty()) {
            query.append("name = ?");
            first = false;
        }
        if (email != null && !email.isEmpty()) {
            if (!first) {
                query.append(", ");
            }
            query.append("email = ?");
            first = false;
        }
        if (phoneNo != null && !phoneNo.isEmpty()) {
            if (!first) {
                query.append(", ");
            }
            query.append("phone_no = ?");
            first = false;
        }
        if (enrollDate != null && !enrollDate.isEmpty()) {
            if (!first) {
                query.append(", ");
            }
            query.append("enrollment_date = ?");
        }
        if (password != null && !password.isEmpty()) {
            if (!first) {
                query.append(", ");
            }
            query.append("password = ?");
        }
        query.append(" WHERE user_id = ?");

        try (Connection conn = DBHelper.getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            // Update user table
            try (PreparedStatement stmt = conn.prepareStatement(query.toString())) {
                int index = 1;
                if (name != null && !name.isEmpty()) {
                    stmt.setString(index++, name);
                }
                if (email != null && !email.isEmpty()) {
                    stmt.setString(index++, email);
                }
                if (phoneNo != null && !phoneNo.isEmpty()) {
                    stmt.setString(index++, phoneNo);
                }
                if (enrollDate != null && !enrollDate.isEmpty()) {
                    stmt.setString(index++, enrollDate);
                }
                if (password != null && !password.isEmpty()) {
                    stmt.setString(index++, password);
                }
                stmt.setInt(index, userId);
                stmt.executeUpdate();
            }

            // Update or insert guardian_name in student table
            if (guardianName != null && !guardianName.isEmpty()) {
                String studentUpdateQuery = "UPDATE student SET guardian_name = ? WHERE user_id = ?";
                try (PreparedStatement studentStmt = conn.prepareStatement(studentUpdateQuery)) {
                    studentStmt.setString(1, guardianName);
                    studentStmt.setInt(2, userId);
                    studentStmt.executeUpdate();
                }
            }

            // Update or insert into `enrolled` table for class_id
            if (classId != null && !classId.isEmpty()) {
                String checkEnrolledQuery = "SELECT class_id FROM enrolled WHERE student_id = (SELECT student_id FROM student WHERE user_id = ?)";
                String updateEnrolledQuery = "UPDATE enrolled SET class_id = ? WHERE student_id = (SELECT student_id FROM student WHERE user_id = ?)";
                String insertEnrolledQuery = "INSERT INTO enrolled (student_id, class_id) SELECT student_id, ? FROM student WHERE user_id = ?";

                try (PreparedStatement checkStmt = conn.prepareStatement(checkEnrolledQuery)) {
                    checkStmt.setInt(1, userId);
                    try (ResultSet rs = checkStmt.executeQuery()) {
                        if (rs.next()) {
                            // Record exists, update it
                            try (PreparedStatement updateStmt = conn.prepareStatement(updateEnrolledQuery)) {
                                updateStmt.setString(1, classId);
                                updateStmt.setInt(2, userId);
                                updateStmt.executeUpdate();
                            }
                        } else {
                            // Record doesn't exist, insert it
                            try (PreparedStatement insertStmt = conn.prepareStatement(insertEnrolledQuery)) {
                                insertStmt.setString(1, classId);
                                insertStmt.setInt(2, userId);
                                insertStmt.executeUpdate();
                            }
                        }
                    }
                }
            }

            conn.commit(); // Commit transaction
        } catch (SQLException e) {
            message = "Error: Unable to update student!";
            e.printStackTrace();
        }
        return message;
    }

    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String query = "SELECT u.user_id, u.name, u.email, u.phone_no, u.enrollment_date, e.class_id, s.guardian_name "
                + "FROM user u "
                + "JOIN student s ON u.user_id = s.user_id "
                + "LEFT JOIN enrolled e ON s.student_id = e.student_id "
                + "WHERE u.user_type = 'student'";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Student student = new Student(
                            rs.getInt("user_id"),
                            rs.getString("name"),
                            rs.getString("email"),
                            rs.getString("phone_no"),
                            rs.getString("enrollment_date"),
                            rs.getString("class_id"),
                            rs.getString("guardian_name")
                    );
                    students.add(student);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }
}
