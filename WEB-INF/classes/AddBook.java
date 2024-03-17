package com.library;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DatabaseConnection.DBConnection;

@WebServlet("/AddBook")
public class AddBook extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        String bookName = request.getParameter("BookName");
        String description = request.getParameter("Description");
        String author = request.getParameter("Author");
        int quantity = Integer.parseInt(request.getParameter("Quantity"));

        try {

            Connection connection = DBConnection.getConnection();

            String query = "INSERT INTO books (bookname, description, author, quantity) VALUES (?, ?, ?, ?)";
            try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                preparedStatement.setString(1, bookName);
                preparedStatement.setString(2, description);
                preparedStatement.setString(3, author);
                preparedStatement.setInt(4, quantity);

                int rowsAffected = preparedStatement.executeUpdate();

                if (rowsAffected > 0) {
                    response.getWriter().write("Book added successfully!");
                } else {
                    response.getWriter().write("Error adding book");
                }
            }
            DBConnection.closeConnection(connection);
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("Error processing the request");
        }
    }
}
