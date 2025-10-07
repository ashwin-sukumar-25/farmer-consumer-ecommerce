<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Farmer & Consumer Market</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #e0f7fa, #f3e5f5);
            margin: 0;
            padding: 0;
            color: #333;
            text-align: center;
        }
        .container {
            max-width: 900px;
            margin: 60px auto;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2e7d32;
            margin-bottom: 10px;
        }
        p.subtitle {
            color: #555;
            font-size: 18px;
            margin-bottom: 30px;
        }
        .btn-group {
            margin: 30px 0;
        }
        .btn {
            display: inline-block;
            padding: 12px 30px;
            margin: 0 15px;
            font-size: 16px;
            color: white;
            background-color: #2e7d32;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            transition: background 0.3s;
        }
        .btn:hover {
            background-color: #1b5e20;
        }
        .btn-secondary {
            background-color: #c62828;
        }
        .btn-secondary:hover {
            background-color: #8b0000;
        }
        .message {
            color: green;
            font-weight: bold;
        }
        .error {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>🌾 Farmer & Consumer Direct Market</h1>
    <p class="subtitle">Connect farmers with consumers. Fresh produce, fair prices.</p>

    <% 
        String message = request.getParameter("message");
        if (message != null) {
    %>
        <p class="message"><%= message %></p>
    <%
        }
    %>

    <div class="btn-group">
        <a href="login.jsp" class="btn">Login</a>
        <a href="register.jsp" class="btn btn-secondary">Register</a>
    </div>

    <footer style="margin-top: 50px; color: #777; font-size: 14px;">
        &copy; <%= java.time.Year.now() %> FarmerConsumer Market. All rights reserved.
    </footer>
</div>
</body>
</html>