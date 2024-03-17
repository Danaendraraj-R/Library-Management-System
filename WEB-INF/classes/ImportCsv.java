package com.library;

import DatabaseConnection.DBConnection;
import java.io.*;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
 
@WebServlet("/ImportCsv")
@MultipartConfig
public class ImportCsv extends HttpServlet  {
 
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Connection connection = DBConnection.getConnection();
            System.out.println("Connection successful");
 
            int batchSize = 100;
 
            String sql = "INSERT INTO books (bookname, description, quantity, author) VALUES (?, ?, ?, ?)";
            
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                Part filePart = request.getPart("file");

                BufferedReader lineReader = new BufferedReader(new InputStreamReader(filePart.getInputStream()));
                
                int count = 0;
                lineReader.readLine();

                String lineText;
                while ((lineText = lineReader.readLine()) != null) {
                    String[] data = lineText.split(",");
                    String bookname = data[0];
                    String description = data[1];
                    int quantity = Integer.parseInt(data[2]);
                    String author = data[3];
 
                    statement.setString(1, bookname);
                    statement.setString(2, description);
                    statement.setInt(3, quantity);
                    statement.setString(4, author);
                    count++;
 
                    statement.addBatch();
 
                    if (count % batchSize == 0) {
                        statement.executeBatch();
                    }
                }
 
                statement.executeBatch();
            }

            DBConnection.closeConnection(connection);
            response.sendRedirect("AddBooks.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
