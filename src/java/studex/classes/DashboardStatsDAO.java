package studex.classes;

import java.sql.*;
import studex.classes.DBHelper;

public class DashboardStatsDAO {

    public int getCount(String tableName, String userType) {
        int count = 0;
        String query;

        if ("user".equals(tableName)) {
            query = "SELECT COUNT(*) FROM " + tableName + " WHERE user_type = ?";
        } else {
            query = "SELECT COUNT(*) FROM " + tableName;
        }

        try (Connection conn = DBHelper.getConnection(); PreparedStatement statement = conn.prepareStatement(query)) {

            if ("user".equals(tableName)) {
                statement.setString(1, userType);
            }

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    count = resultSet.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }
}
