<!-- webapp/consumer/home.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"consumer".equals(user.getRole())) {
        response.sendRedirect("../login.jsp?error=Please login as consumer.");
        return;
    }
%>
<html>
<head>
    <title>Welcome, Consumer</title>
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
    <h2>🛍️ Welcome, Consumer</h2>
    <div>
        Hello, <strong><%= user.getName() %></strong> |
        <a href="../auth?action=logout" class="logout">Logout</a>
    </div>
</div>

<div class="container">
    <div class="card">
        <h3>Browse Products</h3>
        <p>Find fresh produce directly from local farmers</p>
        <a href="products">View Products</a>
    </div>

    <div class="card">
        <h3>Your Cart</h3>
        <p>Review and manage your selected items</p>
        <a href="cart-servlet">Go to Cart</a>
    </div>
</div>
</body>
</html>