<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div%
String email = (String) session.getAttribute("email");
String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");

 if ( role == null  ) {
    response.sendRedirect("AdminLogin.jsp");
}

%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Books</title>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100vh;
        background-image: linear-gradient(to left, #8811d1, #fac1ef);
    }

    form {
        background-color: transparent;
        padding: 20px;
        border-radius: 20px;
        border: 1px solid black;
        box-shadow: 20px 20px 20px rgba(0, 0, 0, 0.1);
        margin-bottom: 20px;
        width: 300px;
    }

    h2 {
        text-align: center;
        color: whitesmoke;
    }

    label {
        display: block;
        margin: 10px 0 5px;
        color: whitesmoke;
    }

    input {
        width: calc(100% - 12px);
        padding: 8px;
        margin-bottom: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }
    textarea{
        width: calc(100% - 12px);
        padding: 8px;
        margin-bottom: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }

    input[type = 'submit'] {
        width: 100%;
        padding: 10px;
        background-color: #4caf50;
        color: #fff;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        margin-bottom: 10px;
    }

    input [type = submit ]:hover {
        background-color: #45a049;
    }
    button {
        width: 100%;
        padding: 10px;
        background-color: #4caf50;
        color: #fff;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        margin-bottom: 10px;
    }

    button:hover {
        background-color: #45a049;
    }

    a {
        color: black;
    }
    
    .popup {
    display: none; 
    position: fixed;
    top: 10%;
    left: 90%;
    width:250px;
    height:50px;
    transform: translate(-50%, -50%);
    padding: 20px;
    background-color: #208b1c;
    border: 1px solid #f5c6cb;
    border-radius: 5px;
    color: #dce8de;
}

.close {
    position: absolute;
    top: 10px;
    right: 10px;
    cursor: pointer;
}
#addBulkBook{
    display: none;
}
#addBulkBook #file{
    background-color:white;
}

</style>
</head>
<body>
    <div id="successPopup" class="popup">
        <span class="close" onclick="closePopup()">&times;</span>
        <p>Book Added successfully!</p>
    </div>

    <h2>Add Book</h2>
    <form id="addBookForm">
        <label for="BookName">Book Name:</label>
        <input type="text" id="BookName" name="BookName" required>


        <label for="Author">Author:</label>
        <input type="text" id="Author" name="Author" required>

        <label for="Quantity">Quantity:</label>
        <input type="number" id="Quantity" name="Quantity" required>

        
        <label for="Description">Description:</label>
        <textarea id="Description" rows="10" cols="30" name="Description" required></textarea> 

        <button type="button" onclick="AddBook()">Add Book</button>
        <button type="button" onclick="OpenBulk()">Add Bulk Data</button>
        <center>
            <a href="LibraryManagement.jsp">Back to Dashboard</a><br><br>
        </center>
    </form>
    <div id="addBulkBook">
        <h2>Upload CSV File</h2>
        <form action="ImportCsv" method="post" enctype="multipart/form-data">
        <label for="file">Choose CSV File:</label>
        <input type="file" id="file" name="file" accept=".csv" required>
        <br>
        <input type="submit" value="Upload">
        <button type="button" onclick="OpenSingle()">Add Books Individually</button>
       </form>       
        <center>
            <a href="LibraryManagement.jsp">Back to Dashboard</a><br><br>
        </center>
    </div>
    <script>
        function AddBook() {
            var bookName = document.getElementById("BookName").value;
            var description = document.getElementById("Description").value;
            var author = document.getElementById("Author").value;
            var quantity = document.getElementById("Quantity").value;

            $.ajax({
                type: "POST",
                url: "AddBook",
                data: { BookName: bookName, Description: description, Author: author, Quantity: quantity },
                success: function(response) {
                  showPopup();  
                },
                error: function(error) {
                    document.getElementById("result").innerHTML = "Error adding book";
                }
            });
        }
        function showPopup() {
            $("#successPopup").fadeIn();

            setTimeout(function() {
                 closePopup();
            }, 5000); 
}

function closePopup() {
    $("#successPopup").fadeOut();
}
function OpenBulk()
{
    $("#addBookForm").hide();
    $("#addBulkBook").show();
}
function OpenSingle()
{
    $("#addBookForm").show();
    $("#addBulkBook").hide();
}
    </script>

    <div id="result"></div>
</body>
</html>

    


