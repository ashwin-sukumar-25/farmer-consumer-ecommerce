<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Register - Farmer & Consumer Market</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .form-container {
            width: 400px;
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
        input[type="text"], input[type="email"], input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 16px;
        }
        .role-group {
            margin: 15px 0;
            text-align: left;
        }
        .role-group label {
            display: inline;
            margin-right: 15px;
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
            margin-top: 10px;
        }
        button:hover {
            background-color: #1b5e20;
        }
        .link {
            text-align: center;
            margin-top: 15px;
            color: #555;
        }
        .link a {
            color: #c62828;
            text-decoration: none;
        }
        .link a:hover {
            text-decoration: underline;
        }
        .error {
            color: red;
            font-size: 14px;
            margin-bottom: 10px;
            text-align: left;
        }
        .success {
            color: green;
            font-size: 14px;
            margin-bottom: 10px;
            text-align: left;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Create Account</h2>

    <%
        String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        if (error != null) {
    %>
        <div class="error"><%= error %></div>
    <%
        }
        if (success != null) {
    %>
        <div class="success"><%= success %></div>
    <%
        }
    %>

    <form action="auth" method="post">
        <input type="hidden" name="action" value="register">

        <label for="name">Full Name</label>
        <input type="text" id="name" name="name" required>

        <label for="email">Email</label>
        <input type="email" id="email" name="email" placeholder="" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" required>

        <label for="confirmPassword">Confirm Password</label>
        <input type="password" id="confirmPassword" name="confirmPassword" required>

        <div class="role-group">
            <label>
                <input id="farmerRadio" type="radio" name="role" value="farmer" required> Farmer
            </label>
            <label>
                <input type="radio" name="role" value="consumer" required> Consumer
            </label>
        </div>

        <button class="registerBtn" id="registerBtn" type="submit" href="Register">Register</button>
        <a href="google.com">Google</a>
    </form>

    <div class="link">
        Already have an account? <a href="login.jsp">Login here</a>
    </div>
    <div class="link">
        <a href="index.jsp">← Back to Home</a>
    </div>
</div>
</body>
</html>