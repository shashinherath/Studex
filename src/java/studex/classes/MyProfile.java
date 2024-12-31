package studex.classes;

import java.sql.*;
/**
 *
 * @author Shashin Malinda
 */
public class MyProfile {

    public String getMyUserName(String user_email) {
        String user_name = "";
        
        if (user_email != null) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = DBHelper.getConnection();
                String sql = "SELECT name FROM user WHERE email = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, user_email);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    user_name = rs.getString("name");
                }
            } catch (SQLException e) {
                // Handle error (e.g., log it)
                user_name = "Error fetching username";
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
        return user_name;
    }
    public String getMyUserId(String user_email) {
        String user_id = "";
        
        if (user_email != null) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = DBHelper.getConnection();
                String sql = "SELECT user_id FROM user WHERE email = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, user_email);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    user_id = rs.getString("user_id");
                }
            } catch (SQLException e) {
                // Handle error (e.g., log it)
                user_id = "Error fetching userId";
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
        return user_id;
    }
    public String getClassId(String teacher_id) {
        String classId = "";
        
        if (teacher_id != null) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = DBHelper.getConnection();
                String sql = "SELECT class_id FROM Own WHERE teacher_id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, teacher_id);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    classId = rs.getString("class_id");
                }
            } catch (SQLException e) {
                // Handle error (e.g., log it)
                classId = "Error fetching userId";
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
        return classId;
    }
    public String getTeacherId(String user_id) {
        String TeacherId = "";
        
        if (user_id != null) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = DBHelper.getConnection();
                String sql = "SELECT teacher_id FROM teacher WHERE user_id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, user_id);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    TeacherId = rs.getString("teacher_id");
                }
            } catch (SQLException e) {
                // Handle error (e.g., log it)
                TeacherId = "Error fetching userId";
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
        return TeacherId;
    }
}
