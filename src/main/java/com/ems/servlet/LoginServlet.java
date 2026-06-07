package com.ems.servlet;

import com.ems.dao.UserDAO;
import com.ems.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();

        UserDAO dao = new UserDAO();
        User user = dao.getUserByCredentials(username, password);

        if (user == null) {
            request.setAttribute("error", "Invalid username or password. Please try again.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("role", user.getRole());
        session.setAttribute("employeeId", user.getEmployeeId());

        if ("admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/adminDashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/employee/employeeDashboard.jsp");
        }
    }
}