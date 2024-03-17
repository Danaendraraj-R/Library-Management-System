<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
String email = (String) session.getAttribute("email");
String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");

 if ( role == null  ) {
    response.sendRedirect("AdminLogin.jsp");
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
.library h3 {
  margin-top: 10px;
  float:left;
  color: #f2f2f2;
  text-align: center;
  padding: 10px 10px;
  text-decoration: none;
  font-size: 17px;
}


.logout-btn {
  float: right;
  padding: 15px;
}
.logout-btn form {
  margin-top: -5px; 
  height: 2.5%;
}
.logout-btn:hover {
  background-color: #ddd;
  color: black;
}

.logout-btn input[type="submit"] {
  margin-top: 0px;  
  background-color:transparent;
  color: #fff;
  padding: 10px 10px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 17px;;
  height:2.5%;
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
  <div class="library">
    <h3>Admin Dashboard</h3> 
  </div> 
   
  <div class="topnav">
    <div class="logout-btn">
        <form action="Logout" method="post">
            <input type="submit" value="Logout">
        </form>
      </div>   
    <a href="DeleteBooks.jsp">Delete Books</a>
    <a href="AddBooks.jsp">Add Books</a>
    <a href="ViewUser.jsp">View Users</a>
    <a href="ViewBorrows.jsp">View Borrows</a>
  </div>
  </div>
  
  <div class="typewriter">
    <h1 id="text">"Borrow and return books based on your Interest"</h1>
</div>


</body>
</html>