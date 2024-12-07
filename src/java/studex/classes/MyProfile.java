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
}
