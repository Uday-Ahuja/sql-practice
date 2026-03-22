# SQL Procedures, Functions & Triggers

---

## 1. Stored Procedures

> A named, precompiled block of SQL stored in the DB — executed on demand via `CALL`.

### Syntax

```sql
DELIMITER //
CREATE PROCEDURE procedure_name([IN|OUT|INOUT] param datatype, ...)
BEGIN
    -- SQL statements
END //
DELIMITER ;

CALL procedure_name(args);
```

### Parameter Modes

| Mode | Direction | Use |
|------|-----------|-----|
| `IN` | Caller → Procedure | Read-only input |
| `OUT` | Procedure → Caller | Returns a value |
| `INOUT` | Both | Read + modify |

---

### Examples

**No params — fetch all rows**
```sql
DELIMITER //
CREATE PROCEDURE get_all_employees()
BEGIN
    SELECT * FROM employees;
END //
DELIMITER ;

CALL get_all_employees();
```

**IN param — filter by ID**
```sql
DELIMITER //
CREATE PROCEDURE get_employee_by_id(IN emp_id INT)
BEGIN
    SELECT * FROM employees WHERE id = emp_id;
END //
DELIMITER ;

CALL get_employee_by_id(1);
```

**IN param — insert row**
```sql
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
```

**OUT params — return values to caller**
```sql
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

-- Call with session variables
SET @salary = 0;
SET @dept = ' ';
CALL get_employee_details(1, @salary, @dept);
SELECT @salary AS Salary, @dept AS Department;
```

> `SELECT ... INTO` assigns query result directly to OUT variables.

---

## 2. User-Defined Functions (UDF)

> Returns a single value. Used inline in SELECT/WHERE. Cannot do DML (INSERT/UPDATE/DELETE).

### Syntax

```sql
DELIMITER //
CREATE FUNCTION function_name(param datatype, ...)
RETURNS return_datatype
DETERMINISTIC
BEGIN
    RETURN expression;
END //
DELIMITER ;
```

> `DETERMINISTIC` = same inputs always give same output. Required if `log_bin_trust_function_creators` is OFF.

### Examples

```sql
-- Simple arithmetic
CREATE FUNCTION add_numbers(a INT, b INT)
RETURNS INT DETERMINISTIC
BEGIN RETURN a + b; END;

SELECT add_numbers(5, 3);  -- 8

-- 10% of fee
CREATE FUNCTION calculate_fee(fee INT)
RETURNS INT DETERMINISTIC
BEGIN RETURN fee * 0.10; END;

SELECT sname, fee, calculate_fee(fee) FROM student;

-- Square
CREATE FUNCTION sq(a INT)
RETURNS INT DETERMINISTIC
BEGIN RETURN a * a; END;

SELECT sq(2);  -- 4
```

---

### Procedure vs Function

| | Procedure | Function |
|---|-----------|----------|
| Call | `CALL proc()` | `SELECT func()` |
| Returns | OUT params | Single value via `RETURN` |
| DML allowed | ✅ Yes | ❌ No |
| Used in SELECT | ❌ No | ✅ Yes |
| `DETERMINISTIC` | Optional | Required (usually) |

---

## 3. Triggers

> Auto-executed SQL block fired by a DML event on a table. Cannot be called manually.

### Syntax

```sql
DELIMITER //
CREATE TRIGGER trigger_name
{BEFORE | AFTER} {INSERT | UPDATE | DELETE}
ON table_name
FOR EACH ROW
BEGIN
    -- trigger body
    -- use NEW.col, OLD.col
END //
DELIMITER ;
```

### NEW vs OLD

| Event | `NEW` | `OLD` |
|-------|-------|-------|
| INSERT | ✅ New row values | ❌ N/A |
| UPDATE | ✅ Updated values | ✅ Previous values |
| DELETE | ❌ N/A | ✅ Deleted row values |

> In `BEFORE` triggers, you can **modify** `NEW.col` values. In `AFTER` triggers, `NEW` is read-only.

