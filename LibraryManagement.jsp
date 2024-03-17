<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
String email = (String) session.getAttribute("email");
String username = (String) session.getAttribute("username");

if (email == null || username == null) {
    response.sendRedirect("Login.jsp");
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Library Management</title>
  <style>
body {
  margin: 0;
  font-family: 'Arial', sans-serif;
  background-image: url("https://thumbs.dreamstime.com/b/lod-israel-july-money-manager-expense-budget-app-play-store-page-smartphone-ceramic-stone-background-jpg-top-view-flat-lay-284679994.jpg");
  background-size: cover;
}


.topnav a {
  margin-top: 10px;
  float: right;
  color: #f2f2f2;
  text-align: center;
  padding: 10px 10px;
  text-decoration: none;
  font-size: 17px;
}

.topnav a:hover {
  background-color: #ddd;
  color: black;
}

ul
{
  list-style-type: none;
}

.typewriter {
      overflow: hidden;
      white-space: nowrap;
      font-size: 24px;
      text-align: center;
      color:white;
      margin-top: 2%;
    }
    .navbar
    {
      justify-content: space-between;
      display:flex;
      background-color: rgb(32, 23, 19);
      height: 65px;
      overflow: hidden;
      width:100%
    }
.library a {
  margin-top: 10px;
  float:left;
  color: #f2f2f2;
  text-align: center;
  padding: 10px 10px;
  text-decoration: none;
  font-size: 17px;
}

.library a:hover {
  background-color: #ddd;
  color: black;
}
  </style>
  <script>
        document.addEventListener("DOMContentLoaded", function() {
      var textElement = document.getElementById("text");
      var text = textElement.innerHTML;
      textElement.innerHTML = ""; 
  
      var i = 0;
      var speed = 50; 
  
      function typeWriter() {
        if (i < text.length) {
          textElement.innerHTML += text.charAt(i);
          i++;
          setTimeout(typeWriter, speed);
        }
      }
  
      typeWriter(); 
    });
  </script>


 </head>
<body>


<div class="navbar">
   
  <div class="topnav">
    <a href="AvailableBooks.jsp">Available Books</a>   
    <a href="BorrowedBooks.jsp">Borrowed Books</a>
  </div>
  </div>
  
  <div class="typewriter">
    <h1 id="text">"Borrow and return books based on your Interest"</h1>
</div>


</body>
</html>