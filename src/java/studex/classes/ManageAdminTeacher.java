package studex.classes;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ManageAdminTeacher {

    public String addTeacher(String name, String email, String phoneNo, String password, String userType, String classId) {
        String message = "Teacher added successfully!";
        String insertUserQuery = "INSERT INTO user (name, email, phone_no, password, user_type, enrollment_date) VALUES (?, ?, ?, ?, ?, CURDATE())";
        String insertTeacherQuery = "INSERT INTO teacher (user_id) VALUES (?)";
        String insertOwnQuery = "INSERT INTO own (teacher_id, class_id) VALUES (?, ?)";

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

            // Step 2: Insert into `teacher` table and retrieve `teacher_id`
            int teacherId = 0;
            try (PreparedStatement teacherStmt = conn.prepareStatement(insertTeacherQuery, Statement.RETURN_GENERATED_KEYS)) {
                teacherStmt.setInt(1, userId);
                teacherStmt.executeUpdate();

                try (ResultSet rs = teacherStmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        teacherId = rs.getInt(1);
                    }
                }
            }

            // Step 3: Insert into `own` table
            try (PreparedStatement ownStmt = conn.prepareStatement(insertOwnQuery)) {
                ownStmt.setInt(1, teacherId);
                ownStmt.setString(2, classId);
                ownStmt.executeUpdate();
            }

            conn.commit(); // Commit transaction
        } catch (SQLException e) {
            message = "Error: Unable to add teacher!";
            e.printStackTrace();
            try (Connection conn = DBHelper.getConnection()) {
                conn.rollback(); // Rollback transaction on failure
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
        }

        return message;
    }

    public String deleteTeacher(int userId) {
        String message = "Teacher deleted successfully!";
        String query = "DELETE FROM user WHERE user_id = ?";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            message = "Error: Unable to delete teacher!";
            e.printStackTrace();
        }
        return message;
    }

    public Teacher getTeacher(int userId) {
        Teacher teacher = null;
        String sql = "SELECT u.user_id, u.name, u.email, u.phone_no, u.enrollment_date, o.class_id "
                + "FROM user u "
                + "JOIN teacher t ON u.user_id = t.user_id "
                + "LEFT JOIN own o ON t.teacher_id = o.teacher_id "
                + "WHERE u.user_id = ?";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                teacher = new Teacher(
                        rs.getInt("user_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("phone_no"),
                        rs.getString("enrollment_date"),
                        rs.getString("class_id")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return teacher;
    }

    public String updateTeacher(int userId, String name, String email, String phoneNo, String enrollDate, String classId, String password) {
        String message = "Teacher updated successfully!";
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

            // Update or insert into `own` table for class_id
            if (classId != null && !classId.isEmpty()) {
                String checkOwnQuery = "SELECT class_id FROM own WHERE teacher_id = (SELECT teacher_id FROM teacher WHERE user_id = ?)";
                String updateOwnQuery = "UPDATE own SET class_id = ? WHERE teacher_id = (SELECT teacher_id FROM teacher WHERE user_id = ?)";
                String insertOwnQuery = "INSERT INTO own (teacher_id, class_id) SELECT teacher_id, ? FROM teacher WHERE user_id = ?";

                try (PreparedStatement checkStmt = conn.prepareStatement(checkOwnQuery)) {
                    checkStmt.setInt(1, userId);
                    try (ResultSet rs = checkStmt.executeQuery()) {
                        if (rs.next()) {
                            // Record exists, update it
                            try (PreparedStatement updateStmt = conn.prepareStatement(updateOwnQuery)) {
                                updateStmt.setString(1, classId);
                                updateStmt.setInt(2, userId);
                                updateStmt.executeUpdate();
                            }
                        } else {
                            // Record doesn't exist, insert it
                            try (PreparedStatement insertStmt = conn.prepareStatement(insertOwnQuery)) {
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
            message = "Error: Unable to update teacher!";
            e.printStackTrace();
        }
        return message;
    }

    public List<Teacher> getAllTeachers() {
        List<Teacher> teachers = new ArrayList<>();
        String query = "SELECT u.user_id, u.name, u.email, u.phone_no, u.enrollment_date, o.class_id "
                + "FROM user u "
                + "JOIN teacher t ON u.user_id = t.user_id "
                + "LEFT JOIN own o ON t.teacher_id = o.teacher_id "
                + "WHERE u.user_type = 'teacher'";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Teacher teacher = new Teacher(
                            rs.getInt("user_id"),
                            rs.getString("name"),
                            rs.getString("email"),
                            rs.getString("phone_no"),
                            rs.getString("enrollment_date"),
                            rs.getString("class_id") // Retrieve class_id
                    );
                    teachers.add(teacher);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return teachers;
    }

}
