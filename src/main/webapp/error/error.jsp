<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%
    Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
    String errorMsg    = (String)  request.getAttribute("javax.servlet.error.message");

    String code    = statusCode != null ? statusCode.toString() : "Error";
    String heading = "Something went wrong";
    String sub     = "An unexpected error occurred. Please try again.";

    if ("404".equals(code)) {
        heading = "Page Not Found";
        sub     = "The page you're looking for doesn't exist or has been moved.";
    } else if ("500".equals(code)) {
        heading = "Server Error";
        sub     = "Something went wrong on our end. Please try again.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error <%= code %> - EMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body {
            background: #f0f2f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', sans-serif;
        }
        .error-card {
            background: white;
            border-radius: 16px;
            padding: 52px 44px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            max-width: 440px;
            width: 100%;
        }
        .error-code {
            font-size: 5rem;
            font-weight: 800;
            color: #1a2035;
            line-height: 1;
            margin-bottom: 6px;
        }
        .error-icon {
            font-size: 2.8rem;
            margin-bottom: 16px;
            display: block;
        }
    </style>
</head>
<body>

<div class="error-card">
    <span class="error-icon">
        <% if ("404".equals(code)) { %>
            <i class="bi bi-compass" style="color:#f39c12;"></i>
        <% } else { %>
            <i class="bi bi-exclamation-triangle" style="color:#e74c3c;"></i>
        <% } %>
    </span>

    <div class="error-code"><%= code %></div>

    <h5 class="fw-bold mt-3 mb-2" style="color:#1a2035;"><%= heading %></h5>
    <p style="color:#6c757d; font-size:0.9rem; margin-bottom:28px;"><%= sub %></p>

    <a href="<%= request.getContextPath() %>/login.jsp"
       style="background:linear-gradient(135deg,#1a2035,#2d4a8a); color:white; border:none;
              border-radius:8px; padding:10px 28px; font-weight:600; font-size:0.9rem;
              text-decoration:none; display:inline-block;">
        <i class="bi bi-house me-2"></i>Go to Login
    </a>
</div>

</body>
</html>