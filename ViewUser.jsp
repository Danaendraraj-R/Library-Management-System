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
    <title>View Users</title>
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
.search-container button {
        margin-left: 10px;
        background-color: #208b1c;
        color:#f9f9f9;
    }
.popup {
    display: none;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background-color: #fff;
    border: 1px solid #ccc;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    padding: 20px;
    max-width: 400px;
    max-height: 300px;
    overflow-y: scroll;
    width: 100%;
    z-index: 1000;
    color:black;
}

.close {
    position: absolute;
    top: 10px;
    right: 10px;
    cursor: pointer;
    font-size: 18px;
    color: #555;
}

.close:hover {
    color: #000;
}
.overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    max-height: 300px;
    overflow-y: scroll;
    background-color: rgba(0, 0, 0, 0.3);
    z-index: 999;
}

.center-popup {
    align-items: center;
    max-height: 300px;
    overflow-y: scroll;
    justify-content: center;
}
.fn{
    cursor: pointer;
}
        .heading{
            display:flex;
            justify-content: space-between;
        }
        .export-btn
        {
            background-color: #04AA6D; /* Green */
            border: none;
            color: white;
            padding: 20px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
            border-radius: 12px;
        }
        .export-container
        {
            float:right;
        }



    </style>
</head>
<body>
<div>
    <h2>View Users</h2>
</div>
<div class="heading">
<div class="search-container">
    <input type="text" id="searchInput" placeholder="Search users...">
    <button onclick="searchUsers()">Search</button>
</div>
<div class="export-container"> 
    <button class="export-btn" onclick="exportData('PDF')">Export to PDF</button>
    <button class="export-btn" onclick="exportData('CSV')">Export to CSV</button>
    <button class="export-btn" onclick="exportData('HTML')">Export to Html</button>
</div>
</div>

<div class="overlay"></div>

<div id="dataContainer"></div>

<center><a href="AdminDashboard.jsp">Back</a></center>

<script type="text/javascript">

    var Data;
    var BookData;
    $(document).ready(
        $.ajax({
            url: "BorrowDB",
            type: "GET",
            dataType: "json",
            success: function (data) {
                BookData = data;
            },
            error: function (xhr, status, error) {
                console.log("Error fetching BorrowDB data: " + error);
            }
        }),
        getData());
    function getData() {
        $.ajax({
            url: "UserData",
            type: "GET",
            dataType: "json",
            success: function (data) {
                displayData(data);
                Data=data;
            },
            error: function (xhr, status, error) {
            console.log("Error fetching data: " + error);
        }
        });       
    }
    function displayData(data) {
            var container = $("#dataContainer");
            container.empty();
            var num = 1;

            if (data.length === 0) {
                container.append("<p>No Users available</p>");
            } else {
                var table = "<table border='1'><tr><th>SNo</th><th>Name</th><th>Email</th></tr>";
                for (var i = 0; i < data.length; i++) {
                    table += "<tr><td>" + num + "</td><td class='fn' onclick=showUserBorrows('" + data[i].email+"')>" + data[i].name + "</td><td>" + data[i].email + "</td></tr>";  
                    num++;
                }
                table += "</table>";
                container.append(table);
            }
        }
    function searchUsers() {
            var searchTerm = $("#searchInput").val().toLowerCase();

            var filtereduser = Data.filter(function (Data) {
                return (
                    Data.name.toLowerCase().includes(searchTerm) ||
                    Data.email.toLowerCase().includes(searchTerm) 
                );
            });

            displayData(filtereduser);
        }
        function getUser(email) {
    for (var i = 0; i < Data.length; i++) {
        if (Data[i].email === email) {
            return Data[i].name;
        }
    }
    return ''; 
    }
        function showUserBorrows(userid)
{
    var borrowInfoArray = BookData.filter(function(borrow) {
        return borrow.borrower === userid;
    });

    if (borrowInfoArray.length > 0) {
        var popupContent = "<h3>Borrow Information for user: " + getUser(userid) + "</h3>";
        
        borrowInfoArray.forEach(function(borrowInfo) {
            popupContent +=  "<p><strong>Book Namer:</strong> " + borrowInfo.bookName + "</p>" +
                             "<hr>";
        });

        var popup = $("<div class='popup center-popup'>" +
                        "<span class='close' onclick='closePopup()'>&times;</span>" +
                        popupContent +
                      "</div>");

        var overlay = $("<div class='overlay'></div>");
        $("body").append(overlay, popup);

        popup.show();
        overlay.show();
    } else {
        alert("No Borrow information this user: " + getUser(userid));
    }
}


function closePopup() {
    $(".popup").hide();
    $(".overlay").hide();
}
function exportData(Type)
{
            if(Type === "PDF")
            {
               exportToPdf(Data);
            }
            else if(Type === "CSV")
            {
                exportToCSV(Data);
            }
            else if(Type === 'HTML')
            {
                exportToHtml(Data);
            }
                
}
    
    function exportToPdf(data) {
    var form = document.createElement('form');
    form.style.display = 'none'; 
    form.method = 'POST';
    form.action = 'PdfExport';
    var input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'data';
    input.value = JSON.stringify(data);
    form.appendChild(input);
    document.body.appendChild(form);
    form.submit();
    document.body.removeChild(form);
}
function exportToCSV(data) {
    var form = document.createElement('form');
    form.style.display = 'none'; 
    form.method = 'POST';
    form.action = 'CsvExport';
    var input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'data';
    input.value = JSON.stringify(data);
    form.appendChild(input);
    document.body.appendChild(form);
    form.submit();
    document.body.removeChild(form);
}
function exportToHtml(data) {
    var form = document.createElement('form');
    form.style.display = 'none'; 
    form.method = 'POST';
    form.action = 'HtmlExport';
    var input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'data';
    input.value = JSON.stringify(data);
    form.appendChild(input);
    document.body.appendChild(form);
    form.submit();
    document.body.removeChild(form);
}

</script>

</body>
</html>
