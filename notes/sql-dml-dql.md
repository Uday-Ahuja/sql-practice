# SQL DML and DQL

## What is DML?

**DML (Data Manipulation Language)** - Commands used to manipulate data within tables.

**Key Characteristic:** DML commands can be **rolled back** (unlike DDL) if within a transaction.

---

## What is DQL?

**DQL (Data Query Language)** - Commands used to retrieve data from database.

**Main Command:** SELECT

Some consider DQL part of DML, but SELECT is often treated separately due to its read-only nature.

---

## DML Commands

### 1. INSERT - Add New Data

**Syntax:**
```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);
```

**Example 1: Insert Single Row**
```sql
INSERT INTO Students (student_id, name, age, email)
VALUES (1, 'Alice', 20, 'alice@email.com');
```

**Example 2: Insert Without Column Names** (all columns in order)
```sql
INSERT INTO Students
VALUES (2, 'Bob', 21, 'bob@email.com');
```

**Example 3: Insert Multiple Rows**
```sql
INSERT INTO Students (student_id, name, age, email)
VALUES 
    (3, 'Charlie', 22, 'charlie@email.com'),
    (4, 'Diana', 20, 'diana@email.com'),
    (5, 'Eve', 23, 'eve@email.com');
```

**Example 4: Insert with Default Values**
```sql
INSERT INTO Products (product_name, price)
VALUES ('Laptop', 50000);
-- is_available uses DEFAULT TRUE, created_at uses DEFAULT CURRENT_TIMESTAMP
```

**Example 5: Insert from Another Table**
```sql
INSERT INTO Archive_Students
SELECT * FROM Students WHERE graduation_year = 2024;
```

---

### 2. UPDATE - Modify Existing Data

**Syntax:**
```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

**⚠️ Important:** Always use WHERE clause, otherwise ALL rows will be updated!

**Example 1: Update Single Column**
```sql
UPDATE Students
SET email = 'newalice@email.com'
WHERE student_id = 1;
```

**Example 2: Update Multiple Columns**
```sql
UPDATE Employees
SET salary = 75000, department = 'IT'
WHERE emp_id = 101;
```

**Example 3: Update with Calculation**
```sql
-- Give 10% raise to all employees
UPDATE Employees
SET salary = salary * 1.10
WHERE department = 'Sales';
```

**Example 4: Update All Rows** (use carefully!)
```sql
-- Mark all products as available
UPDATE Products
SET is_available = TRUE;
```

**Example 5: Update Using Subquery**
```sql
UPDATE Students
SET gpa = (SELECT AVG(marks)/10 FROM Exams WHERE Exams.student_id = Students.student_id)
WHERE student_id IN (SELECT student_id FROM Exams);
```

---

### 3. DELETE - Remove Data

**Syntax:**
```sql
DELETE FROM table_name
WHERE condition;
```

**⚠️ Important:** Always use WHERE clause, otherwise ALL rows will be deleted!

**Example 1: Delete Specific Row**
```sql
DELETE FROM Students
WHERE student_id = 5;
```

**Example 2: Delete Multiple Rows**
```sql
DELETE FROM Orders
WHERE order_date < '2024-01-01';
```

**Example 3: Delete All Rows** (structure remains)
```sql
DELETE FROM TempData;
-- Same as TRUNCATE but slower
```

**Example 4: Delete Using Subquery**
```sql
DELETE FROM Students
WHERE student_id IN (SELECT student_id FROM Dropped_Students);
```

---

## DQL Command: SELECT

The most important and frequently used SQL command.

### Basic SELECT Syntax
```sql
SELECT column1, column2, ...
FROM table_name
WHERE condition
ORDER BY column
LIMIT number;
```

---

### SELECT Clauses

#### 1. SELECT - Choose Columns
```sql
-- Select specific columns
SELECT name, age FROM Students;

-- Select all columns
SELECT * FROM Students;

-- Select with alias
SELECT name AS student_name, age AS student_age FROM Students;

-- Select distinct values
SELECT DISTINCT department FROM Employees;
```

#### 2. FROM - Specify Table
```sql
SELECT * FROM Students;

