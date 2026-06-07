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
    if (!"employee".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/error/accessDenied.jsp"); return;
    }
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Payslips - EMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <style>
        .table th {
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #6c757d;
            border-bottom: 2px solid #f0f0f0;
        }
        .table td { font-size: 0.875rem; vertical-align: middle; }
        .table tbody tr:hover { background: #f8f9fa; }
        .month-badge {
            background: #e8f8f0; color: #1a6b45;
            border-radius: 20px;
            padding: 3px 12px;
            font-size: 0.78rem;
            font-weight: 600;
        }
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
    <a href="<%= request.getContextPath() %>/employee/profile">
        <i class="bi bi-person-circle"></i> My Profile
    </a>
    <a href="<%= request.getContextPath() %>/employee/viewPayslip" class="active">
        <i class="bi bi-receipt"></i> My Payslip
    </a>
    <div class="nav-section">Account</div>
    <a href="<%= request.getContextPath() %>/logout">
        <i class="bi bi-box-arrow-left"></i> Logout
    </a>
</div>

<div class="main-content">
    <div class="topbar">
        <h6>My Payslips</h6>
        <div class="d-flex align-items-center gap-2">
            <div class="avatar" style="background:#27ae60;"><%= username.substring(0,1).toUpperCase() %></div>
            <div style="font-weight:600; font-size:0.85rem; color:#1a2035;"><%= username %></div>
        </div>
    </div>

    <div class="content">
        <div class="page-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div style="font-size:0.875rem; color:#6c757d;">
                    Your payslip history
                </div>
            </div>

            <c:choose>
                <c:when test="${empty payslips}">
                    <div class="text-center py-5" style="color:#bbb;">
                        <i class="bi bi-receipt" style="font-size:2.5rem; display:block; margin-bottom:10px;"></i>
                        <p style="font-size:0.9rem; color:#aaa; margin:0;">No payslips generated yet.</p>
                        <p style="font-size:0.8rem; color:#bbb;">Contact your administrator.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-borderless">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Pay Period</th>
                                <th>Basic Salary</th>
                                <th>Net Salary</th>
                                <th>Generated On</th>
                                <th>Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="slip" items="${payslips}" varStatus="st">
                                <tr>
                                    <td style="color:#aaa; font-size:0.8rem;">${st.count}</td>
                                    <td>
                                        <span class="month-badge">${slip.monthName} ${slip.year}</span>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${slip.basicSalary}" type="currency"
                                            currencySymbol="₹" maxFractionDigits="0"/>
                                    </td>
                                    <td style="font-weight:600; color:#1a2035;">
                                        <fmt:formatNumber value="${slip.netSalary}"
                                            type="currency" currencySymbol="₹" maxFractionDigits="0"/>
                                    </td>
                                    <td style="color:#6c757d;">${slip.generatedDate}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/employee/downloadPayslip?id=${slip.payslipId}"
                                           class="btn btn-sm btn-outline-success" style="border-radius:6px; font-size:0.8rem;">
                                            <i class="bi bi-download me-1"></i>Download PDF
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