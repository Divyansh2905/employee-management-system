<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ems.model.Employee, java.util.List" %>
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
    String error = (String) request.getAttribute("error");
    List<Employee> employees = (List<Employee>) request.getAttribute("employees");

    java.util.Calendar cal = java.util.Calendar.getInstance();
    int currentYear  = cal.get(java.util.Calendar.YEAR);
    int currentMonth = cal.get(java.util.Calendar.MONTH) + 1;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Generate Payslip - EMS</title>
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
    <a href="<%= request.getContextPath() %>/admin/employeeList">
        <i class="bi bi-people"></i> All Employees
    </a>
    <a href="<%= request.getContextPath() %>/admin/addEmployee">
        <i class="bi bi-person-plus"></i> Add Employee
    </a>
    <div class="nav-section">Payslip</div>
    <a href="<%= request.getContextPath() %>/admin/generatePayslip" class="active">
        <i class="bi bi-receipt"></i> Generate Payslip
    </a>
    <div class="nav-section">Account</div>
    <a href="<%= request.getContextPath() %>/logout">
        <i class="bi bi-box-arrow-left"></i> Logout
    </a>
</div>

<div class="main-content">
    <div class="topbar">
        <h6>Generate Payslip</h6>
        <div class="d-flex align-items-center gap-2">
            <div class="avatar"><%= username.substring(0,1).toUpperCase() %></div>
            <div style="font-weight:600; font-size:0.85rem; color:#1a2035;"><%= username %></div>
        </div>
    </div>

    <div class="content">
        <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show mb-3" style="border-radius:8px; font-size:0.875rem;">
            <i class="bi bi-exclamation-circle me-1"></i><%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <div class="page-card" style="max-width:620px;">
            <h6 class="fw-bold mb-4" style="color:#1a2035; border-bottom:1px solid #f0f0f0; padding-bottom:10px;">
                <i class="bi bi-receipt me-2"></i>New Payslip
            </h6>

            <form action="<%= request.getContextPath() %>/admin/generatePayslip" method="post">
                <div class="mb-3">
                    <label class="form-label">Select Employee *</label>
                    <select id="empSelect" name="employeeId" class="form-select" required>
                        <option value="">-- Choose Employee --</option>
                        <% if (employees != null) {
                               for (Employee emp : employees) { %>
                        <option value="<%= emp.getEmployeeId() %>"
                                data-salary="<%= (int) emp.getSalary() %>">
                            <%= emp.getName() %> — <%= emp.getDepartment() %>
                        </option>
                        <% }} %>
                    </select>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Month *</label>
                        <select name="month" class="form-select" required>
                            <% String[] mNames = {"","January","February","March","April","May","June",
                                                   "July","August","September","October","November","December"};
                               for (int i = 1; i <= 12; i++) { %>
                            <option value="<%= i %>" <%= i == currentMonth ? "selected" : "" %>>
                                <%= mNames[i] %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Year *</label>
                        <input type="number" name="year" class="form-control"
                               value="<%= currentYear %>" min="2020" max="2099" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Basic Salary (₹) *</label>
                    <input type="number" id="salaryInput" name="basicSalary" class="form-control"
                           placeholder="Auto-filled when employee is selected" min="0" required>
                    <div style="font-size:0.78rem; color:#6c757d; margin-top:4px;">
                        Auto-filled from employee record. You can adjust if needed.
                    </div>
                </div>

                <div class="mb-4 p-3" style="background:#f8f9ff; border-radius:8px; border:1px solid #e0e8ff;">
                    <div class="form-check">
                        <input type="checkbox" name="sendEmail" id="sendEmail" class="form-check-input">
                        <label for="sendEmail" class="form-check-label" style="font-size:0.875rem;">
                            <i class="bi bi-envelope me-1" style="color:#2d4a8a;"></i>
                            Send salary slip email to employee after generating
                        </label>
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn-main">
                        <i class="bi bi-check-lg"></i> Generate Payslip
                    </button>
                    <a href="<%= request.getContextPath() %>/admin/employeeList"
                       class="btn btn-outline-secondary" style="border-radius:8px; font-size:0.875rem; padding:9px 20px;">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('empSelect').addEventListener('change', function() {
        const selected = this.options[this.selectedIndex];
        const salary = selected.getAttribute('data-salary');
        if (salary) {
            document.getElementById('salaryInput').value = salary;
        } else {
            document.getElementById('salaryInput').value = '';
        }
    });
</script>
</body>
</html>