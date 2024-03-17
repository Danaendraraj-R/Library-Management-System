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
import jakarta.servlet.http.HttpSession;

@WebServlet("/BorrowedBooks")
public class BorrowedBooks extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {

            Connection connection = DBConnection.getConnection();

            String query = "SELECT * FROM borrows WHERE borrower=? AND return=false";

            try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {

               HttpSession httpSession = request.getSession(true);
               String email=(String)httpSession.getAttribute("email");

               preparedStatement.setString(1, email);

               ResultSet resultSet = preparedStatement.executeQuery();

               List<Book> books = new ArrayList<>();

               while (resultSet.next()) {
                   Book book = new Book();
                   book.setBorrowId(resultSet.getInt("borrowid"));
                   book.setBookId(resultSet.getInt("bookid"));
                   book.setBookName(resultSet.getString("bookname"));
                   book.setBorrower(resultSet.getString("borrower"));
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
                   out.print(jsonBuilder.toString());
                   out.flush();
               }
           }
           DBConnection.closeConnection(connection);
       } catch (Exception e) {
           e.printStackTrace();
       }
   }

   private static class Book {
       private int borrowId;
       private int bookId;
       private String bookName;
       private String borrower;

       public Book() {
       }

       public int getBorrowId() {
           return borrowId;
       }

       public void setBorrowId(int borrowId) {
           this.borrowId = borrowId;
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

       public String getBorrower() {
           return borrower;
       }

       public void setBorrower(String borrower) {
           this.borrower = borrower;
       }

       public String toJsonString() {
           return String.format("{\"BorrowId\":%d,\"BookId\":%d,\"BookName\":\"%s\",\"Borrower\":\"%s\"}",
                   borrowId, bookId, bookName, borrower);
       }
   }
}
