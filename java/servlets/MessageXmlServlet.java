// src/main/java/servlets/MessageXmlServlet.java
package servlets;

import dao.MessageDAO;
import dao.UserDAO;
import models.Message;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/farmer/messages-xml")
public class MessageXmlServlet extends HttpServlet {
    private MessageDAO messageDAO = new MessageDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get logged-in farmer
        User farmer = (User) request.getSession().getAttribute("user");
        if (farmer == null || !"farmer".equals(farmer.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Fetch messages sent to this farmer
        List<Message> messages = messageDAO.getInboxWithSender(farmer.getId());

        // Set content type to XML
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Generate XML
        out.println("<?xml version='1.0' encoding='UTF-8'?>");
        out.println("<messages>");

        if (messages != null && !messages.isEmpty()) {
            for (Message msg : messages) {
                User sender = userDAO.getUserById(msg.getSenderId());
                String senderName = sender != null ? escapeXml(sender.getName()) : "Unknown";

                out.printf("  <message id='%d'>\n", msg.getId());
                out.printf("    <sender>%s</sender>\n", senderName);
                out.printf("    <content><![CDATA[%s]]></content>\n", escapeXml(msg.getMessage()));
                out.printf("    <time>%s</time>\n", msg.getSentAt());
                out.printf("    <read>%s</read>\n", msg.isRead() ? "true" : "false");
                out.println("  </message>");
            }
        }

        out.println("</messages>");
        out.close();
    }

    private String escapeXml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "<")
                .replace(">", ">")
                .replace("\"", "&quot;")
                .replace("'", "&apos;");
    }
}