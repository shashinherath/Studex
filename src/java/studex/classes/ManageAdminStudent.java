package studex.classes;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ManageAdminStudent {

    public String addStudent(String name, String email, String phoneNo) {
        String message = "Student added successfully!";
        String query = "INSERT INTO user (name, email, phone_no, class) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phoneNo);
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

    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String query = "SELECT * FROM user WHERE user_type = ?";

        try (Connection conn = DBHelper.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, "Student");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Student student = new Student(
                            rs.getInt("user_id"),
                            rs.getString("name"),
                            rs.getString("email"),
                            rs.getString("phone_no")
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
