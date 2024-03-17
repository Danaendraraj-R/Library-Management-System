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
    <title>View Books</title>
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

        thead {
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
        <h2>View Books</h2>
    </div>
   

    <div id="dataContainer"></div>
    
    <div id="successPopup" class="popup">
        <span class="close" onclick="closePopup('#successPopup')">&times;</span>
        <p>Book Borrowed successfully!</p>
    </div>
    <div id="ErrorPopup" class="popup">
        <span class="close" onclick="closePopup('ErrorPopup')">&times;</span>
        <p>Book Already Borrowed!</p>
    </div>

    <center><a href="LibraryManagement.jsp">Back</a></center>

    <script type="text/javascript">
        function checkBook(bookId) {
            $.ajax({
            url: "BorrowedBooks",
            type: "GET",
            dataType: "json",
            success: function (data) {
                var filterBooks = data.filter(function (data) {             
                    return data.BookId == bookId;
                });
                if(filterBooks.length === 0)
                {
                    BorrowBook(bookId);
                }
                else
                {
                    showErrorPopup();
                }

            },
            error: function (error) {
                console.log("Error fetching data: " + error);
            }
        });
        }

        function BorrowBook(bookId) {
            if (confirm("Do you want to Borrow this Book?")) {
            $.ajax({
                url: "BorrowBook",
                type: "POST",
                data: { BookId: bookId },
                success: function () {
                    showPopup();
                    getData();
                    
                },
                error: function (error) {
                    console.log("Error" + error);
                }
            });
        }
        }

        function getData() {
            $.ajax({
                url: "BookData",
                type: "GET",
                dataType: "text",
                success: function (data) {
                    try {
                        var jsonData = JSON.parse(data.trim());
                        displayData(jsonData);
                        $('#tabledata').DataTable(); 
                    } catch (e) {
                        console.log("Error parsing JSON: " + e);
                    }
                },
                error: function (xhr, status, error) {
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
                    var table = "<table border='1' id='tabledata'><thead><tr><th>SNo</th><th>Book Name</th><th>Description</th><th>Author</th><th>Quantity</th><th>Borrow</th></tr></thead><tbody>";
                    for (var i = 0; i < data.length; i++) {
                        table += "<tr><td>" + num + "</td><td>" + data[i].BookName + "</td><td>" + data[i].Description + "</td><td>" + data[i].Author + "</td><td>" + data[i].Quantity + "</td><td>";
                        table += "<button class='borrow-btn' onclick='checkBook(" + data[i].BookId + ")'>Borrow</button>";
                        table += "</td></tr>";
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

        function showErrorPopup() {
            $("#ErrorPopup").fadeIn();

            setTimeout(function() {
                 closePopup();
            }, 5000); 
        }

        function closePopup() {
            $(".popup").fadeOut();
        }

        $(document).ready(function () {
            getData();
        });
    </script>
</body>
</html>
