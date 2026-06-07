package com.ems.dao;

import com.ems.model.Payslip;
import java.sql.Statement;
import java.sql.*;
import java.util.*;

public class PayslipDAO {

    public List<Payslip> getPayslipsByEmployeeId(int employeeId) {
        List<Payslip> list = new ArrayList<>();
        String sql = "SELECT * FROM payslips WHERE employee_id = ? ORDER BY year DESC, month DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Payslip getPayslipById(int payslipId) {
        String sql = "SELECT * FROM payslips WHERE payslip_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, payslipId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getPayslipCount() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM payslips");
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Payslip mapRow(ResultSet rs) throws SQLException {
        Payslip p = new Payslip();
        p.setPayslipId(rs.getInt("payslip_id"));
        p.setEmployeeId(rs.getInt("employee_id"));
        p.setMonth(rs.getInt("month"));
        p.setYear(rs.getInt("year"));
        p.setBasicSalary(rs.getDouble("basic_salary"));
        p.setGeneratedDate(rs.getDate("generated_date"));
        return p;
    }
    
    public boolean addPayslip(Payslip p) {
        String sql = "INSERT INTO payslips (employee_id, month, year, basic_salary, generated_date) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getEmployeeId());
            ps.setInt(2, p.getMonth());
            ps.setInt(3, p.getYear());
            ps.setDouble(4, p.getBasicSalary());
            ps.setDate(5, new java.sql.Date(System.currentTimeMillis()));
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) p.setPayslipId(keys.getInt(1));
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean payslipExists(int employeeId, int month, int year) {
        String sql = "SELECT COUNT(*) FROM payslips WHERE employee_id=? AND month=? AND year=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}