### Raising Errors

```sql
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Custom error message';
```

> `45000` = generic user-defined error. Aborts the triggering statement.

---

### Trigger Examples

**BEFORE INSERT — validate salary**
```sql
DELIMITER //
CREATE TRIGGER before_insert_salary_check
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 20000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be at least 20000';
    END IF;
END //
DELIMITER ;

-- Error: salary 15000 < 20000
INSERT INTO employees(name, department, salary, joining_date)
VALUES ('Vedang', 'AIML', 15000, '2024-01-01');
```

**BEFORE INSERT — auto-correct salary**
```sql
DELIMITER //
CREATE TRIGGER before_insert_employees
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary >= 70000 THEN
        SET NEW.salary = 75000;  -- override before row is written
    END IF;
END //
DELIMITER ;

-- 73000 → stored as 75000
INSERT INTO employees VALUES ('Raman', 'AIML', 73000, '2024-01-01');
```

**AFTER UPDATE — audit log**
```sql
CREATE TABLE salary_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    change_date DATETIME
);

DELIMITER //
CREATE TRIGGER after_update_salary
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO salary_log(emp_id, old_salary, new_salary, change_date)
    VALUES (OLD.id, OLD.salary, NEW.salary, NOW());
END //
DELIMITER ;

UPDATE employees SET salary = 75000 WHERE id = 1;
SELECT * FROM salary_log;
```

**BEFORE UPDATE — prevent salary decrease**
```sql
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

-- Error: 5500 < current salary
UPDATE employees SET salary = 5500 WHERE id = 2;
```

**BEFORE DELETE — protect high-salary employees**
```sql
DELIMITER //
CREATE TRIGGER before_delete_employee_check
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary > 55000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete high-salary employees directly';
    END IF;
END //
DELIMITER ;

DELETE FROM employees WHERE id = 1;  -- Error if salary > 55000
```

**AFTER DELETE — archive deleted rows**
```sql
CREATE TABLE Employee_Archive1 (
    empid INT,
    empname VARCHAR(100),
    salary DECIMAL(10,2),
    deleted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER after_delete_employee_archive4
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO Employee_Archive1(empid, empname, salary, deleted_date)
    VALUES (OLD.id, OLD.name, OLD.salary, NOW());
END //
DELIMITER ;

DELETE FROM employees WHERE name = 'Ravi';
SELECT * FROM Employee_Archive1;
```

---

## 4. Trigger Timing Reference

| Timing | INSERT | UPDATE | DELETE |
|--------|--------|--------|--------|
| BEFORE | Validate/modify `NEW` | Validate/modify `NEW`, compare `OLD` | Validate `OLD` |
| AFTER | Log/audit | Audit log | Archive `OLD` |

---

## 5. Management Commands

```sql
SHOW TRIGGERS;                     -- list all triggers
SHOW TRIGGERS LIKE 'table_name';   -- filter by table
DROP TRIGGER trigger_name;         -- remove trigger
DROP PROCEDURE procedure_name;     -- remove procedure
DROP FUNCTION function_name;       -- remove function
SHOW COLUMNS FROM table_name;      -- inspect table schema
```

---

## 6. Common Mistakes

| Mistake | Fix |
|---------|-----|
| Forgetting `DELIMITER //` | Without it, `;` inside body ends the CREATE statement early |
| Using `NEW` in DELETE trigger | DELETE has no `NEW` — use `OLD` only |
| Using `OLD` in INSERT trigger | INSERT has no `OLD` — use `NEW` only |
| Modifying `NEW` in AFTER trigger | Can only modify `NEW` in BEFORE triggers |
| Missing `SET` after `SIGNAL` | `SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '...'` — both required |
| Calling a function with `CALL` | Functions use `SELECT func()`, not `CALL` |
| DML inside a function | Functions are read-only — use a procedure instead |
| `desc table employees` | Correct syntax: `DESC employees` (no `table` keyword) |
