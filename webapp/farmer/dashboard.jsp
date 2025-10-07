<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"farmer".equals(user.getRole())) {
        response.sendRedirect("../login.jsp?error=Please login as farmer.");
        return;
    }
%>
<html>
<head>
    <title>Farmer Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        .header {
            background-color: #2e7d32;
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h2 {
            margin: 0;
        }
        .container {
            max-width: 900px;
            margin: 30px auto;
            padding: 20px;
        }
        .card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            text-align: center;
        }
        .card h3 {
            color: #2e7d32;
        }
        .card a {
            display: inline-block;
            margin-top: 10px;
            padding: 10px 20px;
            background-color: #c62828;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }
        .card a:hover {
            background-color: #8b0000;
        }
        .logout {
            background-color: transparent;
            color: white;
            border: 1px solid white;
            padding: 8px 15px;
            text-decoration: none;
            border-radius: 6px;
        }
        .logout:hover {
            background-color: rgba(255,255,255,0.2);
        }
    </style>
</head>
<body>
<div class="header">
    <h2>🌾 Farmer Dashboard</h2>
    <div>
        Welcome, <strong><%= user.getName() %></strong> |
        <a href="../auth?action=logout" class="logout">Logout</a>
    </div>
</div>

<div class="container">
    <div class="card">
        <h3>Add New Product</h3>
        <p>Upload your fresh produce to the market</p>
        <a href="add-product.jsp">Go to Add Product</a>
    </div>

    <div class="card">
        <h3>View Orders</h3>
        <p>Check what consumers have ordered</p>
        <a href="../farmer/order-servlet">View Orders</a>
    </div>

    <div class="card">
        <h3>Messages</h3>
        <p>See messages from consumers</p>
        <a href="messages.jsp">Open Inbox</a>
    </div>
</div>
</body>
</html>