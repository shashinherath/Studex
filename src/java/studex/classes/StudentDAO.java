package studex.classes;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class StudentDAO {

    // Method to retrieve students enrolled in a specific class
    public List<Student> getStudentsByClassId(int classId) {
        System.out.println("Class Id:" + classId);
        List<Student> students = new ArrayList<>();
        
        // Database connection and query using DBHelper
        try (Connection conn = DBHelper.getConnection()) {  // Use DBHelper to get connection
            String sql = "SELECT u.user_id, u.name AS student_name, u.email, u.phone_no, u.enrollment_date,s.guardian_name FROM User u JOIN Student s ON u.user_id = s.user_id JOIN Enrolled e ON s.student_id = e.student_id WHERE e.class_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, classId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        
                        int userId = rs.getInt("user_id");

                        String name = rs.getString("student_name");
                        String email = rs.getString("email");
                        String phoneNo = rs.getString("phone_no");
                        String enrollmentDate = rs.getString("enrollment_date");
                        String guardianName = rs.getString("guardian_name");
                        System.out.println("STUDENT DAO: " + name);
                        Student student = new Student(userId, name, email, phoneNo, enrollmentDate, guardianName);
                        students.add(student);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // You can replace this with better error handling
        }
        
        return students;
    }
}
