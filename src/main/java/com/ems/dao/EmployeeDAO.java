package com.ems.dao;

import com.ems.model.Employee;
import java.sql.*;
import java.util.*;

public class EmployeeDAO {

    public boolean addEmployee(Employee emp) {
        String sql = "INSERT INTO employees (name, email, phone, department, designation, salary, joining_date) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, emp.getName());
            ps.setString(2, emp.getEmail());
            ps.setString(3, emp.getPhone());
            ps.setString(4, emp.getDepartment());
            ps.setString(5, emp.getDesignation());
            ps.setDouble(6, emp.getSalary());
            ps.setDate(7, emp.getJoiningDate());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) emp.setEmployeeId(keys.getInt(1));
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Employee> getEmployeesForList(String search, String sortBy, String order, int offset, int limit) {
        List<Employee> list = new ArrayList<>();
        String s = "%" + (search != null ? search : "") + "%";

        String col = "employee_id";
        if ("name".equals(sortBy)) col = "name";
        else if ("department".equals(sortBy)) col = "department";
        else if ("salary".equals(sortBy)) col = "salary";

        String dir = "desc".equalsIgnoreCase(order) ? "DESC" : "ASC";

        String sql = "SELECT * FROM employees WHERE name LIKE ? OR department LIKE ? "
                   + "OR CAST(employee_id AS CHAR) LIKE ? ORDER BY " + col + " " + dir + " LIMIT ? OFFSET ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s); ps.setString(2, s); ps.setString(3, s);
            ps.setInt(4, limit); ps.setInt(5, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalCount(String search) {
        String s = "%" + (search != null ? search : "") + "%";
        String sql = "SELECT COUNT(*) FROM employees WHERE name LIKE ? OR department LIKE ? OR CAST(employee_id AS CHAR) LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s); ps.setString(2, s); ps.setString(3, s);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Employee getEmployeeById(int id) {
        String sql = "SELECT * FROM employees WHERE employee_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateEmployee(Employee emp) {
        String sql = "UPDATE employees SET name=?, email=?, phone=?, department=?, designation=?, salary=?, joining_date=? WHERE employee_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, emp.getName()); ps.setString(2, emp.getEmail());
            ps.setString(3, emp.getPhone()); ps.setString(4, emp.getDepartment());
            ps.setString(5, emp.getDesignation()); ps.setDouble(6, emp.getSalary());
            ps.setDate(7, emp.getJoiningDate()); ps.setInt(8, emp.getEmployeeId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteEmployee(int id) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                PreparedStatement ps1 = conn.prepareStatement("DELETE FROM payslips WHERE employee_id = ?");
                ps1.setInt(1, id); ps1.executeUpdate();

                PreparedStatement ps2 = conn.prepareStatement("DELETE FROM users WHERE employee_id = ?");
                ps2.setInt(1, id); ps2.executeUpdate();

                PreparedStatement ps3 = conn.prepareStatement("DELETE FROM employees WHERE employee_id = ?");
                ps3.setInt(1, id); ps3.executeUpdate();

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getEmployeeCount() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM employees");
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getDepartmentCount() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery("SELECT COUNT(DISTINCT department) FROM employees");
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Employee mapRow(ResultSet rs) throws SQLException {
        Employee emp = new Employee();
        emp.setEmployeeId(rs.getInt("employee_id"));
        emp.setName(rs.getString("name"));
        emp.setEmail(rs.getString("email"));
        emp.setPhone(rs.getString("phone"));
        emp.setDepartment(rs.getString("department"));
        emp.setDesignation(rs.getString("designation"));
        emp.setSalary(rs.getDouble("salary"));
        emp.setJoiningDate(rs.getDate("joining_date"));
        emp.setProfilePhoto(rs.getString("profile_photo"));
        return emp;
    }
        
    public List<Employee> getAllEmployees() {
        List<Employee> list = new ArrayList<>();
        String sql = "SELECT employee_id, name, department, salary FROM employees ORDER BY name";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Employee emp = new Employee();
                emp.setEmployeeId(rs.getInt("employee_id"));
                emp.setName(rs.getString("name"));
                emp.setDepartment(rs.getString("department"));
                emp.setSalary(rs.getDouble("salary"));
                list.add(emp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateProfilePhoto(int empId, String fileName) {
        String sql = "UPDATE employees SET profile_photo = ? WHERE employee_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fileName);
            ps.setInt(2, empId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}