-- From multiple tables (join)
SELECT s.name, e.course
FROM Students s, Enrollment e
WHERE s.student_id = e.student_id;
```

#### 3. WHERE - Filter Rows
```sql
-- Single condition
SELECT * FROM Students WHERE age > 20;

-- Multiple conditions (AND)
SELECT * FROM Students WHERE age > 20 AND department = 'CS';

-- Multiple conditions (OR)
SELECT * FROM Students WHERE age < 18 OR age > 25;

-- NOT condition
SELECT * FROM Students WHERE NOT department = 'IT';

-- Combining AND/OR
SELECT * FROM Students 
WHERE (age > 20 AND department = 'CS') OR (age < 18);
```

#### 4. ORDER BY - Sort Results
```sql
-- Ascending order (default)
SELECT * FROM Students ORDER BY name;
SELECT * FROM Students ORDER BY name ASC;

-- Descending order
SELECT * FROM Students ORDER BY age DESC;

-- Multiple columns
SELECT * FROM Students ORDER BY department ASC, age DESC;
```

#### 5. LIMIT - Restrict Number of Rows
```sql
-- First 5 rows
SELECT * FROM Students LIMIT 5;

-- Skip first 10, get next 5 (pagination)
SELECT * FROM Students LIMIT 5 OFFSET 10;
-- Or shorthand:
SELECT * FROM Students LIMIT 10, 5;
```

#### 6. GROUP BY - Group Rows
```sql
-- Count students per department
SELECT department, COUNT(*) AS student_count
FROM Students
GROUP BY department;

-- Average salary per department
SELECT department, AVG(salary) AS avg_salary
FROM Employees
GROUP BY department;

-- Multiple grouping columns
SELECT department, semester, COUNT(*) AS count
FROM Enrollment
GROUP BY department, semester;
```

#### 7. HAVING - Filter Groups
```sql
-- Departments with more than 10 students
SELECT department, COUNT(*) AS student_count
FROM Students
GROUP BY department
HAVING COUNT(*) > 10;

-- Departments with average salary > 50000
SELECT department, AVG(salary) AS avg_salary
FROM Employees
GROUP BY department
HAVING AVG(salary) > 50000;
```

**WHERE vs HAVING:**
- WHERE filters rows BEFORE grouping
- HAVING filters groups AFTER grouping
```sql
-- Correct usage
SELECT department, AVG(salary) AS avg_salary
FROM Employees
WHERE is_active = TRUE           -- Filter rows first
GROUP BY department
HAVING AVG(salary) > 50000;      -- Filter groups after
```

---

## Nested Queries (Subqueries)

A query inside another query.

### Types of Subqueries

#### 1. Single-Value Subquery

Returns single value, used with =, <, >, etc.
```sql
-- Find students older than average age
SELECT name, age
FROM Students
WHERE age > (SELECT AVG(age) FROM Students);

-- Find most expensive product
SELECT product_name, price
FROM Products
WHERE price = (SELECT MAX(price) FROM Products);
```

#### 2. Multi-Value Subquery

Returns multiple values, used with IN, ANY, ALL.

**Using IN:**
```sql
-- Find students enrolled in DBMS course
SELECT name
FROM Students
WHERE student_id IN (
    SELECT student_id FROM Enrollment WHERE course_name = 'DBMS'
);

-- Find books not issued to anyone
SELECT book_name
FROM Books
WHERE book_id NOT IN (SELECT book_id FROM Issue);
```

**Using ANY:**
```sql
-- Salary greater than ANY salary in Sales department
SELECT name, salary
FROM Employees
WHERE salary > ANY (SELECT salary FROM Employees WHERE department = 'Sales');
```

**Using ALL:**
```sql
-- Salary greater than ALL salaries in Sales department
SELECT name, salary
FROM Employees
WHERE salary > ALL (SELECT salary FROM Employees WHERE department = 'Sales');
```

#### 3. Correlated Subquery

Inner query references outer query.
```sql
-- Find employees earning more than department average
SELECT e1.name, e1.salary, e1.department
FROM Employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM Employees e2
    WHERE e2.department = e1.department
);
```

#### 4. EXISTS / NOT EXISTS

Checks if subquery returns any rows.
```sql
-- Find students who have issued at least one book
SELECT s.name
FROM Students s
WHERE EXISTS (
    SELECT 1 FROM Issue i WHERE i.student_id = s.student_id
);

