<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ems.model.Employee" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/error/accessDenied.jsp"); return;
    }
    String username = (String) session.getAttribute("username");
    Employee emp = (Employee) request.getAttribute("employee");
    if (emp == null) {
        response.sendRedirect(request.getContextPath() + "/admin/employeeList"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Employee Details - EMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <style>
        .profile-avatar {
            width: 80px; height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #1a2035, #2d4a8a);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: 700;
            flex-shrink: 0;
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
        <span>Admin Panel</span>
    </div>
    <div class="nav-section">Main</div>
    <a href="<%= request.getContextPath() %>/admin/adminDashboard.jsp">
        <i class="bi bi-grid-1x2-fill"></i> Dashboard
    </a>
    <div class="nav-section">Employees</div>
    <a href="<%= request.getContextPath() %>/admin/employeeList" class="active">
        <i class="bi bi-people"></i> All Employees
    </a>
    <a href="<%= request.getContextPath() %>/admin/addEmployee">
        <i class="bi bi-person-plus"></i> Add Employee
    </a>
    <div class="nav-section">Payslip</div>
    <a href="#"><i class="bi bi-receipt"></i> Generate Payslip</a>
    <div class="nav-section">Account</div>
    <a href="<%= request.getContextPath() %>/logout"><i class="bi bi-box-arrow-left"></i> Logout</a>
</div>

<div class="main-content">
    <div class="topbar">
        <h6>Employee Details</h6>
        <div class="d-flex align-items-center gap-2">
            <div class="avatar"><%= username.substring(0,1).toUpperCase() %></div>
            <div style="font-weight:600; font-size:0.85rem; color:#1a2035;"><%= username %></div>
        </div>
    </div>

    <div class="content">
        <div class="page-card" style="max-width:700px;">
            <!-- Profile header -->
            <div class="d-flex align-items-center gap-4 mb-4 pb-4" style="border-bottom:1px solid #f0f0f0;">
                <div class="profile-avatar">
                    <%= emp.getName().substring(0,1).toUpperCase() %>
                </div>
                <div>
                    <h5 style="margin:0; font-weight:700; color:#1a2035;"><%= emp.getName() %></h5>
                    <div style="color:#6c757d; font-size:0.875rem;"><%= emp.getDesignation() %></div>
                    <span style="background:#e8f0fe; color:#2d4a8a; border-radius:20px;
                                 padding:3px 12px; font-size:0.76rem; font-weight:600; margin-top:6px; display:inline-block;">
                        <%= emp.getDepartment() %>
                    </span>
                </div>
            </div>

            <!-- Info rows -->
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
                <div class="info-label"><i class="bi bi-briefcase me-2"></i>Designation</div>
                <div class="info-value"><%= emp.getDesignation() %></div>
            </div>
            <div class="info-row">
                <div class="info-label"><i class="bi bi-currency-rupee me-2"></i>Salary</div>
                <div class="info-value">₹<%= String.format("%,.0f", emp.getSalary()) %></div>
            </div>
            <div class="info-row">
                <div class="info-label"><i class="bi bi-calendar me-2"></i>Joining Date</div>
                <div class="info-value"><%= emp.getJoiningDate() %></div>
            </div>

            <!-- Action buttons -->
            <div class="d-flex gap-2 mt-4">
                <a href="<%= request.getContextPath() %>/admin/updateEmployee?id=<%= emp.getEmployeeId() %>"
                   class="btn-main">
                    <i class="bi bi-pencil"></i> Edit
                </a>
                <a href="<%= request.getContextPath() %>/admin/employeeList"
                   class="btn btn-outline-secondary" style="border-radius:8px; font-size:0.875rem; padding:9px 20px;">
                    <i class="bi bi-arrow-left me-1"></i> Back to List
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>