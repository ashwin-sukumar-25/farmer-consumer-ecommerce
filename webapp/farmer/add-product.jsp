
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"farmer".equals(user.getRole())) {
        response.sendRedirect("../login.jsp?error=Unauthorized access.");
        return;
    }

    String message = request.getParameter("msg");
%>
<html>
<head>
    <title>Add Product</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            padding-top: 50px;
        }
        .form-container {
            width: 500px;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #2e7d32;
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin: 10px 0 5px;
            color: #555;
            text-align: left;
        }
        input[type="text"], input[type="number"], textarea, input[type="url"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 16px;
        }
        textarea {
            height: 100px;
            resize: vertical;
        }
        button {
            width: 100%;
            padding: 12px;
            background-color: #2e7d32;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 20px;
        }
        button:hover {
            background-color: #1b5e20;
        }
        .message {
            color: green;
            text-align: center;
            margin-bottom: 15px;
        }
        .back-link {
            display: block;
            text-align: center;
            margin: 15px 0;
            color: #555;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Add New Product</h2>

    <% if (message != null) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <form action="add-product-servlet" method="post">
        <input type="hidden" name="farmerId" value="<%= user.getId() %>">

        <label for="name">Product Name</label>
        <input type="text" id="name" name="name" required>

        <label for="description">Description</label>
        <textarea id="description" name="description" required></textarea>

        <label for="price">Price ($)</label>
        <input type="number" id="price" name="price" step="0.01" min="0" required>

        <label for="quantity">Available Quantity</label>
        <input type="number" id="quantity" name="quantity" min="1" required>

        <label for="imageUrl">Image URL</label>
        <input type="url" id="imageUrl" name="imageUrl" placeholder="https://example.com/image.jpg">

        <button type="submit">Add Product</button>
    </form>

    <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
</div>
</body>
</html>