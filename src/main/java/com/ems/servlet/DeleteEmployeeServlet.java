package com.ems.servlet;

import com.ems.dao.EmployeeDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/deleteEmployee")
public class DeleteEmployeeServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        new EmployeeDAO().deleteEmployee(id);
        session.setAttribute("successMsg", "Employee deleted.");
        response.sendRedirect(request.getContextPath() + "/admin/employeeList");
    }
}