-- Find students who haven't issued any book
SELECT s.name
FROM Students s
WHERE NOT EXISTS (
    SELECT 1 FROM Issue i WHERE i.student_id = s.student_id
);
```

#### 5. Subquery in FROM Clause

Treat subquery result as a table.
```sql
-- Average of department averages
SELECT AVG(dept_avg_salary) AS overall_avg
FROM (
    SELECT department, AVG(salary) AS dept_avg_salary
    FROM Employees
    GROUP BY department
) AS dept_averages;
```

---

## Complete Query Examples

### Example 1: Complex SELECT with All Clauses
```sql
SELECT 
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary,
    MAX(salary) AS max_salary
FROM Employees
WHERE is_active = TRUE AND hire_date >= '2020-01-01'
GROUP BY department
HAVING COUNT(*) > 5
ORDER BY avg_salary DESC
LIMIT 3;
```

**Execution Order:**
1. FROM - Get data from Employees table
2. WHERE - Filter active employees hired after 2020
3. GROUP BY - Group by department
4. HAVING - Keep departments with > 5 employees
5. SELECT - Calculate aggregates
6. ORDER BY - Sort by average salary
7. LIMIT - Return top 3

### Example 2: Nested Query with Multiple Levels
```sql
-- Find students in departments with average GPA > 3.5
SELECT name, department, gpa
FROM Students
WHERE department IN (
    SELECT department
    FROM Students
    GROUP BY department
    HAVING AVG(gpa) > 3.5
)
ORDER BY gpa DESC;
```

### Example 3: INSERT with SELECT
```sql
-- Copy high-performing students to honors table
INSERT INTO Honors_Students (student_id, name, gpa)
SELECT student_id, name, gpa
FROM Students
WHERE gpa >= 3.8;
```

### Example 4: UPDATE with Subquery
```sql
-- Give 15% raise to employees in top-performing department
UPDATE Employees
SET salary = salary * 1.15
WHERE department = (
    SELECT department
    FROM Employees
    GROUP BY department
    ORDER BY AVG(salary) DESC
    LIMIT 1
);
```

---

## Best Practices

**1. Always use WHERE in UPDATE/DELETE**
```sql
-- Dangerous - updates ALL rows
UPDATE Employees SET salary = 50000;

-- Safe - updates specific rows
UPDATE Employees SET salary = 50000 WHERE emp_id = 101;
```

**2. Use LIMIT for testing queries**
```sql
-- Test query on small dataset first
SELECT * FROM large_table WHERE condition LIMIT 10;
```

**3. Use meaningful aliases**
```sql
-- Good
SELECT s.name AS student_name, e.course_name
FROM Students s
JOIN Enrollment e ON s.student_id = e.student_id;

-- Confusing
SELECT s.n, e.c
FROM Students s, Enrollment e;
```

**4. Order matters in nested queries**
```sql
-- Correlated subquery runs for EACH row (slow)
SELECT * FROM Students s
WHERE age > (SELECT AVG(age) FROM Students WHERE department = s.department);

-- Better: Join with pre-calculated averages
SELECT s.*
FROM Students s
JOIN (SELECT department, AVG(age) AS avg_age FROM Students GROUP BY department) d
ON s.department = d.department AND s.age > d.avg_age;
```

---

## Key Takeaways

1. **INSERT** - adds new rows
2. **UPDATE** - modifies existing rows (always use WHERE!)
3. **DELETE** - removes rows (always use WHERE!)
4. **SELECT** - retrieves data with multiple clauses
5. **Execution order:** FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
6. **WHERE** filters rows, **HAVING** filters groups
7. **Subqueries** can be in SELECT, FROM, WHERE clauses
8. **EXISTS** checks existence, **IN** checks membership
9. **Correlated subqueries** reference outer query
10. **Always test destructive queries** with SELECT first