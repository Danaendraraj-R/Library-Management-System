<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String email = (String) session.getAttribute("email");
    String username = (String) session.getAttribute("username");

    if (email == null || username == null) {
        response.sendRedirect("Login.jsp");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Borrowed Books</title>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #4caf50;
            text-align: left;
            padding: 8px;
        }

        th {
            background-color: #4caf50;
            color: #fff;
        }

        a, .borrow-btn {
            text-decoration: none;
            color: #fff;
            cursor: pointer;
            background-color: #4caf50;
            width: 120px;
            display: inline-block;
            text-align: center;
            padding: 8px;
        }

        .update-btn {
            background-color: #f3ef27; 
            border: 1px solid;
            color: black;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            cursor: pointer;
            border-radius: 4px;
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

    </style>
</head>
<body>
<div>
    <h2>Borrowed Books</h2>
</div>
<div id="successPopup" class="popup">
    <span class="close" onclick="closePopup()">&times;</span>
    <p>Book Returned successfully!</p>
</div>
<div id="dataContainer"></div>

<center><a href="LibraryManagement.jsp">Back</a></center>

<script type="text/javascript">
    function ReturnBook(BorrowId,BookId)
     {

confirm("Do you want to Return this Book?");
$.ajax({
    url: "ReturnBook",
    type: "POST",
    data:{BorrowId:BorrowId,BookId:BookId},
    success:function()
    {
    getData();
    showPopup();
    },
    error:function(error)
    {
        console.log("Error"+error);
    }
});
}
    $(document).ready(getData());
    function getData() {
        $.ajax({
            url: "BorrowedBooks",
            type: "GET",
            dataType: "json",
            success: function (data) {
                displayData(data);
            },
            error: function (error) {
                console.log("Error fetching data: " + error);
            }
        });

        function displayData(data) {
            var container = $("#dataContainer");
            container.empty();
            var num = 1;

            if (data.length === 0) {
                container.append("<p>No Books available</p>");
            } else {
                var table = "<table border='1'><tr><th>SNo</th><th>Book Name</th><th>Return</th></tr>";
                for (var i = 0; i < data.length; i++) {
                    table += "<tr><td>" + num + "</td><td>" + data[i].BookName + "</td><td>";
                        table += "<button class='borrow-btn' onclick='ReturnBook("+data[i].BorrowId+"," +data[i].BookId+")'>Return</button>";
                    
                    
                    num++;
                }
                table += "</table>";
                container.append(table);
            }
        }

        
        
        
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
</script>

</body>
</html>
