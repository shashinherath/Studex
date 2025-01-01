package studex.classes;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ManageAdminClass {

    public String addClass(String className, int year) {
        String message = "Class added successfully!";
        String query = "INSERT INTO class (name, year) VALUES (?, ?)";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, className);
            stmt.setInt(2, year);
            stmt.executeUpdate();
        } catch (SQLException e) {
            message = "Error: Unable to add class!";
            e.printStackTrace();
        }
        return message;
    }

    public String deleteClass(int classId) {
        String message = "Class deleted successfully!";
        String query = "DELETE FROM class WHERE class_id = ?";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, classId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            message = "Error: Unable to delete class!";
            e.printStackTrace();
        }
        return message;
    }

    public ClassModel getClass(int classId) {
        ClassModel classmodel = null;
        String sql = "SELECT * FROM class WHERE class_id = ?";
        try (Connection conn = DBHelper.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, classId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                classmodel = new ClassModel(
                        rs.getInt("class_id"),
                        rs.getString("name"),
                        rs.getInt("year")
                       );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return classmodel;
    }

    public String updateClass(int classId, String className, int year) {
        String message = "Class updated successfully!";
        StringBuilder query = new StringBuilder("UPDATE class SET ");
        boolean first = true;

        if (className != null && !className.isEmpty()) {
            query.append("name = ?");
            first = false;
        }
        if (year != 0) {
            if (!first) {
                query.append(", ");
            }
            query.append("year = ?");
            first = false;
        }
        query.append(" WHERE class_id = ?");

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            int index = 1;
            if (className != null && !className.isEmpty()) {
                stmt.setString(index++, className);
            }
            if (year != 0) {
                stmt.setInt(index++, year);
            }
            stmt.setInt(index, classId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            message = "Error: Unable to update class!";
            e.printStackTrace();
        }
        return message;
    }

    public List<ClassModel> getAllclass() {
        List<ClassModel> classes = new ArrayList<>();
        String query = "SELECT * FROM class";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ClassModel classmodel = new ClassModel(
                            rs.getInt("class_id"),
                            rs.getString("name"),
                            rs.getInt("year")
                    );
                    classes.add(classmodel);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return classes;
    }
}