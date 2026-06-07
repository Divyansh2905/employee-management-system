<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ems.model.Employee" %>
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
    Employee emp = (Employee) request.getAttribute("employee");
    if (emp == null) {
        response.sendRedirect(request.getContextPath() + "/employee/employeeDashboard.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile - EMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <style>
        .profile-avatar {
            width: 80px; height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #1a6b45, #27ae60);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: 700;
        }
        .info-row {
            display: flex;
            padding: 12px 0;
            border-bottom: 1px solid #f5f5f5;
            font-size: 0.875rem;
        }
        .info-row:last-child { border-bottom: none; }
        .info-label { width: 160px; color: #6c757d; flex-shrink: 0; }
        .info-value { color: #1a2035; font-weight: 500; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand">
        <h5><i class="bi bi-people-fill me-2"></i>EMS Portal</h5>
        <span>Employee Panel</span>
    </div>
    <div class="nav-section">My Account</div>
    <a href="<%= request.getContextPath() %>/employee/employeeDashboard.jsp">
        <i class="bi bi-grid-1x2-fill"></i> Dashboard
    </a>
    <a href="<%= request.getContextPath() %>/employee/profile" class="active">
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
        <h6>My Profile</h6>
        <div class="d-flex align-items-center gap-2">
            <div class="avatar" style="background:#27ae60;"><%= username.substring(0,1).toUpperCase() %></div>
            <div style="font-weight:600; font-size:0.85rem; color:#1a2035;"><%= username %></div>
        </div>
    </div>

    <div class="content">
        <div class="page-card" style="max-width:680px;">
            <div class="d-flex align-items-center gap-4 mb-4 pb-4" style="border-bottom:1px solid #f0f0f0;">
                <% if (emp.getProfilePhoto() != null && !emp.getProfilePhoto().isEmpty()) { %>
			    <img src="<%= request.getContextPath() %>/images/<%= emp.getProfilePhoto() %>"
			         style="width:80px;height:80px;border-radius:50%;object-fit:cover;border:3px solid #e8f8f0;"
			         alt="Profile Photo">
			<% } else { %>
			    <div class="profile-avatar">
			        <%= emp.getName().substring(0,1).toUpperCase() %>
			    </div>
			<% } %>
                <div>
                    <h5 style="margin:0; font-weight:700; color:#1a2035;"><%= emp.getName() %></h5>
                    <div style="color:#6c757d; font-size:0.875rem; margin-top:2px;"><%= emp.getDesignation() %></div>
                    <span style="background:#e8f8f0; color:#27ae60; border-radius:20px;
                                 padding:3px 12px; font-size:0.76rem; font-weight:600;
                                 margin-top:7px; display:inline-block;">
                        <%= emp.getDepartment() %>
                    </span>
                </div>
            </div>

            <div class="info-row">
                <div class="info-label"><i class="bi bi-hash me-2"></i>Employee ID</div>
                <div class="info-value">#<%= emp.getEmployeeId() %></div>
            </div>
            <div class="info-row">
                <div class="info-label"><i class="bi bi-envelope me-2"></i>Email</div>
                <div class="info-value"><%= emp.getEmail() %></div>
            </div>
            <div class="info-row">
                <div class="info-label"><i class="bi bi-phone me-2"></i>Phone</div>
                <div class="info-value"><%= emp.getPhone() != null ? emp.getPhone() : "—" %></div>
            </div>
            <div class="info-row">
                <div class="info-label"><i class="bi bi-building me-2"></i>Department</div>
                <div class="info-value"><%= emp.getDepartment() %></div>
            </div>
            <div class="info-row">
                <div class="info-label"><i class="bi bi-briefcase me-2"></i>Designation</div>
                <div class="info-value"><%= emp.getDesignation() %></div>
            </div>
            <div class="info-row">
                <div class="info-label"><i class="bi bi-currency-rupee me-2"></i>Salary</div>
                <div class="info-value">₹<%= String.format("%,.0f", emp.getSalary()) %> / month</div>
            </div>
            <div class="info-row">
                <div class="info-label"><i class="bi bi-calendar me-2"></i>Joining Date</div>
                <div class="info-value"><%= emp.getJoiningDate() %></div>
            </div>

            <div class="mt-4">
                <a href="<%= request.getContextPath() %>/employee/viewPayslip" class="btn-main">
                    <i class="bi bi-receipt"></i> View My Payslips
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>