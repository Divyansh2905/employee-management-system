<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ems.model.Employee, com.ems.model.Payslip, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

    String successMsg = (String) session.getAttribute("successMsg");
    if (successMsg != null) session.removeAttribute("successMsg");
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
            display: flex; align-items: center; justify-content: center;
            font-size: 2rem; font-weight: 700; flex-shrink: 0;
        }
        .profile-photo {
            width: 80px; height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #e8f0fe;
            flex-shrink: 0;
        }
        .info-row {
            display: flex; padding: 11px 0;
            border-bottom: 1px solid #f5f5f5;
            font-size: 0.875rem;
        }
        .info-row:last-child { border-bottom: none; }
        .info-label { width: 155px; color: #6c757d; flex-shrink: 0; }
        .info-value { color: #1a2035; font-weight: 500; }
        .table th { font-size: 0.76rem; text-transform: uppercase; color: #6c757d; letter-spacing: 0.4px; }
        .table td { font-size: 0.865rem; vertical-align: middle; }
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
    <a href="<%= request.getContextPath() %>/admin/generatePayslip">
        <i class="bi bi-receipt"></i> Generate Payslip
    </a>
    <div class="nav-section">Account</div>
    <a href="<%= request.getContextPath() %>/logout">
        <i class="bi bi-box-arrow-left"></i> Logout
    </a>
</div>

<div class="main-content">
    <div class="topbar">
        <h6>Employee Details &nbsp;<span style="font-weight:400; color:#6c757d;">#<%= emp.getEmployeeId() %></span></h6>
        <div class="d-flex align-items-center gap-2">
            <div class="avatar"><%= username.substring(0,1).toUpperCase() %></div>
            <div style="font-weight:600; font-size:0.85rem; color:#1a2035;"><%= username %></div>
        </div>
    </div>

    <div class="content">
        <% if (successMsg != null) { %>
        <div class="alert alert-success alert-dismissible fade show mb-3" style="border-radius:8px; font-size:0.875rem;">
            <i class="bi bi-check-circle me-2"></i><%= successMsg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <div class="row g-3">
            <!-- Left: Profile Info -->
            <div class="col-md-7">
                <div class="page-card">
                    <!-- Profile header -->
                    <div class="d-flex align-items-center gap-4 mb-4 pb-4" style="border-bottom:1px solid #f0f0f0;">
                        <% if (emp.getProfilePhoto() != null && !emp.getProfilePhoto().isEmpty()) { %>
                            <img src="<%= request.getContextPath() %>/images/<%= emp.getProfilePhoto() %>"
                                 class="profile-photo" alt="Profile Photo">
                        <% } else { %>
                            <div class="profile-avatar"><%= emp.getName().substring(0,1).toUpperCase() %></div>
                        <% } %>
                        <div>
                            <h5 style="margin:0; font-weight:700; color:#1a2035;"><%= emp.getName() %></h5>
                            <div style="color:#6c757d; font-size:0.875rem;"><%= emp.getDesignation() %></div>
                            <span style="background:#e8f0fe; color:#2d4a8a; border-radius:20px;
                                         padding:3px 12px; font-size:0.76rem; font-weight:600;
                                         margin-top:6px; display:inline-block;">
                                <%= emp.getDepartment() %>
                            </span>
                        </div>
                    </div>

                    <!-- Info rows -->
                    <div class="info-row">
                        <div class="info-label"><i class="bi bi-envelope me-2"></i>Email</div>
                        <div class="info-value"><%= emp.getEmail() %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="bi bi-phone me-2"></i>Phone</div>
                        <div class="info-value"><%= emp.getPhone() != null ? emp.getPhone() : "—" %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="bi bi-currency-rupee me-2"></i>Salary</div>
                        <div class="info-value">₹<%= String.format("%,.0f", emp.getSalary()) %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="bi bi-calendar me-2"></i>Joining Date</div>
                        <div class="info-value"><%= emp.getJoiningDate() %></div>
                    </div>

                    <div class="d-flex gap-2 mt-4">
                        <a href="<%= request.getContextPath() %>/admin/updateEmployee?id=<%= emp.getEmployeeId() %>"
                           class="btn-main"><i class="bi bi-pencil"></i> Edit</a>
                        <a href="<%= request.getContextPath() %>/admin/employeeList"
                           class="btn btn-outline-secondary" style="border-radius:8px; font-size:0.875rem; padding:9px 20px;">
                            <i class="bi bi-arrow-left me-1"></i> Back
                        </a>
                    </div>
                </div>
            </div>

            <!-- Right: Photo Upload -->
            <div class="col-md-5">
                <div class="page-card">
                    <h6 class="fw-bold mb-3" style="color:#1a2035; font-size:0.9rem;">
                        <i class="bi bi-camera me-2"></i>Profile Photo
                    </h6>
                    <form action="<%= request.getContextPath() %>/admin/uploadPhoto"
                          method="post" enctype="multipart/form-data">
                        <input type="hidden" name="empId" value="<%= emp.getEmployeeId() %>">
                        <div class="mb-3">
                            <input type="file" name="photo" class="form-control"
                                   accept="image/jpeg,image/png,image/jpg" required>
                            <div style="font-size:0.75rem; color:#aaa; margin-top:5px;">
                                JPG or PNG, max 2MB
                            </div>
                        </div>
                        <button type="submit" class="btn-main w-100">
                            <i class="bi bi-upload me-1"></i> Upload Photo
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Payslip History -->
        <div class="page-card mt-3">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h6 class="fw-bold mb-0" style="color:#1a2035; font-size:0.9rem;">
                    <i class="bi bi-receipt me-2"></i>Payslip History
                </h6>
                <a href="<%= request.getContextPath() %>/admin/generatePayslip" class="btn-main" style="font-size:0.8rem; padding:7px 14px;">
                    <i class="bi bi-plus-lg"></i> Generate New
                </a>
            </div>

            <c:choose>
                <c:when test="${empty payslips}">
                    <div class="text-center py-4" style="color:#bbb;">
                        <i class="bi bi-receipt" style="font-size:1.8rem; display:block; margin-bottom:6px;"></i>
                        <p style="font-size:0.85rem; margin:0;">No payslips generated yet for this employee.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-borderless mb-0">
                            <thead>
                            <tr>
                                <th>Period</th>
                                <th>Basic Salary</th>
                                <th>Net Salary</th>
                                <th>Generated On</th>
                                <th>Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="slip" items="${payslips}">
                            <tr>
                                <td>
                                    <span style="background:#e8f0fe; color:#2d4a8a; border-radius:20px;
                                                 padding:3px 10px; font-size:0.78rem; font-weight:600;">
                                        ${slip.monthName} ${slip.year}
                                    </span>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${slip.basicSalary}" type="currency"
                                        currencySymbol="₹" maxFractionDigits="0"/>
                                </td>
                                <td style="font-weight:600; color:#1a2035;">
                                    <fmt:formatNumber value="${slip.netSalary}" type="currency"
                                        currencySymbol="₹" maxFractionDigits="0"/>
                                </td>
                                <td style="color:#6c757d; font-size:0.82rem;">${slip.generatedDate}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/sendEmail?payslipId=${slip.payslipId}&empId=${slip.employeeId}"
                                       class="btn btn-sm btn-outline-primary" style="border-radius:6px; font-size:0.78rem;"
                                       onclick="return confirm('Send payslip email?')">
                                        <i class="bi bi-envelope"></i> Send Email
                                    </a>
                                </td>
                            </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>