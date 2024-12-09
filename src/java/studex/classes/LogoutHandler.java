/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package studex.classes;
import javax.servlet.http.HttpSession;
/**
 *
 * @author Chamika Niroshan
 */
public class LogoutHandler {

    public static void logout(HttpSession session) {
        if (session != null) {
            session.removeAttribute("email");
            session.removeAttribute("userType");
            session.removeAttribute("sessionToken");
            session.invalidate(); // Completely destroy the session
        }
    }
}
