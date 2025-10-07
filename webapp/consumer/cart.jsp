
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User, java.util.List, models.Cart" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"consumer".equals(user.getRole())) {
        response.sendRedirect("../login.jsp?error=Unauthorized access.");
        return;
    }

    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    Double totalAmount = (Double) request.getAttribute("totalAmount");
    if (cartItems == null) cartItems = new java.util.ArrayList<>();
    if (totalAmount == null) totalAmount = 0.0;
%>
<html>
<head>
    <title>Your Shopping Cart</title>
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
            padding: 15px;
            text-align: left;
        }
        th {
            background-color: #2e7d32;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .product-col {
            display: flex;
            align-items: center;
        }
        .product-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            margin-right: 15px;
            border-radius: 6px;
        }
        .qty-input {
            width: 50px;
            padding: 5px;
            text-align: center;
        }
        .action-link {
            color: #c62828;
            text-decoration: none;
            font-weight: bold;
        }
        .action-link:hover {
            text-decoration: underline;
        }
        .summary {
            text-align: right;
            font-size: 18px;
            margin: 20px 0;
        }
        .btn-checkout {
            display: inline-block;
            padding: 12px 30px;
            background-color: #c62828;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 16px;
        }
        .btn-checkout:hover {
            background-color: #8b0000;
        }
        .empty {
            text-align: center;
            color: #777;
            font-style: italic;
            padding: 40px;
        }
        .back-link {
            display: block;
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
<div class="header">
    <h2>🛒 Your Cart</h2>
    <div>
        Hello, <strong><%= user.getName() %></strong> |
        <a href="../auth?action=logout" style="color: white; text-decoration: none;">Logout</a>
    </div>
</div>

<a href="home.jsp" class="back-link">← Continue Shopping</a>

<div class="container">
    <h3>Cart Items</h3>

    <% if (cartItems.isEmpty()) { %>
        <p class="empty">Your cart is empty.</p>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% for (Cart item : cartItems) { 
                    String productName = (String) request.getAttribute("productName_" + item.getProductId());
                    String productImage = (String) request.getAttribute("productImage_" + item.getProductId());
                    Double price = (Double) request.getAttribute("price_" + item.getProductId());
                    Double total = price * item.getQuantity();
                %>
                <tr>
                    <td class="product-col">
                        <img src="<%= productImage != null ? productImage : "https://via.placeholder.com/60x60" %>" 
                             alt="<%= productName %>" class="product-img">
                        <%= productName %>
                    </td>
                    <td>$<%= String.format("%.2f", price) %></td>
                    <td>
                        <form action="cart-servlet" method="get" style="display: flex; align-items: center;">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="cartId" value="<%= item.getId() %>">
                            <input type="number" name="quantity" class="qty-input" 
                                   value="<%= item.getQuantity() %>" min="1" onchange="this.form.submit()">
                        </form>
                    </td>
                    <td>$<%= String.format("%.2f", total) %></td>
                    <td>
                        <a href="cart-servlet?action=remove&cartId=<%= item.getId() %>" 
                           class="action-link" onclick="return confirm('Remove this item?')">Remove</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <div class="summary">
            <strong>Total: $<%= String.format("%.2f", totalAmount) %></strong><br><br>
            <a href="order-servlet?action=showCheckout" class="btn-checkout">Proceed to Checkout</a>
        </div>
    <% } %>
</div>
</body>
</html>