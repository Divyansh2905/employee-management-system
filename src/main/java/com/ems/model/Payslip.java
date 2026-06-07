package com.ems.model;

import java.sql.Date;

public class Payslip {

    private int payslipId;
    private int employeeId;
    private int month;
    private int year;
    private double basicSalary;
    private Date generatedDate;

    private static final String[] MONTH_NAMES = {
        "", "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    };

    public String getMonthName() {
        return (month >= 1 && month <= 12) ? MONTH_NAMES[month] : "";
    }
    
    public double getNetSalary() {
        double gross = basicSalary * 1.60;
        double pf    = basicSalary * 0.12;
        double tax   = gross * 0.05;
        return gross - pf - tax;
    }

    public int getPayslipId() { return payslipId; }
    public void setPayslipId(int payslipId) { this.payslipId = payslipId; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public int getMonth() { return month; }
    public void setMonth(int month) { this.month = month; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public double getBasicSalary() { return basicSalary; }
    public void setBasicSalary(double basicSalary) { this.basicSalary = basicSalary; }

    public Date getGeneratedDate() { return generatedDate; }
    public void setGeneratedDate(Date generatedDate) { this.generatedDate = generatedDate; }
}