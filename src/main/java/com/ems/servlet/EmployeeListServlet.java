package com.ems.servlet;

import com.ems.dao.EmployeeDAO;
import com.ems.model.Employee;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/employeeList")
public class EmployeeListServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private static final int PAGE_SIZE = 10;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String search = request.getParameter("search") != null ? request.getParameter("search").trim() : "";
        String sortBy = request.getParameter("sortBy") != null ? request.getParameter("sortBy") : "employee_id";
        String order  = request.getParameter("order")  != null ? request.getParameter("order")  : "asc";

        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception ignored) {}
        if (page < 1) page = 1;

        int offset = (page - 1) * PAGE_SIZE;

        EmployeeDAO dao = new EmployeeDAO();
        List<Employee> employees = dao.getEmployeesForList(search, sortBy, order, offset, PAGE_SIZE);
        int total      = dao.getTotalCount(search);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
        if (totalPages == 0) totalPages = 1;

        request.setAttribute("employees",   employees);
        request.setAttribute("total",       total);
        request.setAttribute("totalPages",  totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("search",      search);
        request.setAttribute("sortBy",      sortBy);
        request.setAttribute("order",       order);

        request.getRequestDispatcher("/admin/employeeList.jsp").forward(request, response);
    }
}