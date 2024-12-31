package studex.classes;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ManageAdminSubject {

    public String addSubject(String name) {
        String message = "Subject added successfully!";
        String query = "INSERT INTO subject (name) VALUES (?)";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, name);
            stmt.executeUpdate();
        } catch (SQLException e) {
            message = "Error: Unable to add subject!";
            e.printStackTrace();
        }
        return message;
    }

    public String deleteSubject(int subjectId) {
        String message = "Subject deleted successfully!";
        String query = "DELETE FROM subject WHERE subject_id = ?";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, subjectId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            message = "Error: Unable to delete subject!";
            e.printStackTrace();
        }
        return message;
    }

    public Subject getSubject(int subjectId) {
        Subject subject = null;
        String sql = "SELECT * FROM subject WHERE subject_id = ?";
        try (Connection conn = DBHelper.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, subjectId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                subject = new Subject(
                        rs.getInt("subject_id"),
                        rs.getString("name")
                       );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subject;
    }

    public String updateSubject(int subjectId, String name) {
        String message = "Subject updated successfully!";
        StringBuilder query = new StringBuilder("UPDATE subject SET ");
        boolean first = true;

        if (name != null && !name.isEmpty()) {
            query.append("name = ?");
            first = false;
        }
        query.append(" WHERE subject_id = ?");

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            int index = 1;
            if (name != null && !name.isEmpty()) {
                stmt.setString(index++, name);
            }
            stmt.setInt(index, subjectId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            message = "Error: Unable to update subject!";
            e.printStackTrace();
        }
        return message;
    }

    public List<Subject> getAllSubject() {
        List<Subject> subjects = new ArrayList<>();
        String query = "SELECT * FROM subject";

        try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Subject subject = new Subject(
                            rs.getInt("subject_id"),
                            rs.getString("name")
                    );
                    subjects.add(subject);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return subjects;
    }
}