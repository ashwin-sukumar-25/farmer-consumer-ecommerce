
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User, java.util.List, models.Order" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"farmer".equals(user.getRole())) {
        response.sendRedirect("../login.jsp?error=Unauthorized access.");
        return;
    }

    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (orders == null) {
        orders = new java.util.ArrayList<>();
    }
%>
<html>
<head>
    <title>Your Orders</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
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
            max-width: 1000px;
            margin: 20px auto;
            padding: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border-radius: 10px;
            overflow: hidden;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #2e7d32;
            color: white;
        }
        tr:hover {
            background-color: #f1f8e9;
        }
        .status {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 14px;
        }
        .pending { background-color: #fff3e0; color: #e65100; }
        .confirmed { background-color: #e8f5e8; color: #2e7d32; }
        .shipped { background-color: #e3f2fd; color: #0d47a1; }
        .delivered { background-color: #f3e5f5; color: #6a1b9a; }
        .back-link {
            display: inline-block;
            margin: 15px 0;
            color: #2e7d32;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .empty {
            text-align: center;
            color: #777;
            font-style: italic;
            padding: 20px;
        }
    </style>
</head>
<body>
<div class="header">
    <h2>📦 Orders for Your Products</h2>
    <div>
        Welcome, <strong><%= user.getName() %></strong> |
        <a href="../auth?action=logout" style="color: white; text-decoration: none;">Logout</a>
    </div>
</div>

<div class="container">
    <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>

    <h3>All Orders</h3>

    <% if (orders.isEmpty()) { %>
        <p class="empty">No orders yet.</p>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Consumer</th>
                    <th>Product</th>
                    <th>Quantity</th>
                    <th>Total Price</th>
                    <th>Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% for (Order order : orders) { %>
                <tr>
                    <td><%= order.getId() %></td>
                    <td><%= request.getAttribute("consumerName_" + order.getId()) %></td>
                    <td><%= request.getAttribute("productName_" + order.getId()) %></td>
                    <td><%= order.getQuantity() %></td>
                    <td>$<%= String.format("%.2f", order.getTotalPrice()) %></td>
                    <td><%= order.getOrderDate() %></td>
                    <td>
                        <span class="status <%= order.getStatus() %>">
                            <%= order.getStatus().substring(0,1).toUpperCase() + order.getStatus().substring(1) %>
                        </span>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>
</body>
</html>