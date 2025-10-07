
package servlets;

import dao.ProductDAO;
import models.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/farmer/add-product-servlet")
public class AddProductServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("../login.jsp?error=Please login first.");
            return;
        }

        models.User user = (models.User) session.getAttribute("user");
        if (!"farmer".equals(user.getRole())) {
            response.sendRedirect("../login.jsp?error=Access denied.");
            return;
        }

        // Get form parameters
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String imageUrl = request.getParameter("imageUrl");

        // Validate input
        if (name == null || name.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            priceStr == null || quantityStr == null) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/farmer-consumer-ecommerce/farmer/add-product.jsp").forward(request, response);
            return;
        }

        double price;
        int quantity;
        try {
            price = Double.parseDouble(priceStr);
            quantity = Integer.parseInt(quantityStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid price or quantity.");
            request.getRequestDispatcher("/farmer-consumer-ecommerce/farmer/add-product.jsp").forward(request, response);
            return;
        }

        if (price <= 0 || quantity <= 0) {
            request.setAttribute("error", "Price and quantity must be greater than zero.");
            request.getRequestDispatcher("/farmer-consumer-ecommerce/farmer/add-product.jsp").forward(request, response);
            return;
        }

        // Create Product object
        Product product = new Product();
        product.setName(name);
        product.setDescription(description);
        product.setPrice(price);
        product.setQuantity(quantity);
        product.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
        product.setFarmerId(user.getId());

        // Save to database
        if (productDAO.addProduct(product)) {
            response.sendRedirect("/farmer-consumer-ecommerce/farmer/add-product.jsp?msg=Product added successfully!");
        } else {
            request.setAttribute("error", "Failed to add product. Please try again.");
            request.getRequestDispatcher("/farmer-consumer-ecommerce/farmer/add-product.jsp").forward(request, response);
        }
    }
}