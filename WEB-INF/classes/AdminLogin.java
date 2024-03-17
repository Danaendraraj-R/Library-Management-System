import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import DatabaseConnection.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminLogin")
@SuppressWarnings("unchecked")
public class AdminLogin extends HttpServlet {

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();
        int allow=0;


        try {
            String username=request.getParameter("user");
            String password=request.getParameter("password");

            if(username.equals("Admin") && password.equals("Admin"))
            {
                allow=1;
                System.out.println("Login Successful");
            }
            if(allow == 1)
            {
                
                HttpSession httpSession = request.getSession(true);
                httpSession.setAttribute("role", "Admin");
                response.sendRedirect("AdminDashboard.jsp");
            }
            else{
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
        } 
        catch (Exception e) {
            out.println(e);
        }
    }
}
