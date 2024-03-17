package com.library;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import DatabaseConnection.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/BorrowDB")
public class BorrowDB extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        List<BorrowData> borrowList = new ArrayList<>();

        try {
            Connection connection = DBConnection.getConnection();
            String sql = "SELECT borrowid, borrower, bookname, bookid FROM borrows WHERE return='false'";
            try (PreparedStatement statement = connection.prepareStatement(sql);
                 ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {
                    int borrowId = resultSet.getInt("borrowid");
                    String borrower = resultSet.getString("borrower");
                    String bookName = resultSet.getString("bookname");
                    int bookId = resultSet.getInt("bookid");

                    BorrowData borrowData = new BorrowData(borrowId, borrower, bookName, bookId);
                    borrowList.add(borrowData);
                }
            }
        } catch (SQLException e) {
            log("Error in BorrowData servlet: " + e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
            return;
        }

        StringBuilder jsonBuilder = new StringBuilder("[");
        for (int i = 0; i < borrowList.size(); i++) {
            BorrowData borrowData = borrowList.get(i);
            jsonBuilder.append("{")
                    .append("\"borrowId\":").append(borrowData.getBorrowId()).append(",")
                    .append("\"borrower\":\"").append(borrowData.getBorrower()).append("\",")
                    .append("\"bookName\":\"").append(borrowData.getBookName()).append("\",")
                    .append("\"bookId\":").append(borrowData.getBookId())
                    .append("}");

            if (i < borrowList.size() - 1) {
                jsonBuilder.append(",");
            }
        }
        jsonBuilder.append("]");

        out.println(jsonBuilder.toString());
    }

    class BorrowData {
        private int borrowId;
        private String borrower;
        private String bookName;
        private int bookId;

        public BorrowData(int borrowId, String borrower, String bookName, int bookId) {
            this.borrowId = borrowId;
            this.borrower = borrower;
            this.bookName = bookName;
            this.bookId = bookId;
        }

        public int getBorrowId() {
            return borrowId;
        }

        public String getBorrower() {
            return borrower;
        }

        public String getBookName() {
            return bookName;
        }

        public int getBookId() {
            return bookId;
        }
    }
}
