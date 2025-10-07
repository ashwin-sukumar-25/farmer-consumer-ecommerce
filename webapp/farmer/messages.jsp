<!-- farmer/messages.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"farmer".equals(user.getRole())) {
        response.sendRedirect("../login.jsp?error=Unauthorized access.");
        return;
    }
%>
<html>
<head>
    <title>Messages</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
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
            max-width: 900px;
            margin: 20px auto;
            padding: 20px;
        }
        .message-card {
            background: white;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            box-shadow: 0 1px 5px rgba(0,0,0,0.1);
        }
        .sender {
            font-weight: bold;
            color: #c62828;
        }
        .time {
            font-size: 12px;
            color: #777;
            float: right;
        }
        .content {
            margin: 8px 0;
            line-height: 1.4;
        }
        .status {
            font-size: 12px;
            color: green;
        }
        .empty {
            text-align: center;
            color: #777;
            font-style: italic;
            padding: 30px;
        }
        .refresh-btn {
            display: block;
            width: 120px;
            padding: 8px;
            background: #2e7d32;
            color: white;
            border: none;
            border-radius: 6px;
            margin: 10px 0;
            cursor: pointer;
        }
        .refresh-btn:hover {
            background: #1b5e20;
        }
    </style>
</head>
<body>

<div class="header">
    <h2>💬 Messages from Consumers</h2>
    <div>Welcome, <strong><%= user.getName() %></strong></div>
</div>

<div class="container">
    <button class="refresh-btn" onclick="loadMessages()">🔄 Refresh</button>

    <!-- Messages will be loaded here by AJAX -->
    <div id="messages-container">
        <p class="empty">Loading messages...</p>
    </div>
</div>

<script>
function loadMessages() {
    const container = document.getElementById("messages-container");
    container.innerHTML = "<p class='empty'>🔄 Loading messages...</p>";

    const xhr = new XMLHttpRequest();
    xhr.open("GET", "messages-xml", true);  // Calls MessageXmlServlet
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                parseMessages(xhr.response);
            } else {
                container.innerHTML = `
                    <p class="empty">
                        ❌ Failed to load messages.<br>
                        Status: ${xhr.status}
                    </p>
                    <p><a href="messages-xml" target="_blank">View raw XML</a></p>
                `;
            }
        }
    };
    xhr.send();
}

function parseMessages(xmlText) {
    const parser = new DOMParser();
    const xmlDoc = parser.parseFromString(xmlText, "text/xml");

    // Check for parsing error
    const parserError = xmlDoc.querySelector("parsererror");
    if (parserError) {
        document.getElementById("messages-container").innerHTML =
            "<p class='empty'>🚫 Invalid XML. Check console.</p>";
        console.error("XML Parse Error:", xmlText);
        return;
    }

    const messages = xmlDoc.querySelectorAll("message");
    const container = document.getElementById("messages-container");

    if (messages.length === 0) {
        container.innerHTML = "<p class='empty'>📭 No messages yet.</p>";
        return;
    }

    let html = '';
    messages.forEach(msg => {
        const id = msg.getAttribute("id");
        const sender = msg.querySelector("sender").textContent;
        const content = msg.querySelector("content").textContent;
        const time = msg.querySelector("time").textContent;
        const read = msg.querySelector("read").textContent === "true";

        html += '<div class="message-card">' +
        '  <div>' +
        '    <span class="sender">' + sender + '</span>' +
        '    <span class="time">' + new Date(time).toLocaleString() + '</span>' +
        '  </div>' +
        '  <div class="content">' + content + '</div>' +
        '  <div class="status">Status: ' + (read ? 'Read' : 'Unread') + '</div>' +
        '</div>';
    });

    container.innerHTML = html;
}

// Load messages when page opens
document.addEventListener("DOMContentLoaded", loadMessages);
</script>

<a href="dashboard.jsp" style="margin: 20px; display: inline-block;">← Back to Dashboard</a>

</body>
</html>