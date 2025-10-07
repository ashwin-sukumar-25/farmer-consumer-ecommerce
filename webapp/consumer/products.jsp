<!-- webapp/consumer/products.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User, java.util.List, models.Product" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"consumer".equals(user.getRole())) {
        response.sendRedirect("../login.jsp?error=Unauthorized access.");
        return;
    }

    List<Product> products = (List<Product>) request.getAttribute("products");
    if (products == null) {
        products = new java.util.ArrayList<>();
    }
%>
<html>
<head>
    <title>Products Marketplace</title>
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
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }
        .product-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        .product-card:hover {
            transform: translateY(-5px);
        }
        .product-img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }
        .product-info {
            padding: 15px;
        }
        .product-name {
            font-size: 18px;
            font-weight: bold;
            color: #2e7d32;
            margin: 0 0 8px;
        }
        .product-desc {
            font-size: 14px;
            color: #555;
            margin: 0 0 10px;
        }
        .product-price {
            font-size: 18px;
            color: #c62828;
            font-weight: bold;
        }
        .add-to-cart {
            display: block;
            width: 100%;
            padding: 10px;
            background-color: #2e7d32;
            color: white;
            border: none;
            border-radius: 6px;
            margin-top: 10px;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
        }
        .add-to-cart:hover {
            background-color: #1b5e20;
        }
        .back-link {
            display: block;
            margin: 15px 20px;
            color: #2e7d32;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .empty {
            grid-column: 1 / -1;
            text-align: center;
            color: #777;
            font-style: italic;
            padding: 40px;
        }
    </style>
</head>
<body>
<div class="header">
    <h2>🌾 All Products</h2>
    <div>
        Welcome, <strong><%= user.getName() %></strong> |
        <a href="cart.jsp" style="color: white; text-decoration: none;">🛒 View Cart</a>
    </div>
</div>

<a href="home.jsp" class="back-link">← Back to Home</a>

<div class="container">
    <% if (products.isEmpty()) { %>
        <p class="empty">No products available at the moment.</p>
    <% } else { %>
        <% for (Product product : products) { %>
        <div class="product-card">
            <img src="<%= product.getImageUrl() != null ? product.getImageUrl() : "https://via.placeholder.com/250x180?text=No+Image" %>" 
                 alt="<%= product.getName() %>" class="product-img">
            <div class="product-info">
                <h3 class="product-name"><%= product.getName() %></h3>
                <p class="product-desc"><%= product.getDescription() %></p>
                <p class="product-price">$<%= String.format("%.2f", product.getPrice()) %></p>
                <a href="cart-servlet?action=add&productId=<%= product.getId() %>&quantity=1" 
                   class="add-to-cart">Add to Cart</a>
                   <a href="message-form.jsp?farmerId=<%= product.getFarmerId() %>&productId=<%= product.getId() %>" class="add-to-cart">
    💬 Ask about this product
</a>
            </div>
        </div>
        <% } %>
    <% } %>
</div>
</body>
</html>