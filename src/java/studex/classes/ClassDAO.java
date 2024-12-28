package studex.classes;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClassDAO {
    
    // Method to retrieve all classes from the database
    public List<ClassModel> getAvailableClasses() {
        List<ClassModel> classes = new ArrayList<>();
        String query = "SELECT * FROM Class";  // Adjust query if necessary

        try (Connection conn = DBHelper.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int classId = rs.getInt("class_id");
                String className = rs.getString("name");
                int year = rs.getInt("year");
                classes.add(new ClassModel(classId, className, year));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return classes;
    }
}
