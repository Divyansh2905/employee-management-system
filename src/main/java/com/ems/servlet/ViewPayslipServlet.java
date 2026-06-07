package com.ems.servlet;

import com.ems.dao.PayslipDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/employee/viewPayslip")
public class ViewPayslipServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (!"employee".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/error/accessDenied.jsp");
            return;
        }
        int empId = (int) session.getAttribute("employeeId");
        request.setAttribute("payslips", new PayslipDAO().getPayslipsByEmployeeId(empId));
        request.getRequestDispatcher("/employee/viewPayslip.jsp").forward(request, response);
    }
}