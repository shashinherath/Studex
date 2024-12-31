package studex.classes;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ManageAdminTeacher {

    public String addTeacher(String name, String email, String phoneNo, String password, String userType, String className) {
        String message = "Teacher added successfully!";
        String query = "INSERT INTO user (name, email, phone_no, password, user_type, enrollment_date, class) VALUES (?, ?, ?, ?, ?, CURDATE(), ?)";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phoneNo);
            stmt.setString(4, password);
            stmt.setString(5, userType);
            stmt.setString(6, className);
            stmt.executeUpdate();
        } catch (SQLException e) {
            message = "Error: Unable to add teacher!";
            e.printStackTrace();
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
        String sql = "SELECT * FROM user WHERE user_id = ?";
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
                        rs.getString("class"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return teacher;
    }

    public String updateTeacher(int userId, String name, String email, String phoneNo, String enrollDate, String className, String password) {
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
        if (className != null && !className.isEmpty()) {
            if (!first) {
                query.append(", ");
            }
            query.append("class = ?");
        }
        if (password != null && !password.isEmpty()) {
            if (!first) {
                query.append(", ");
            }
            query.append("password = ?");
        }
        query.append(" WHERE user_id = ?");

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query.toString())) {
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
            if (className != null && !className.isEmpty()) {
                stmt.setString(index++, className);
            }
            if (password != null && !password.isEmpty()) {
                stmt.setString(index++, password);
            }
            stmt.setInt(index, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            message = "Error: Unable to update teacher!";
            e.printStackTrace();
        }
        return message;
    }

    public List<Teacher> getAllTeachers() {
        List<Teacher> teachers = new ArrayList<>();
        String query = "SELECT * FROM user WHERE user_type = ?";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, "teacher");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Teacher teacher = new Teacher(
                            rs.getInt("user_id"),
                            rs.getString("name"),
                            rs.getString("email"),
                            rs.getString("phone_no"),
                            rs.getString("enrollment_date"),
                            rs.getString("class")
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
