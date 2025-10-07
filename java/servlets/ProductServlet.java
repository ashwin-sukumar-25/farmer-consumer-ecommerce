
package servlets;

import dao.ProductDAO;
import models.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/consumer/products")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;

   
   
    public ProductServlet() {
    	productDAO = new ProductDAO();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get all available products
        List<Product> products = productDAO.getAllProducts();

        // Set as request attribute
        request.setAttribute("products", products);

        // Forward to JSP
        request.getRequestDispatcher("/consumer/products.jsp")
                .forward(request, response);
    }
}