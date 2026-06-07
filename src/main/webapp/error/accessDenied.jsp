<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Access Denied - EMS</title>
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
        .card {
            border: none;
            border-radius: 14px;
            padding: 50px 40px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            max-width: 420px;
        }
    </style>
</head>
<body>
<div class="card">
    <i class="bi bi-shield-x" style="font-size:3.5rem; color:#e74c3c;"></i>
    <h4 class="mt-3 fw-bold" style="color:#1a2035;">Access Denied</h4>
    <p class="text-muted mt-2" style="font-size:0.9rem;">
        You don't have permission to view this page.
    </p>
    <a href="<%= request.getContextPath() %>/login.jsp"
       class="btn mt-3 text-white"
       style="background:#1a2035; border-radius:8px; padding:9px 28px;">
        Back to Login
    </a>
</div>
</body>
</html>