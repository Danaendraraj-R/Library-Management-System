package com.library;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import DatabaseConnection.DBConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/BookData")
public class BookData extends HttpServlet {

    private static final long serialVersionUID = 1L;

   protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");


        try {

            Connection connection = DBConnection.getConnection();

            String query = "SELECT * FROM books WHERE quantity > 0";
            try (PreparedStatement preparedStatement = connection.prepareStatement(query);
                 ResultSet resultSet = preparedStatement.executeQuery()) {

                List<Book> books = new ArrayList<>();

                while (resultSet.next()) {
                    Book book = new Book();
                    book.setBookId(resultSet.getInt("bookid"));
                    book.setBookName(resultSet.getString("bookname"));
                    book.setDescription(resultSet.getString("description"));
                    book.setAuthor(resultSet.getString("author"));
                    book.setQuantity(resultSet.getInt("quantity"));
                    books.add(book);
                }

                StringBuilder jsonBuilder = new StringBuilder("[");
                for (Book book : books) {
                    jsonBuilder.append(book.toJsonString()).append(",");
                }
                if (books.size() > 0) {
                    jsonBuilder.deleteCharAt(jsonBuilder.length() - 1);
                }
                jsonBuilder.append("]");

                try (PrintWriter out = response.getWriter()) {
                    out.print(jsonBuilder.toString().trim());
                    out.flush();
                }
            }
            DBConnection.closeConnection(connection);
        } catch (Exception e) {
            log("Error in BookData servlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        }
    }

    private static class Book {
        private int bookId;
        private String bookName;
        private String description;
        private String author;
        private int quantity;

        public Book() {
        }

        public int getBookId() {
            return bookId;
        }

        public void setBookId(int bookId) {
            this.bookId = bookId;
        }

        public String getBookName() {
            return bookName;
        }

        public void setBookName(String bookName) {
            this.bookName = bookName;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getAuthor() {
            return author;
        }

        public void setAuthor(String author) {
            this.author = author;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public String toJsonString() {
            return String.format("{\"BookId\":%d,\"BookName\":\"%s\",\"Description\":\"%s\",\"Author\":\"%s\",\"Quantity\":%d}",
                    bookId, bookName, description, author, quantity);
        }
    }
}
