package studex.classes;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.UUID;

public class TokenUtils {

    // Method to generate a secure token
    public static String generateToken(String username) {
        try {
            // Use UUID for uniqueness and system time for additional entropy
            String rawToken = username + ":" + UUID.randomUUID().toString() + ":" + System.currentTimeMillis();
            
            // Use SHA-256 to hash the raw token for security
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(rawToken.getBytes());
            
            // Encode the hashed bytes into Base64 to make the token URL-safe and readable
            return Base64.getEncoder().encodeToString(hashBytes);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error generating token: " + e.getMessage(), e);
        }
    }
}
