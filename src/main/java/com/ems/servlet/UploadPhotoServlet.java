package com.ems.servlet;

import com.ems.dao.EmployeeDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/admin/uploadPhoto")
@MultipartConfig(maxFileSize = 2097152, maxRequestSize = 5242880)
public class UploadPhotoServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int empId = Integer.parseInt(request.getParameter("empId"));
        Part photo = request.getPart("photo");

        if (photo == null || photo.getSize() == 0) {
            response.sendRedirect(request.getContextPath() + "/admin/viewEmployee?id=" + empId);
            return;
        }

        String uploadDir = getServletContext().getRealPath("") + File.separator + "images";
        File folder = new File(uploadDir);
        if (!folder.exists()) folder.mkdirs();

        String fileName = "emp_" + empId + "_" + System.currentTimeMillis() + ".jpg";
        photo.write(uploadDir + File.separator + fileName);

        new EmployeeDAO().updateProfilePhoto(empId, fileName);

        session.setAttribute("successMsg", "Profile photo updated.");
        response.sendRedirect(request.getContextPath() + "/admin/viewEmployee?id=" + empId);
    }
}