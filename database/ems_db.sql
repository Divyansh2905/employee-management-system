CREATE DATABASE IF NOT EXISTS ems_db;
USE ems_db;

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    department VARCHAR(50),
    designation VARCHAR(50),
    salary DECIMAL(10,2),
    joining_date DATE,
    profile_photo VARCHAR(255)
);

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role ENUM('admin', 'employee') NOT NULL,
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE payslips (
    payslip_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL,
    basic_salary DECIMAL(10,2),
    generated_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO users (username, password, role) 
VALUES ('admin', 'admin123', 'admin');

INSERT INTO employees (name, email, phone, department, designation, salary, joining_date)
VALUES ('Rahul Sharma', 'rahul@ems.com', '9876543210', 'IT', 'Developer', 50000.00, '2024-01-15');

INSERT INTO users (username, password, role, employee_id)
VALUES ('rahul', 'rahul123', 'employee', 1);