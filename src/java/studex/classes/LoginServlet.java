package studex.classes;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.*;


@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Get the database connection status message
        String connectionStatus = DBHelper.checkConnection();

        // Validate the user credentials
        String errorMessage = DBHelper.validateUser(username, password);

        // Store the connection status and validation result in request scope
        request.setAttribute("connectionStatus", connectionStatus);
        request.setAttribute("errorMessage", errorMessage);

        if (errorMessage == null) {
            // If there is no error (valid credentials), redirect to the home page
            response.sendRedirect("admin-home.html");
        } else {
            // If there is an error (invalid credentials), forward back to login page
            RequestDispatcher dispatcher = request.getRequestDispatcher("index.html");
            dispatcher.forward(request, response);
        }
    }
}
