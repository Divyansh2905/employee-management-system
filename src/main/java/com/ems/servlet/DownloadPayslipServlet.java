package com.ems.servlet;

import com.ems.dao.EmployeeDAO;
import com.ems.dao.PayslipDAO;
import com.ems.model.Employee;
import com.ems.model.Payslip;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.awt.Color;
import java.io.IOException;

@WebServlet("/employee/downloadPayslip")
public class DownloadPayslipServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int payslipId   = Integer.parseInt(request.getParameter("id"));
        int sessionEmpId = (int) session.getAttribute("employeeId");

        Payslip p = new PayslipDAO().getPayslipById(payslipId);

        if (p == null || p.getEmployeeId() != sessionEmpId) {
            response.sendRedirect(request.getContextPath() + "/error/accessDenied.jsp");
            return;
        }

        Employee emp = new EmployeeDAO().getEmployeeById(sessionEmpId);

        double basic = p.getBasicSalary();
        double hra   = basic * 0.40;
        double da    = basic * 0.20;
        double gross = basic + hra + da;
        double pf    = basic * 0.12;
        double tax   = gross * 0.05;
        double net   = gross - pf - tax;

        String fileName = "Payslip_" + p.getMonthName() + "_" + p.getYear() + ".pdf";
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        Document doc = new Document(PageSize.A4, 50, 50, 50, 50);
        try {
            PdfWriter.getInstance(doc, response.getOutputStream());
            doc.open();

            Color dark  = new Color(26, 32, 53);
            Color blue  = new Color(45, 74, 138);
            Color grey  = new Color(108, 117, 125);
            Color light = new Color(248, 249, 250);
            Color tblBg = new Color(232, 240, 254);
            Color dedBg = new Color(252, 232, 232);

            Font fTitle  = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16, dark);
            Font fSub    = FontFactory.getFont(FontFactory.HELVETICA, 9, grey);
            Font fLabel  = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, dark);
            Font fValue  = FontFactory.getFont(FontFactory.HELVETICA, 9, Color.BLACK);
            Font fHdr    = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, Color.WHITE);
            Font fBold   = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, dark);
            Font fNet    = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 13, Color.WHITE);
            Font fSlip   = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, dark);

            // Company header
            Paragraph title = new Paragraph("EMPLOYEE MANAGEMENT SYSTEM", fTitle);
            title.setAlignment(Element.ALIGN_CENTER);
            doc.add(title);

            Paragraph addr = new Paragraph("The Heritage Academy, Kolkata", fSub);
            addr.setAlignment(Element.ALIGN_CENTER);
            addr.setSpacingAfter(6);
            doc.add(addr);

            // Divider
            PdfPTable div = new PdfPTable(1);
            div.setWidthPercentage(100);
            PdfPCell dc = new PdfPCell();
            dc.setBackgroundColor(dark);
            dc.setFixedHeight(2);
            dc.setBorder(Rectangle.NO_BORDER);
            div.addCell(dc);
            doc.add(div);
            doc.add(new Paragraph(" "));

            // Payslip period title
            Paragraph slipTitle = new Paragraph(
                "SALARY SLIP  —  " + p.getMonthName().toUpperCase() + " " + p.getYear(), fSlip);
            slipTitle.setAlignment(Element.ALIGN_CENTER);
            slipTitle.setSpacingAfter(12);
            doc.add(slipTitle);

            // Employee info
            PdfPTable info = new PdfPTable(4);
            info.setWidthPercentage(100);
            info.setWidths(new float[]{1.5f, 2.5f, 1.5f, 2.5f});
            info.setSpacingAfter(14);

            addInfoRow(info, "Employee ID", "#" + emp.getEmployeeId(), "Department", emp.getDepartment(), fLabel, fValue, light);
            addInfoRow(info, "Name", emp.getName(), "Designation", emp.getDesignation(), fLabel, fValue, light);
            addInfoRow(info, "Email", emp.getEmail(), "Pay Period", p.getMonthName() + " " + p.getYear(), fLabel, fValue, light);

            doc.add(info);

            // Salary breakdown table
            PdfPTable sal = new PdfPTable(4);
            sal.setWidthPercentage(100);
            sal.setWidths(new float[]{2.5f, 1.5f, 2.5f, 1.5f});

            for (String h : new String[]{"EARNINGS", "AMOUNT (Rs.)", "DEDUCTIONS", "AMOUNT (Rs.)"}) {
                PdfPCell hc = new PdfPCell(new Phrase(h, fHdr));
                hc.setBackgroundColor(blue);
                hc.setPadding(8);
                hc.setHorizontalAlignment(Element.ALIGN_CENTER);
                hc.setBorderColor(Color.WHITE);
                sal.addCell(hc);
            }

            addSalRow(sal, "Basic Salary",             basic, "Provident Fund (12%)", pf,  fValue);
            addSalRow(sal, "HRA (40% of Basic)",       hra,   "Income Tax (5%)",      tax, fValue);
            addSalRow(sal, "Dearness Allowance (20%)", da,    "",                     0,   fValue);

            sal.addCell(cell("Gross Salary",         fBold, tblBg, Element.ALIGN_LEFT));
            sal.addCell(cell("Rs. " + fmt(gross),    fBold, tblBg, Element.ALIGN_RIGHT));
            sal.addCell(cell("Total Deductions",     fBold, dedBg, Element.ALIGN_LEFT));
            sal.addCell(cell("Rs. " + fmt(pf + tax), fBold, dedBg, Element.ALIGN_RIGHT));

            doc.add(sal);

            // Net salary bar
            PdfPTable netTable = new PdfPTable(1);
            netTable.setWidthPercentage(100);
            PdfPCell netCell = new PdfPCell(new Phrase("NET SALARY:   Rs. " + fmt(net), fNet));
            netCell.setBackgroundColor(dark);
            netCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            netCell.setPadding(14);
            netCell.setBorder(Rectangle.NO_BORDER);
            netTable.addCell(netCell);
            doc.add(netTable);

            doc.add(new Paragraph(" "));

            Paragraph footer = new Paragraph(
                "Generated on: " + p.getGeneratedDate() + "  |  This is a system-generated payslip.", fSub);
            footer.setAlignment(Element.ALIGN_CENTER);
            doc.add(footer);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            doc.close();
        }
    }

    private void addInfoRow(PdfPTable t, String l1, String v1, String l2, String v2,
                             Font lf, Font vf, Color bg) {
        t.addCell(cell(l1, lf, bg, Element.ALIGN_LEFT));
        t.addCell(cell(v1, vf, Color.WHITE, Element.ALIGN_LEFT));
        t.addCell(cell(l2, lf, bg, Element.ALIGN_LEFT));
        t.addCell(cell(v2, vf, Color.WHITE, Element.ALIGN_LEFT));
    }

    private void addSalRow(PdfPTable t, String earning, double earnAmt,
                            String deduction, double dedAmt, Font f) {
        t.addCell(cell(earning, f, Color.WHITE, Element.ALIGN_LEFT));
        t.addCell(cell(earnAmt > 0 ? "Rs. " + fmt(earnAmt) : "", f, Color.WHITE, Element.ALIGN_RIGHT));
        t.addCell(cell(deduction, f, Color.WHITE, Element.ALIGN_LEFT));
        t.addCell(cell(dedAmt > 0 ? "Rs. " + fmt(dedAmt) : "", f, Color.WHITE, Element.ALIGN_RIGHT));
    }

    private PdfPCell cell(String text, Font font, Color bg, int align) {
        PdfPCell c = new PdfPCell(new Phrase(text, font));
        c.setBackgroundColor(bg);
        c.setHorizontalAlignment(align);
        c.setPadding(7);
        c.setBorderColor(new Color(220, 220, 220));
        return c;
    }

    private String fmt(double val) {
        return String.format("%,.0f", val);
    }
}