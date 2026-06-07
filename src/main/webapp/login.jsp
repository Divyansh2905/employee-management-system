<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - EMS</title>
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
        .login-card {
            width: 820px;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0,0,0,0.12);
            display: flex;
            min-height: 460px;
        }
        .left-panel {
            width: 40%;
            background: linear-gradient(160deg, #1a2035 0%, #2d4a8a 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px;
            color: white;
        }
        .icon-circle {
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            width: 80px;
            height: 80px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }
        .left-panel h3 {
            font-weight: 700;
            font-size: 1.4rem;
            margin-bottom: 6px;
        }
        .left-panel p {
            font-size: 0.82rem;
            opacity: 0.7;
            text-align: center;
            margin: 0;
        }
        .right-panel {
            width: 60%;
            background: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 50px 45px;
        }
        .right-panel h4 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1a2035;
            margin-bottom: 4px;
        }
        .subtitle {
            font-size: 0.875rem;
            color: #6c757d;
            margin-bottom: 28px;
        }
        .form-label {
            font-size: 0.83rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        .form-control {
            border: 1.5px solid #e0e0e0;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 0.9rem;
        }
        .form-control:focus {
            border-color: #2d4a8a;
            box-shadow: 0 0 0 3px rgba(45,74,138,0.1);
        }
        .btn-login {
            background: linear-gradient(135deg, #1a2035, #2d4a8a);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 11px;
            font-weight: 600;
            font-size: 0.95rem;
            width: 100%;
            margin-top: 6px;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        .btn-login:hover { opacity: 0.88; }
    </style>
</head>
<body>

<div class="login-card">

    <div class="left-panel">
        <div class="icon-circle">
            <i class="bi bi-people-fill" style="font-size: 2rem;"></i>
        </div>
        <h3>EMS Portal</h3>
        <p>Employee Management System<br>The Heritage Academy</p>
    </div>

    <div class="right-panel">
        <h4>Welcome</h4>
        <p class="subtitle">Sign in to your account to continue</p>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="alert alert-danger py-2 mb-3" style="font-size:0.85rem; border-radius:8px;">
                <i class="bi bi-exclamation-circle me-1"></i><%= error %>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" name="username" class="form-control"
                       placeholder="Enter your username" required autocomplete="off">
            </div>
            <div class="mb-4">
                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-control"
                       placeholder="Enter your password" required>
            </div>
            <button type="submit" class="btn-login">
                <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
            </button>
        </form>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>