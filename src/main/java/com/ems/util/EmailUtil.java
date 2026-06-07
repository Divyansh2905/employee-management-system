package com.ems.util;

import com.ems.model.Employee;
import com.ems.model.Payslip;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class EmailUtil {

    private static final String FROM_EMAIL = "YOUR_EMAIL";
    private static final String APP_PASSWORD = "YOUR_APP_PASSWORD";
    private static final String HOST = "smtp.gmail.com";

    public static boolean sendPayslipEmail(Employee emp, Payslip payslip) {
        String subject = "Salary Slip — " + payslip.getMonthName() + " " + payslip.getYear();
        String body = buildBody(emp, payslip);
        return sendEmail(emp.getEmail(), subject, body);
    }

    public static boolean sendEmail(String toEmail, String subject, String body) {
        Properties props = new Properties();
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(FROM_EMAIL));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject(subject);
            msg.setContent(body, "text/html; charset=utf-8");
            Transport.send(msg);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    private static String buildBody(Employee emp, Payslip p) {
        double basic = p.getBasicSalary();
        double hra   = basic * 0.40;
        double da    = basic * 0.20;
        double gross = basic + hra + da;
        double pf    = basic * 0.12;
        double tax   = gross * 0.05;
        double net   = gross - pf - tax;

        return "<div style='font-family:Arial,sans-serif;max-width:580px;margin:0 auto;border-radius:10px;overflow:hidden;border:1px solid #e0e0e0;'>"
             + "<div style='background:#1a2035;color:white;padding:24px;text-align:center;'>"
             + "<h2 style='margin:0;font-size:18px;'>Employee Management System</h2>"
             + "<p style='margin:6px 0 0;opacity:0.65;font-size:13px;'>The Heritage Academy, Kolkata</p>"
             + "</div>"
             + "<div style='padding:24px;background:#fafafa;'>"
             + "<p style='font-size:14px;'>Dear <strong>" + emp.getName() + "</strong>,</p>"
             + "<p style='font-size:14px;'>Your salary slip for <strong>" + p.getMonthName() + " " + p.getYear() + "</strong> is ready.</p>"
             + "<table style='width:100%;border-collapse:collapse;margin-top:16px;font-size:13px;'>"
             + "<tr style='background:#2d4a8a;color:white;'>"
             + "<th style='padding:10px 14px;text-align:left;'>Component</th>"
             + "<th style='padding:10px 14px;text-align:right;'>Amount</th></tr>"
             + row("#fff",    "Basic Salary",            "Rs. " + fmt(basic))
             + row("#f9f9f9", "HRA (40%)",               "Rs. " + fmt(hra))
             + row("#fff",    "Dearness Allowance (20%)", "Rs. " + fmt(da))
             + row("#f9f9f9", "Provident Fund (-12%)",   "<span style='color:#e74c3c;'>- Rs. " + fmt(pf) + "</span>")
             + row("#fff",    "Income Tax (-5%)",         "<span style='color:#e74c3c;'>- Rs. " + fmt(tax) + "</span>")
             + "<tr style='background:#1a2035;color:white;'>"
             + "<td style='padding:12px 14px;font-weight:700;'>NET SALARY</td>"
             + "<td style='padding:12px 14px;text-align:right;font-weight:700;font-size:15px;'>Rs. " + fmt(net) + "</td></tr>"
             + "</table>"
             + "<p style='margin-top:20px;font-size:12px;color:#999;'>This is a system-generated email. Do not reply.</p>"
             + "</div></div>";
    }

    private static String row(String bg, String label, String value) {
        return "<tr style='background:" + bg + ";'>"
             + "<td style='padding:9px 14px;border-bottom:1px solid #eee;'>" + label + "</td>"
             + "<td style='padding:9px 14px;text-align:right;border-bottom:1px solid #eee;'>" + value + "</td></tr>";
    }

    private static String fmt(double val) {
        return String.format("%,.0f", val);
    }
}