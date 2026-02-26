-- =============================================
-- PROCEDURES, FUNCTIONS, AND TRIGGERS
-- Database: d3
-- =============================================

CREATE DATABASE d3;
USE d3;

-- Create employees table
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    joining_date DATE
);

-- Insert sample data
INSERT INTO employees (name, department, salary, joining_date)
VALUES 
('Aman', 'IT', 50000, '2023-01-10'),
('Neha', 'HR', 60000, '2022-05-15'),
('Ravi', 'Finance', 55000, '2021-03-20'),
('Priya', 'IT', 70000, '2020-07-12');

-- =============================================
-- STORED PROCEDURES
-- =============================================

-- Procedure 1: Get all employees
DELIMITER //
CREATE PROCEDURE get_all_employees()
BEGIN 
    SELECT * FROM employees;
END //
DELIMITER ;

CALL get_all_employees();

-- Procedure 2: Get employee by ID (IN parameter)
DELIMITER //
CREATE PROCEDURE get_employee_by_id(IN emp_id INT)
BEGIN 
    SELECT * FROM employees WHERE id = emp_id;
END //
DELIMITER ;

CALL get_employee_by_id(1);

-- Procedure 3: Add new employee
DELIMITER //
CREATE PROCEDURE add_employee(
    IN emp_name VARCHAR(100),
    IN emp_dept VARCHAR(50),
    IN emp_salary DECIMAL(10,2),
    IN emp_join DATE
)
BEGIN 
    INSERT INTO employees(name, department, salary, joining_date) 
    VALUES (emp_name, emp_dept, emp_salary, emp_join);
END //
DELIMITER ;

CALL add_employee('Kiran', 'IT', 65000, '2024-01-10');

-- Procedure 4: Get employee details (OUT parameters)
DELIMITER //
CREATE PROCEDURE get_employee_details(
    IN emp_id INT,
    OUT emp_salary DECIMAL(10,2),
    OUT emp_department VARCHAR(50)
)
BEGIN
    SELECT salary, department
    INTO emp_salary, emp_department
    FROM employees
    WHERE id = emp_id;
END //
DELIMITER ;

SET @salary = 0;
SET @dept = '';
CALL get_employee_details(1, @salary, @dept);
SELECT @salary AS Salary, @dept AS Department;

-- =============================================
-- USER-DEFINED FUNCTIONS
-- =============================================

-- Function 1: Add two numbers
DELIMITER //
CREATE FUNCTION add_numbers(a INT, b INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN a + b;
END //
DELIMITER ;

SELECT add_numbers(5, 3);

-- Function 2: Calculate square of number
DELIMITER //
CREATE FUNCTION sq(a INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN a * a;
END //
DELIMITER ;

SELECT sq(2);

-- Function 3: Calculate 10% fee
DELIMITER //
CREATE FUNCTION calculate_fee(fee INT)
RETURNS INT
DETERMINISTIC
BEGIN 
    RETURN fee * 0.10;
END //
DELIMITER ;

-- Example usage: SELECT sname, fee, calculate_fee(fee) FROM student;

-- =============================================
-- TRIGGERS
-- =============================================

-- Create log tables for triggers
CREATE TABLE salary_log(
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    change_date DATETIME
);

CREATE TABLE Employee_Archive (
    empid INT,
    empname VARCHAR(100),
    salary DECIMAL(10,2),
    deleted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- BEFORE INSERT TRIGGER - Salary validation
DELIMITER //
CREATE TRIGGER before_insert_salary_check
BEFORE INSERT 
ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 20000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be at least 20000';
    END IF;
END //
DELIMITER ;

-- Test: This should fail
-- INSERT INTO employees(name, department, salary, joining_date) 
-- VALUES ('Vedang', 'AIML', 15000, '2024-01-01');

-- BEFORE INSERT TRIGGER - Auto-adjust high salary
DELIMITER //
CREATE TRIGGER before_insert_salary_adjust
BEFORE INSERT 
ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary >= 70000 THEN
        SET NEW.salary = 75000;
    END IF;
END //
DELIMITER ;

INSERT INTO employees(name, department, salary, joining_date) 
VALUES ('Raman', 'AIML', 73000, '2024-01-01');

-- AFTER UPDATE TRIGGER - Log salary changes
DELIMITER //
CREATE TRIGGER after_update_salary
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO salary_log(emp_id, old_salary, new_salary, change_date)
    VALUES(OLD.id, OLD.salary, NEW.salary, NOW());
END //
DELIMITER ;

UPDATE employees SET salary = 75000 WHERE id = 1;
SELECT * FROM salary_log;

-- BEFORE UPDATE TRIGGER - Prevent salary decrease
DELIMITER //
CREATE TRIGGER before_update_salary
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < OLD.salary THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot decrease the salary';
    END IF;
END //
DELIMITER ;

-- Test: This should fail
-- UPDATE employees SET salary = 5500 WHERE id = 2;

-- BEFORE DELETE TRIGGER - Prevent deletion of high-salary employees
DELIMITER //
CREATE TRIGGER before_delete_employee_check
BEFORE DELETE
ON employees
FOR EACH ROW 
BEGIN 
    IF OLD.salary > 55000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete high-salary employees directly';
    END IF;
END //
DELIMITER ;

-- Test: This should fail
-- INSERT INTO employees VALUES (10, 'Test', 'IT', 60000, '2024-01-01');
-- DELETE FROM employees WHERE id = 10;

-- AFTER DELETE TRIGGER - Archive deleted employees
DELIMITER //
CREATE TRIGGER after_delete_employee_archive
AFTER DELETE 
ON employees
FOR EACH ROW
BEGIN
    INSERT INTO Employee_Archive (empid, empname, salary, deleted_date)
    VALUES (OLD.id, OLD.name, OLD.salary, NOW());
END //
DELIMITER ;

DELETE FROM employees WHERE name = 'Ravi';
SELECT * FROM Employee_Archive;

-- =============================================
-- UTILITY COMMANDS
-- =============================================

-- View all triggers
SHOW TRIGGERS;

-- View table structure
SHOW COLUMNS FROM employees;

-- View all tables
SHOW TABLES;