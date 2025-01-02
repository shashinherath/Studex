/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package studex.classes;

/**
 *
 * @author Shashin Malinda
 */
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;

public class PasswordEncryptor {
    public static String hashPassword(String password) throws NoSuchAlgorithmException {
        // Create a MessageDigest instance for SHA-256
        MessageDigest md = MessageDigest.getInstance("SHA-256");

        // Convert the password into bytes and hash it
        byte[] hashedBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));

        // Convert the byte array to a hexadecimal string
        StringBuilder hexString = new StringBuilder();
        for (byte b : hashedBytes) {
            String hex = Integer.toHexString(0xFF & b);
            if (hex.length() == 1) {
                hexString.append('0'); // Add leading zero if necessary
            }
            hexString.append(hex);
        }

        return hexString.toString();
    }
}

