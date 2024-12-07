package studex.classes;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ManageAdminStudent {

    public String addStudent(String name, String email, String phoneNo, String password, String userType) {
        String message = "Student added successfully!";
        String query = "INSERT INTO user (name, email, phone_no, password, user_type, enrollment_date) VALUES (?, ?, ?, ?, ?, CURDATE())";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phoneNo);
            stmt.setString(4, password);
            stmt.setString(5, userType);
            stmt.executeUpdate();
        } catch (SQLException e) {
            message = "Error: Unable to add student!";
            e.printStackTrace();
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
        String sql = "SELECT * FROM user WHERE user_id = ?";
        try (Connection conn = DBHelper.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                student = new Student(
                        rs.getInt("user_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("phone_no"),
                        rs.getString("enrollment_date"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return student;
    }

    public String updateStudent(int userId, String name, String email, String phoneNo, String enrollDate, String password) {
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
            if (password != null && !password.isEmpty()) {
                stmt.setString(index++, password);
            }
            stmt.setInt(index, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            message = "Error: Unable to update student!";
            e.printStackTrace();
        }
        return message;
    }

    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String query = "SELECT * FROM user WHERE user_type = ?";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, "Student");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Student student = new Student(
                            rs.getInt("user_id"),
                            rs.getString("name"),
                            rs.getString("email"),
                            rs.getString("phone_no"),
                            rs.getString("enrollment_date")
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
