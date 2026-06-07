package com.ems.servlet;

import com.ems.dao.EmployeeDAO;
import com.ems.dao.UserDAO;
import com.ems.model.Employee;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/admin/addEmployee")
public class AddEmployeeServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        request.getRequestDispatcher("/admin/addEmployee.jsp").forward(request, response);
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
            emp.setName(request.getParameter("name").trim());
            emp.setEmail(request.getParameter("email").trim());
            emp.setPhone(request.getParameter("phone").trim());
            emp.setDepartment(request.getParameter("department"));
            emp.setDesignation(request.getParameter("designation").trim());
            emp.setSalary(Double.parseDouble(request.getParameter("salary")));
            emp.setJoiningDate(Date.valueOf(request.getParameter("joiningDate")));

            String username = request.getParameter("username").trim();
            String password = request.getParameter("password").trim();

            EmployeeDAO empDAO = new EmployeeDAO();
            boolean added = empDAO.addEmployee(emp);

            if (added) {
                new UserDAO().addUser(username, password, emp.getEmployeeId());
                session.setAttribute("successMsg", "Employee added successfully.");
                response.sendRedirect(request.getContextPath() + "/admin/employeeList");
            } else {
                request.setAttribute("error", "Something went wrong. Please try again.");
                request.getRequestDispatcher("/admin/addEmployee.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid input. Please check all fields.");
            request.getRequestDispatcher("/admin/addEmployee.jsp").forward(request, response);
        }
    }
}