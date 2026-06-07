package com.ems.servlet;

import com.ems.dao.EmployeeDAO;
import com.ems.model.Employee;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/admin/updateEmployee")
public class UpdateEmployeeServlet extends HttpServlet {

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
        request.getRequestDispatcher("/admin/editEmployee.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Employee emp = new Employee();
            emp.setEmployeeId(Integer.parseInt(request.getParameter("employeeId")));
            emp.setName(request.getParameter("name").trim());
            emp.setEmail(request.getParameter("email").trim());
            emp.setPhone(request.getParameter("phone").trim());
            emp.setDepartment(request.getParameter("department"));
            emp.setDesignation(request.getParameter("designation").trim());
            emp.setSalary(Double.parseDouble(request.getParameter("salary")));
            emp.setJoiningDate(Date.valueOf(request.getParameter("joiningDate")));

            new EmployeeDAO().updateEmployee(emp);
            session.setAttribute("successMsg", "Employee updated successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/employeeList");
    }
}