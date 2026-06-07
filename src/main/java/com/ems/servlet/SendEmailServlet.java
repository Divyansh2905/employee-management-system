package com.ems.servlet;

import com.ems.dao.EmployeeDAO;
import com.ems.dao.PayslipDAO;
import com.ems.model.Employee;
import com.ems.model.Payslip;
import com.ems.util.EmailUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/sendEmail")
public class SendEmailServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int payslipId = Integer.parseInt(request.getParameter("payslipId"));
        int empId     = Integer.parseInt(request.getParameter("empId"));

        Payslip p   = new PayslipDAO().getPayslipById(payslipId);
        Employee emp = new EmployeeDAO().getEmployeeById(empId);

        if (p != null && emp != null) {
            boolean sent = EmailUtil.sendPayslipEmail(emp, p);
            session.setAttribute("successMsg", sent
                ? "Email sent to " + emp.getEmail() + "."
                : "Email failed — check SMTP settings in EmailUtil.java.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/viewEmployee?id=" + empId);
    }
}