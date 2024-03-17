package com.library;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import DatabaseConnection.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ReturnBook")
public class ReturnBook extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Connection conn = DBConnection.getConnection();
            System.out.println("connection successful");

            int Bookid = Integer.parseInt(request.getParameter("BookId"));
            int BorrowId = Integer.parseInt(request.getParameter("BorrowId"));

            PreparedStatement increaseQuantityStmt = conn.prepareStatement("UPDATE books SET quantity = quantity + 1 WHERE bookid = ?");
            increaseQuantityStmt.setInt(1, Bookid);
            increaseQuantityStmt.executeUpdate();
            increaseQuantityStmt.close();

            PreparedStatement setReturnTrueStmt = conn.prepareStatement("UPDATE borrows SET return = true WHERE borrowid = ?");
            setReturnTrueStmt.setInt(1, BorrowId);
            setReturnTrueStmt.executeUpdate();
            setReturnTrueStmt.close();

        DBConnection.closeConnection(conn);
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}
