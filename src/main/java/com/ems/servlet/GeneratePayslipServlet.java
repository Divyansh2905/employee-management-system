package com.ems.servlet;

import com.ems.dao.EmployeeDAO;
import com.ems.dao.PayslipDAO;
import com.ems.model.Employee;
import com.ems.model.Payslip;
import com.ems.util.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/generatePayslip")
public class GeneratePayslipServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        request.setAttribute("employees", new EmployeeDAO().getAllEmployees());
        request.getRequestDispatcher("/admin/generatePayslip.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int empId        = Integer.parseInt(request.getParameter("employeeId"));
            int month        = Integer.parseInt(request.getParameter("month"));
            int year         = Integer.parseInt(request.getParameter("year"));
            double salary    = Double.parseDouble(request.getParameter("basicSalary"));
            boolean doEmail  = "on".equals(request.getParameter("sendEmail"));

            PayslipDAO payslipDAO = new PayslipDAO();

            if (payslipDAO.payslipExists(empId, month, year)) {
                request.setAttribute("error", "A payslip for this employee and period already exists.");
                request.setAttribute("employees", new EmployeeDAO().getAllEmployees());
                request.getRequestDispatcher("/admin/generatePayslip.jsp").forward(request, response);
                return;
            }

            Payslip p = new Payslip();
            p.setEmployeeId(empId);
            p.setMonth(month);
            p.setYear(year);
            p.setBasicSalary(salary);

            boolean generated = payslipDAO.addPayslip(p);

            if (generated && doEmail) {
                Employee emp = new EmployeeDAO().getEmployeeById(empId);
                boolean sent = EmailUtil.sendPayslipEmail(emp, p);
                session.setAttribute("successMsg", sent
                    ? "Payslip generated and email sent to " + emp.getEmail() + "."
                    : "Payslip generated. Email sending failed — check SMTP settings.");
            } else if (generated) {
                session.setAttribute("successMsg", "Payslip generated successfully.");
            }

            response.sendRedirect(request.getContextPath() + "/admin/viewEmployee?id=" + empId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid input. Please check all fields.");
            request.setAttribute("employees", new EmployeeDAO().getAllEmployees());
            request.getRequestDispatcher("/admin/generatePayslip.jsp").forward(request, response);
        }
    }
}