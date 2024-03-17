package com.library;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import DatabaseConnection.DBConnection;

@WebServlet("/BorrowBook")
public class BorrowBook extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        try {

            Connection conn = DBConnection.getConnection();
            System.out.println("connection successful");

            HttpSession httpSession = request.getSession(true);
            String email = (String) httpSession.getAttribute("email");

            int bookId = Integer.parseInt(request.getParameter("BookId"));

            String bookName = getBookNameById(conn, bookId);

            updateBookQuantity(conn, bookId);

            insertIntoBorrows(conn, bookId, email, bookName);
            DBConnection.closeConnection(conn);

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            e.printStackTrace();
        }
    }

    private String getBookNameById(Connection conn, int bookId) throws SQLException {
        String bookName = null;
        PreparedStatement preparedStatement = conn.prepareStatement("SELECT bookname FROM books WHERE bookid = ?");
        preparedStatement.setInt(1, bookId);
        ResultSet resultSet = preparedStatement.executeQuery();
        if (resultSet.next()) {
            bookName = resultSet.getString("bookname");
        }
        resultSet.close();
        preparedStatement.close();
        return bookName;
    }

    private void updateBookQuantity(Connection conn, int bookId) throws SQLException {
        PreparedStatement preparedStatement = conn.prepareStatement("UPDATE books SET quantity = quantity - 1 WHERE bookid = ?");
        preparedStatement.setInt(1, bookId);
        preparedStatement.executeUpdate();
        preparedStatement.close();
    }

    private void insertIntoBorrows(Connection conn, int bookId, String email, String bookName) throws SQLException {
        PreparedStatement preparedStatement = conn.prepareStatement("INSERT INTO borrows (bookid, borrower, bookname) VALUES (?, ?, ?)");
        preparedStatement.setInt(1, bookId);
        preparedStatement.setString(2, email);
        preparedStatement.setString(3, bookName);
        preparedStatement.executeUpdate();
        preparedStatement.close();
    }
}
