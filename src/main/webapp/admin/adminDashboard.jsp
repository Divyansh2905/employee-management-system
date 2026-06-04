<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

    if (session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/error/accessDenied.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - EMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body { background: #f0f2f5; font-family: 'Segoe UI', sans-serif; margin: 0; }

        .sidebar {
            width: 240px;
            height: 100vh;
            background: #1a2035;
            position: fixed;
            top: 0; left: 0;
            display: flex;
            flex-direction: column;
            z-index: 100;
        }
        .sidebar-brand {
            padding: 22px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .sidebar-brand h5 {
            color: white;
            margin: 0;
            font-weight: 700;
            font-size: 1rem;
        }
        .sidebar-brand span {
            color: rgba(255,255,255,0.45);
            font-size: 0.73rem;
        }
        .nav-section {
            padding: 12px 20px 4px;
            font-size: 0.68rem;
            color: rgba(255,255,255,0.3);
            text-transform: uppercase;
            letter-spacing: 0.9px;
        }
        .sidebar a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 20px;
            color: rgba(255,255,255,0.62);
            text-decoration: none;
            font-size: 0.865rem;
            transition: all 0.15s;
        }
        .sidebar a:hover { background: rgba(255,255,255,0.07); color: white; }
        .sidebar a.active {
            background: rgba(255,255,255,0.09);
            color: white;
            border-left: 3px solid #4f6ef7;
        }
        .main-content { margin-left: 240px; min-height: 100vh; }

        .topbar {
            background: white;
            padding: 14px 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 1px 4px rgba(0,0,0,0.07);
        }
        .topbar h6 { margin: 0; font-weight: 700; color: #1a2035; font-size: 1rem; }
        .avatar {
            width: 34px; height: 34px;
            border-radius: 50%;
            background: #2d4a8a;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.85rem;
        }
        .content { padding: 28px; }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 22px;
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.055);
        }
        .stat-icon {
            width: 50px; height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.35rem;
            flex-shrink: 0;
        }
        .stat-card h3 { margin: 0; font-size: 1.6rem; font-weight: 700; color: #1a2035; }
        .stat-card p { margin: 0; font-size: 0.78rem; color: #6c757d; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand">
        <h5><i class="bi bi-people-fill me-2"></i>EMS Portal</h5>
        <span>Admin Panel</span>
    </div>

    <div class="nav-section">Main</div>
    <a href="adminDashboard.jsp" class="active"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a>

    <div class="nav-section">Employees</div>
    <a href="#"><i class="bi bi-people"></i> All Employees</a>
    <a href="#"><i class="bi bi-person-plus"></i> Add Employee</a>

    <div class="nav-section">Payslip</div>
    <a href="#"><i class="bi bi-receipt"></i> Generate Payslip</a>

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

        <div class="row g-3">
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon" style="background:#e8f0fe;">
                        <i class="bi bi-people-fill" style="color:#2d4a8a;"></i>
                    </div>
                    <div>
                        <h3>—</h3>
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
                        <h3>—</h3>
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
                        <h3>—</h3>
                        <p>Payslips Generated</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon" style="background:#fce8e8;">
                        <i class="bi bi-shield-check" style="color:#e74c3c;"></i>
                    </div>
                    <div>
                        <h3>2</h3>
                        <p>Active Users</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-center mt-5" style="color:#bbb;">
            <i class="bi bi-arrow-left-circle" style="font-size:1.8rem;"></i>
            <p class="mt-2" style="font-size:0.85rem;">Use the sidebar to manage employees and payslips.</p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>