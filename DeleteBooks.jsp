<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String email = (String) session.getAttribute("email");
String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");

 if ( role == null  ) {
    response.sendRedirect("AdminLogin.jsp");
}

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Books</title> Books</title>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>  
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.2/css/jquery.dataTables.min.css">
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.2/js/jquery.dataTables.min.js"></script>
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
thead {
            background-color: #4caf50;
            color: #fff;
        }

    </style>
</head>
<body>
<div>
    <h2>Deleted Books</h2>
</div>

<div id="dataContainer"></div>
<div id="successPopup" class="popup">
    <span class="close" onclick="closePopup()">&times;</span>
    <p>Book Deleted successfully!</p>
</div>

<center><a href="AdminDashboard.jsp">Back</a></center>

<script type="text/javascript">
    function DeleteBook(BookId)
     {

confirm("Do you want to Delete this Book?");
$.ajax({
    url: "DeleteBook",
    type: "POST",
    data:{ bookId:BookId},
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
            url: "BookData",
            type: "GET",
            dataType: "json",
            success: function (data) {
                displayData(data);
                $('#tabledata').DataTable(); 
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
                var table = "<table border='1' id='tabledata'><thead><tr><th>SNo</th><th>Book Name</th><th>Delete</th></tr></thead><tbody>";
                for (var i = 0; i < data.length; i++) {
                    table += "<tr><td>" + num + "</td><td>" + data[i].BookName + "</td><td>";
                        table += "<button class='borrow-btn' onclick='DeleteBook(" +data[i].BookId+")'>Delete</button>";
                    
                    
                    num++;
                }
                table += "</tbody></table>";
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
