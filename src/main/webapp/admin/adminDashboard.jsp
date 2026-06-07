<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ems.dao.EmployeeDAO, com.ems.dao.PayslipDAO" %>
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

    EmployeeDAO dao = new EmployeeDAO();
    int empCount  = dao.getEmployeeCount();
    int deptCount = dao.getDepartmentCount();
    int payslipCount = new PayslipDAO().getPayslipCount();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - EMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand">
        <h5><i class="bi bi-people-fill me-2"></i>EMS Portal</h5>
        <span>Admin Panel</span>
    </div>
    <div class="nav-section">Main</div>
    <a href="<%= request.getContextPath() %>/admin/adminDashboard.jsp" class="active">
        <i class="bi bi-grid-1x2-fill"></i> Dashboard
    </a>
    <div class="nav-section">Employees</div>
    <a href="<%= request.getContextPath() %>/admin/employeeList">
        <i class="bi bi-people"></i> All Employees
    </a>
    <a href="<%= request.getContextPath() %>/admin/addEmployee">
        <i class="bi bi-person-plus"></i> Add Employee
    </a>
    <div class="nav-section">Payslip</div>
    <a href="<%= request.getContextPath() %>/admin/generatePayslip"><i class="bi bi-receipt"></i> Generate Payslip</a>
    <div class="nav-section">Account</div>
    <a href="<%= request.getContextPath() %>/logout"><i class="bi bi-box-arrow-left"></i> Logout</a>
</div>

<div class="main-content">
    <div class="topbar">
        <h6>Dashboard</h6>
        <div class="d-flex align-items-center gap-2">
            <div class="avatar"><%= username.substring(0,1).toUpperCase() %></div>
            <div>
                <div style="font-weight:600; font-size:0.85rem; color:#1a2035;"><%= username %></div>
                <div style="font-size:0.72rem; color:#6c757d;">Administrator</div>
            </div>
        </div>
    </div>

    <div class="content">
        <div class="mb-4">
            <h5 style="font-weight:700; color:#1a2035;">Welcome back, <%= username %>!</h5>
            <p style="color:#6c757d; font-size:0.875rem; margin:0;">Here's an overview of your system.</p>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon" style="background:#e8f0fe;">
                        <i class="bi bi-people-fill" style="color:#2d4a8a;"></i>
                    </div>
                    <div>
                        <h3><%= empCount %></h3>
                        <p>Total Employees</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon" style="background:#e8f8f0;">
                        <i class="bi bi-building" style="color:#27ae60;"></i>
                    </div>
                    <div>
                        <h3><%= deptCount %></h3>
                        <p>Departments</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon" style="background:#fff4e5;">
                        <i class="bi bi-receipt" style="color:#f39c12;"></i>
                    </div>
                    <div>
                        <h3><%= payslipCount %></h3>
                        <p>Payslips</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon" style="background:#fce8e8;">
                        <i class="bi bi-shield-check" style="color:#e74c3c;"></i>
                    </div>
                    <div>
                        <h3><%= empCount + 1 %></h3>
                        <p>Active Users</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-center mt-5" style="color:#ccc;">
            <i class="bi bi-people" style="font-size:2.5rem;"></i>
            <p class="mt-2" style="font-size:0.875rem; color:#aaa;">
                Use the sidebar to manage employees.
            </p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>