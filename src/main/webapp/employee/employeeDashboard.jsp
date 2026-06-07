<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    if (!"employee".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/error/accessDenied.jsp"); return;
    }
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Dashboard - EMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <style>
        .quick-card {
            background: white;
            border-radius: 12px;
            padding: 30px 24px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.055);
            text-decoration: none;
            display: block;
            transition: transform 0.15s, box-shadow 0.15s;
            color: inherit;
        }
        .quick-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.10);
            color: inherit;
        }
        .quick-card i { font-size: 2.2rem; margin-bottom: 12px; display: block; }
        .quick-card h6 { font-weight: 700; color: #1a2035; margin: 0; }
        .quick-card p { font-size: 0.78rem; color: #6c757d; margin: 4px 0 0; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand">
        <h5><i class="bi bi-people-fill me-2"></i>EMS Portal</h5>
        <span>Employee Panel</span>
    </div>
    <div class="nav-section">My Account</div>
    <a href="<%= request.getContextPath() %>/employee/employeeDashboard.jsp" class="active">
        <i class="bi bi-grid-1x2-fill"></i> Dashboard
    </a>
    <a href="<%= request.getContextPath() %>/employee/profile">
        <i class="bi bi-person-circle"></i> My Profile
    </a>
    <a href="<%= request.getContextPath() %>/employee/viewPayslip">
        <i class="bi bi-receipt"></i> My Payslip
    </a>
    <div class="nav-section">Account</div>
    <a href="<%= request.getContextPath() %>/logout">
        <i class="bi bi-box-arrow-left"></i> Logout
    </a>
</div>

<div class="main-content">
    <div class="topbar">
        <h6>My Dashboard</h6>
        <div class="d-flex align-items-center gap-2">
            <div class="avatar" style="background:#27ae60;"><%= username.substring(0,1).toUpperCase() %></div>
            <div>
                <div style="font-weight:600; font-size:0.85rem; color:#1a2035;"><%= username %></div>
                <div style="font-size:0.72rem; color:#6c757d;">Employee</div>
            </div>
        </div>
    </div>

    <div class="content">
        <div class="mb-4">
            <h5 style="font-weight:700; color:#1a2035;">Hello, <%= username %>!</h5>
            <p style="color:#6c757d; font-size:0.875rem; margin:0;">Welcome to your employee portal.</p>
        </div>

        <div class="row g-3">
            <div class="col-md-4">
                <a href="<%= request.getContextPath() %>/employee/profile" class="quick-card">
                    <i class="bi bi-person-circle" style="color:#2d4a8a;"></i>
                    <h6>My Profile</h6>
                    <p>View your personal details</p>
                </a>
            </div>
            <div class="col-md-4">
                <a href="<%= request.getContextPath() %>/employee/viewPayslip" class="quick-card">
                    <i class="bi bi-receipt" style="color:#27ae60;"></i>
                    <h6>My Payslips</h6>
                    <p>View and download payslips</p>
                </a>
            </div>
            <div class="col-md-4">
                <a href="<%= request.getContextPath() %>/logout" class="quick-card">
                    <i class="bi bi-box-arrow-left" style="color:#e74c3c;"></i>
                    <h6>Logout</h6>
                    <p>Sign out of your account</p>
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>