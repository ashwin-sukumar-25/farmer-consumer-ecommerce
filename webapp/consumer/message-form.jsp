
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"consumer".equals(user.getRole())) {
        response.sendRedirect("../login.jsp?error=Please login as consumer.");
        return;
    }

    // Get parameters (from product page link)
    String farmerIdStr = request.getParameter("farmerId");
    String productIdStr = request.getParameter("productId");
    String productName = request.getParameter("productName");

    if (farmerIdStr == null) {
        response.sendRedirect("products.jsp?error=No recipient specified.");
        return;
    }

    int farmerId = Integer.parseInt(farmerIdStr);
    Integer productId = null;
    if (productIdStr != null && !productIdStr.isEmpty()) {
        productId = Integer.parseInt(productIdStr);
    }
%>
<html>
<head>
    <title>Send Message to Farmer</title>
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
            margin: 15px 0 5px;
            color: #555;
        }
        input[type="text"], textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 16px;
        }
        textarea {
            height: 120px;
            resize: vertical;
        }
        .info {
            background-color: #e8f5e8;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 14px;
            color: #1b5e20;
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
        .back-link {
            display: block;
            text-align: center;
            margin: 15px 0;
            color: #2e7d32;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h2>💬 Send Message to Farmer</h2>

    <div class="info">
        You are sending a message to the farmer.
        <% if (productName != null) { %>
            Regarding: <strong><%= productName %></strong>
        <% } else { %>
            General inquiry.
        <% } %>
    </div>

    <form action="../message-servlet" method="post">
        <input type="hidden" name="action" value="send">
        <input type="hidden" name="receiverId" value="<%= farmerId %>">
        <% if (productId != null) { %>
            <input type="hidden" name="productId" value="<%= productId %>">
        <% } %>

        <label for="message">Your Message</label>
        <textarea id="message" name="message" placeholder="Ask about availability, delivery, price, etc." required></textarea>

        <button type="submit">Send Message</button>
    </form>

    <a href="products.jsp" class="back-link">← Back to Products</a>
</div>
</body>
</html>