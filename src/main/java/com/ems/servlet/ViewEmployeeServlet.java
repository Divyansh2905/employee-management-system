package com.ems.servlet;

import com.ems.dao.EmployeeDAO;
import com.ems.dao.PayslipDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/viewEmployee")
public class ViewEmployeeServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        request.setAttribute("employee", new EmployeeDAO().getEmployeeById(id));
        request.setAttribute("payslips", new PayslipDAO().getPayslipsByEmployeeId(id));
        request.getRequestDispatcher("/admin/employeeDetails.jsp").forward(request, response);
    }
}