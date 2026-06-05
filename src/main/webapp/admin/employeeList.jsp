<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

    String successMsg = (String) session.getAttribute("successMsg");
    if (successMsg != null) session.removeAttribute("successMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Employees - EMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <style>
        .table th { font-size: 0.78rem; text-transform: uppercase; letter-spacing: 0.5px; color: #6c757d; border-bottom: 2px solid #f0f0f0; }
        .table td { font-size: 0.875rem; vertical-align: middle; }
        .table tbody tr:hover { background: #f8f9fa; }
        .dept-badge {
            background: #e8f0fe; color: #2d4a8a;
            border-radius: 20px; padding: 3px 10px;
            font-size: 0.76rem; font-weight: 600;
        }
        .action-btn { padding: 4px 10px; font-size: 0.78rem; border-radius: 6px; text-decoration: none; display: inline-block; }
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
        <h6>All Employees</h6>
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

        <div class="page-card">
            <!-- Top bar: count + search + add button -->
            <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
                <div style="font-size:0.875rem; color:#6c757d;">
                    Total: <strong style="color:#1a2035;">${total}</strong> employees
                </div>
                <div class="d-flex gap-2">
                    <form method="get" action="${pageContext.request.contextPath}/admin/employeeList"
                          class="d-flex gap-2">
                        <input type="text" name="search" class="form-control" style="width:220px;"
                               placeholder="Search name, dept, ID..." value="${search}">
                        <input type="hidden" name="sortBy" value="${sortBy}">
                        <input type="hidden" name="order" value="${order}">
                        <button type="submit" class="btn-main" style="padding:9px 14px;">
                            <i class="bi bi-search"></i>
                        </button>
                        <c:if test="${not empty search}">
                            <a href="${pageContext.request.contextPath}/admin/employeeList"
                               class="btn btn-outline-secondary" style="border-radius:8px; padding:9px 12px; font-size:0.875rem;">
                                <i class="bi bi-x-lg"></i>
                            </a>
                        </c:if>
                    </form>
                    <a href="${pageContext.request.contextPath}/admin/addEmployee" class="btn-main">
                        <i class="bi bi-person-plus"></i> Add
                    </a>
                </div>
            </div>

            <!-- Employee Table -->
            <div class="table-responsive">
                <table class="table table-borderless">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>
                            <a class="sort-link" href="?sortBy=name&order=${sortBy == 'name' && order == 'asc' ? 'desc' : 'asc'}&page=1&search=${search}">
                                Name
                                <c:choose>
                                    <c:when test="${sortBy == 'name' && order == 'asc'}"><i class="bi bi-arrow-up"></i></c:when>
                                    <c:when test="${sortBy == 'name' && order == 'desc'}"><i class="bi bi-arrow-down"></i></c:when>
                                    <c:otherwise><i class="bi bi-arrow-down-up" style="opacity:0.35;"></i></c:otherwise>
                                </c:choose>
                            </a>
                        </th>
                        <th>
                            <a class="sort-link" href="?sortBy=department&order=${sortBy == 'department' && order == 'asc' ? 'desc' : 'asc'}&page=1&search=${search}">
                                Department
                                <c:choose>
                                    <c:when test="${sortBy == 'department' && order == 'asc'}"><i class="bi bi-arrow-up"></i></c:when>
                                    <c:when test="${sortBy == 'department' && order == 'desc'}"><i class="bi bi-arrow-down"></i></c:when>
                                    <c:otherwise><i class="bi bi-arrow-down-up" style="opacity:0.35;"></i></c:otherwise>
                                </c:choose>
                            </a>
                        </th>
                        <th>Designation</th>
                        <th>
                            <a class="sort-link" href="?sortBy=salary&order=${sortBy == 'salary' && order == 'asc' ? 'desc' : 'asc'}&page=1&search=${search}">
                                Salary
                                <c:choose>
                                    <c:when test="${sortBy == 'salary' && order == 'asc'}"><i class="bi bi-arrow-up"></i></c:when>
                                    <c:when test="${sortBy == 'salary' && order == 'desc'}"><i class="bi bi-arrow-down"></i></c:when>
                                    <c:otherwise><i class="bi bi-arrow-down-up" style="opacity:0.35;"></i></c:otherwise>
                                </c:choose>
                            </a>
                        </th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty employees}">
                            <tr>
                                <td colspan="6" class="text-center py-4" style="color:#aaa;">
                                    <i class="bi bi-inbox" style="font-size:1.5rem; display:block; margin-bottom:6px;"></i>
                                    No employees found.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="emp" items="${employees}" varStatus="status">
                            <tr>
                                <td style="color:#aaa; font-size:0.8rem;">
                                    ${(currentPage - 1) * 10 + status.count}
                                </td>
                                <td>
                                    <div style="font-weight:600; color:#1a2035;">${emp.name}</div>
                                    <div style="font-size:0.75rem; color:#aaa;">#${emp.employeeId}</div>
                                </td>
                                <td><span class="dept-badge">${emp.department}</span></td>
                                <td>${emp.designation}</td>
                                <td>
                                    <fmt:formatNumber value="${emp.salary}" type="currency"
                                        currencySymbol="₹" maxFractionDigits="0"/>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/viewEmployee?id=${emp.employeeId}"
                                       class="action-btn btn btn-outline-primary btn-sm me-1">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/updateEmployee?id=${emp.employeeId}"
                                       class="action-btn btn btn-outline-warning btn-sm me-1">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/deleteEmployee?id=${emp.employeeId}"
                                       class="action-btn btn btn-outline-danger btn-sm"
                                       onclick="return confirm('Delete ${emp.name}? This cannot be undone.')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
            <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap gap-2">
                <div style="font-size:0.8rem; color:#6c757d;">
                    Page ${currentPage} of ${totalPages}
                </div>
                <nav>
                    <ul class="pagination pagination-sm mb-0" style="gap:3px;">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" style="border-radius:6px;"
                               href="?page=${currentPage - 1}&search=${search}&sortBy=${sortBy}&order=${order}">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" style="border-radius:6px;"
                                   href="?page=${i}&search=${search}&sortBy=${sortBy}&order=${order}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" style="border-radius:6px;"
                               href="?page=${currentPage + 1}&search=${search}&sortBy=${sortBy}&order=${order}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
            </c:if>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>