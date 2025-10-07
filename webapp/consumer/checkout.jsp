
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"consumer".equals(user.getRole())) {
        response.sendRedirect("../login.jsp?error=Unauthorized access.");
        return;
    }
%>
<html>
<head>
    <title>Checkout</title>
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
        .success {
            text-align: center;
            color: green;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .btn {
            width: 100%;
            padding: 12px;
            background-color: #2e7d32;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }
        .btn:hover {
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
    <h2>Checkout</h2>

    <% 
        String msg = request.getParameter("msg");
        if ("success".equals(msg)) { 
    %>
        <div class="success">✅ Order placed successfully! Thank you for your purchase.</div>
    <% } %>

    <p>Your order will be processed and delivered soon.</p>
    <p><strong>Total Amount:</strong> $<%= request.getAttribute("totalAmount") != null ? 
        String.format("%.2f", request.getAttribute("totalAmount")) : "0.00" %></p>

    <form action="order-servlet" method="post">
        <input type="hidden" name="action" value="place">
        <button type="submit" class="btn">Place Order</button>
    </form>

    <a href="cart-servlet" class="back-link">← Back to Cart</a>
</div>
</body>
</html>