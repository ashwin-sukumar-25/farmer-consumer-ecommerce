
package servlets;

import dao.*;
import models.*;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/message-servlet")
public class MessageServlet extends HttpServlet {
    private MessageDAO messageDAO;
    private ProductDAO productDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        messageDAO = new MessageDAO();
        productDAO = new ProductDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("../login.jsp?error=Please login first.");
            return;
        }

        User sender = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("send".equals(action)) {
            sendMessage(request, response, sender);
        } else {
            response.sendRedirect("../index.jsp?error=Invalid action.");
        }
    }

 // Inside MessageServlet.java
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("../login.jsp?error=Please login first.");
            return;
        }

        User receiver = (User) session.getAttribute("user");
        if (!"farmer".equals(receiver.getRole())) {
            response.sendRedirect("../consumer/home.jsp?error=Access denied.");
            return;
        }

        // ✅ Load all messages for this farmer
        List<Message> messages = messageDAO.getInboxWithSender(receiver.getId());

        // ✅ Set sender name and product name for each message
        for (Message msg : messages) {
            User sender = userDAO.getUserById(msg.getSenderId());
            if (sender != null) {
                request.setAttribute("senderName_" + msg.getId(), sender.getName());
            }

            if (msg.getProductId() != null) {
                Product product = productDAO.getProductById(msg.getProductId());
                if (product != null) {
                    request.setAttribute("productName_" + msg.getProductId(), product.getName());
                }
            }
        }

        // ✅ Mark messages as read
        for (Message msg : messages) {
            messageDAO.markAsRead(msg.getSenderId(), receiver.getId());
        }

        // ✅ Forward to JSP with data
        request.setAttribute("messages", messages);
        request.getRequestDispatcher("../farmer/messages.jsp").forward(request, response);
    }

    private void sendMessage(HttpServletRequest request, HttpServletResponse response, User sender)
            throws IOException, ServletException {
        String receiverIdStr = request.getParameter("receiverId");
        String productIdStr = request.getParameter("productId");
        String messageText = request.getParameter("message");

        if (receiverIdStr == null || messageText == null || messageText.trim().isEmpty()) {
            response.sendRedirect("../farmer/products.jsp?error=Message cannot be empty.");
            return;
        }

        try {
            int receiverId = Integer.parseInt(receiverIdStr);
            Integer productId = null;
            if (productIdStr != null && !productIdStr.isEmpty()) {
                productId = Integer.parseInt(productIdStr);
            }

            // Optional: Validate receiver is a farmer
            User receiver = userDAO.getUserById(receiverId);
            if (receiver == null || !"farmer".equals(receiver.getRole())) {
                response.sendRedirect("/farmer/products.jsp?error=Invalid recipient.");
                return;
            }

            if (productId != null) {
                Product product = productDAO.getProductById(productId);
                if (product == null || product.getFarmerId() != receiverId) {
                    response.sendRedirect("/farmer/products.jsp?error=Invalid product or farmer.");
                    return;
                }
            }

            boolean success = messageDAO.sendMessage(
                sender.getId(),
                receiverId,
                productId,
                messageText.trim()
            );

            if (success) {
                response.sendRedirect("/farmer/products.jsp?msg=Message sent to farmer!");
            } else {
                response.sendRedirect("/farmer/products.jsp?error=Failed to send message.");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("/farmer/products.jsp?error=Invalid input.");
        }
    }
}