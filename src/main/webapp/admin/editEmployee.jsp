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
    <title>Edit Employee - EMS</title>
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
        <h6>Edit Employee &nbsp;<span style="font-weight:400; color:#6c757d;">#<%= emp.getEmployeeId() %></span></h6>
        <div class="d-flex align-items-center gap-2">
            <div class="avatar"><%= username.substring(0,1).toUpperCase() %></div>
            <div style="font-weight:600; font-size:0.85rem; color:#1a2035;"><%= username %></div>
        </div>
    </div>

    <div class="content">
        <form action="<%= request.getContextPath() %>/admin/updateEmployee" method="post">
            <input type="hidden" name="employeeId" value="<%= emp.getEmployeeId() %>">

            <div class="page-card mb-4">
                <h6 class="fw-bold mb-3" style="color:#1a2035; border-bottom:1px solid #f0f0f0; padding-bottom:10px;">
                    <i class="bi bi-person me-2"></i>Edit Employee Information
                </h6>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Full Name *</label>
                        <input type="text" name="name" class="form-control"
                               value="<%= emp.getName() %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Email Address *</label>
                        <input type="email" name="email" class="form-control"
                               value="<%= emp.getEmail() %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Phone Number</label>
                        <input type="text" name="phone" class="form-control"
                               value="<%= emp.getPhone() != null ? emp.getPhone() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Department *</label>
                        <select name="department" class="form-select" required>
                            <% String[] depts = {"IT","HR","Finance","Marketing","Operations","Admin"};
                               for (String d : depts) { %>
                                <option value="<%= d %>" <%= d.equals(emp.getDepartment()) ? "selected" : "" %>><%= d %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Designation *</label>
                        <input type="text" name="designation" class="form-control"
                               value="<%= emp.getDesignation() %>" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Salary (₹) *</label>
                        <input type="number" name="salary" class="form-control"
                               value="<%= (int)emp.getSalary() %>" min="0" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Joining Date *</label>
                        <input type="date" name="joiningDate" class="form-control"
                               value="<%= emp.getJoiningDate() %>" required>
                    </div>
                </div>
            </div>

            <div class="d-flex gap-2">
                <button type="submit" class="btn-main">
                    <i class="bi bi-check-lg"></i> Save Changes
                </button>
                <a href="<%= request.getContextPath() %>/admin/employeeList"
                   class="btn btn-outline-secondary" style="border-radius:8px; font-size:0.875rem; padding:9px 20px;">
                    Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>