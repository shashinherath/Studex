/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package studex.classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Map;

/**
 *
 * @author Chamika Niroshan
 */
public class AttendanceHandler {

    public boolean checkAttendanceMarkStatus(String class_id) {
        boolean isAttendanceMarked = false;

        // Get today's date in the format 'YYYY-MM-DD'
        String todayDate = LocalDate.now().toString();

        if (class_id != null) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = DBHelper.getConnection();
                String sql = "SELECT * FROM attendance_record WHERE class_id = ? AND date = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, class_id);
                stmt.setString(2, todayDate);  // Use today's date
                rs = stmt.executeQuery();

                // If an attendance record exists for today, mark attendance as true
                if (rs.next()) {
                    isAttendanceMarked = true;
                }
            } catch (SQLException e) {
                // Handle error (e.g., log it)
                e.printStackTrace();
            } finally {
                // Close resources manually
                try {
                    if (rs != null) {
                        rs.close();
                    }
                    if (stmt != null) {
                        stmt.close();
                    }
                    if (conn != null) {
                        conn.close();
                    }
                } catch (SQLException e) {
                    // Handle error while closing
                    e.printStackTrace();
                }
            }
        }

        return isAttendanceMarked;
    }

    public boolean updateAttendance(String classId, Map<String, String> attendanceData) {
        String todayDate = LocalDate.now().toString();
        boolean isUpdated = false;

        if (classId != null && attendanceData != null && !attendanceData.isEmpty()) {
            try (Connection conn = DBHelper.getConnection(); PreparedStatement stmt = conn.prepareStatement(
                    "INSERT INTO attendance_record (user_id, class_id, date, status) "
                    + "VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE status = ?")) {

                for (Map.Entry<String, String> entry : attendanceData.entrySet()) {
                    String userId = entry.getKey();
                    String status = entry.getValue();

                    stmt.setString(1, userId);
                    stmt.setString(2, classId);
                    stmt.setString(3, todayDate);
                    stmt.setString(4, status);
                    stmt.setString(5, status);

                    int rowsAffected = stmt.executeUpdate();
                    if (rowsAffected > 0) {
                        isUpdated = true; // Set flag if update is successful
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return isUpdated;
    }

}
