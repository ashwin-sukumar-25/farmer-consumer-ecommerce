
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Error</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        .error { color: #c62828; font-size: 18px; }
        a { color: #2e7d32; text-decoration: none; }
    </style>
</head>
<body>
    <h1>⚠️ Oops! Something went wrong.</h1>
    <p class="error">
        <% 
            Exception ex = (Exception) request.getAttribute("javax.servlet.error.exception");
            if (ex != null) {
                out.println("Error: " + ex.getMessage());
            } else {
                out.println("Page not found or server error.");
            }
        %>
    </p>
    <p><a href="index.jsp">← Go to Home</a></p>
</body>
</html>