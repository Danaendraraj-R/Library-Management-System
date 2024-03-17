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

@WebServlet("/DeleteBook")
public class DeleteBook extends HttpServlet {


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int BookId =Integer.parseInt(request.getParameter("bookId"));
        try {
            Connection connection = DBConnection.getConnection();
            String sql = "DELETE FROM books WHERE bookid = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setInt(1, BookId);
                statement.executeUpdate();
            }
            DBConnection.closeConnection(connection);
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

}
