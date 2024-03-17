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

@WebServlet("/UserData")
public class UserData extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        List<Data> dataList = new ArrayList<>();

        try {
            Connection connection = DBConnection.getConnection();
            String sql = "SELECT * FROM users";
            try (PreparedStatement statement = connection.prepareStatement(sql);
                 ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {
                    String username = resultSet.getString("username");
                    String email = resultSet.getString("email");

                    Data data = new Data(username, email);
                    dataList.add(data);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
            return;
        }

        StringBuilder jsonBuilder = new StringBuilder("[");
        for (Data user : dataList) {
            jsonBuilder.append("{")
                    .append("\"name\":\"").append(user.getName()).append("\",")
                    .append("\"email\":\"").append(user.getEmail()).append("\"")
                    .append("},");
        }
        if (dataList.size() > 0) {
            jsonBuilder.deleteCharAt(jsonBuilder.length() - 1);
        }
        jsonBuilder.append("]");

        out.println(jsonBuilder.toString());
    }

    private static class Data {
        private String username;
        private String email;

        public Data(String username, String email) {
            this.username = username;
            this.email = email;
        }

        public String getName() {
            return username;
        }

        public String getEmail() {
            return email;
        }
    }
}
