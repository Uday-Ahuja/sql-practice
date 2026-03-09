# SQL DDL (Data Definition Language)

## What is DDL?

**DDL (Data Definition Language)** - Commands used to define and modify database structure (schema).

**Key Characteristic:** DDL commands are **auto-committed** - changes are permanent and cannot be rolled back.

---

## DDL Commands Overview

| Command | Purpose | Auto-Commit |
|---------|---------|-------------|
| **CREATE** | Create database, tables, indexes | Yes |
| **ALTER** | Modify existing table structure | Yes |
| **DROP** | Delete database or table permanently | Yes |
| **TRUNCATE** | Remove all rows, keep structure | Yes |
| **RENAME** | Rename table or column | Yes |

---

## 1. CREATE Command

### CREATE DATABASE

Creates a new database.

**Syntax:**
```sql
CREATE DATABASE database_name;
```

**Examples:**
```sql
-- Create database
CREATE DATABASE company;

-- Create if not exists (avoids error)
CREATE DATABASE IF NOT EXISTS company;

-- Use the database
USE company;
```

---

### CREATE TABLE

Creates a new table with columns and constraints.

**Basic Syntax:**
```sql
CREATE TABLE table_name (
    column1 datatype constraints,
    column2 datatype constraints,
    ...
    table_constraints
);
```

**Example 1: Simple Table**
```sql
CREATE TABLE Students (
    student_id INT,
    name VARCHAR(100),
    age INT,
    email VARCHAR(100)
);
```

**Example 2: Table with Constraints**
```sql
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    salary DECIMAL(10,2) CHECK (salary >= 10000),
    department VARCHAR(50) DEFAULT 'General',
    hire_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);
```

**Example 3: Table with Foreign Key**
```sql
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
```

**Example 4: Composite Primary Key**
```sql
CREATE TABLE Enrollment (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
```

---

## Common Constraints

### 1. PRIMARY KEY
- Uniquely identifies each row
- Cannot be NULL
- Only one primary key per table
```sql
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);
```

### 2. FOREIGN KEY
- Links two tables together
- Maintains referential integrity
- Value must exist in referenced table or be NULL
```sql
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
```

### 3. UNIQUE
- Ensures all values in column are distinct
- Can have multiple UNIQUE constraints per table
- Allows NULL values (unlike PRIMARY KEY)
```sql
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15) UNIQUE
);
```

### 4. NOT NULL
- Column cannot contain NULL values
- Must provide value during INSERT
```sql
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);
```

### 5. DEFAULT
- Provides default value if none specified
```sql
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    stock_quantity INT DEFAULT 0,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 6. CHECK
- Validates data based on condition
- Ensures data integrity
```sql
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    age INT CHECK (age >= 18),
    salary DECIMAL(10,2) CHECK (salary >= 15000),
    email VARCHAR(100) CHECK (email LIKE '%@%.%')
);
```

### 7. AUTO_INCREMENT
- Automatically generates unique values
- Typically used for primary keys
```sql
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);
```

---

## 2. ALTER Command

Modifies existing table structure.

### ADD Column
```sql
-- Add single column
ALTER TABLE Employees
ADD address VARCHAR(200);

-- Add column with constraint
ALTER TABLE Employees
ADD date_of_birth DATE NOT NULL;

-- Add multiple columns
ALTER TABLE Employees
ADD city VARCHAR(50),
ADD state VARCHAR(50),
ADD pincode VARCHAR(10);
```

### MODIFY Column
```sql
-- Change data type
ALTER TABLE Employees
MODIFY salary DECIMAL(12,2);

-- Add constraint to existing column
ALTER TABLE Employees
MODIFY email VARCHAR(100) NOT NULL UNIQUE;

-- Change data type and add constraint
ALTER TABLE Employees
MODIFY phone VARCHAR(15) NOT NULL;
```

### CHANGE Column (Rename + Modify)
```sql
-- Rename column and change data type
ALTER TABLE Employees
CHANGE phone mobile_number VARCHAR(15);

-- Just rename (keep same data type)
ALTER TABLE Employees
CHANGE emp_name employee_name VARCHAR(100);
```

### DROP Column
```sql
-- Remove single column
ALTER TABLE Employees
DROP COLUMN address;

-- Remove multiple columns (MySQL specific)
ALTER TABLE Employees
DROP COLUMN city,
DROP COLUMN state;
```

### ADD Constraint
```sql
-- Add primary key
ALTER TABLE Students
ADD PRIMARY KEY (student_id);

-- Add foreign key
ALTER TABLE Orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id);

-- Add unique constraint
ALTER TABLE Employees
ADD UNIQUE (email);

-- Add check constraint
ALTER TABLE Products
ADD CHECK (price > 0);
```

### DROP Constraint
```sql
-- Drop foreign key
ALTER TABLE Orders
DROP FOREIGN KEY fk_customer;

-- Drop primary key
ALTER TABLE Students
DROP PRIMARY KEY;

-- Drop unique constraint (by index name)
ALTER TABLE Employees
DROP INDEX email;
```

### RENAME Table
```sql
-- Method 1
ALTER TABLE old_table_name
RENAME TO new_table_name;

-- Method 2
RENAME TABLE old_table_name TO new_table_name;

-- Rename multiple tables
RENAME TABLE 
    employees TO staff,
    departments TO divisions;
```

---

## 3. DROP Command

Permanently deletes database objects.

### DROP DATABASE
```sql
-- Delete database
DROP DATABASE company;

-- Delete if exists (avoids error)
DROP DATABASE IF EXISTS company;
```

### DROP TABLE
```sql
-- Delete table
DROP TABLE Employees;

-- Delete if exists
DROP TABLE IF EXISTS Employees;

-- Delete multiple tables
DROP TABLE Employees, Departments, Orders;
```

**⚠️ Warning:**
- Deletes table structure AND all data
- Cannot be undone (no rollback)
- Removes all indexes, triggers, constraints

---

## 4. TRUNCATE Command

Removes all rows from table but keeps structure.

**Syntax:**
```sql
TRUNCATE TABLE table_name;
```

**Examples:**
```sql
-- Remove all data from Orders table
TRUNCATE TABLE Orders;

-- Table structure remains, all rows deleted
TRUNCATE TABLE Employees;
```

**Characteristics:**
- Faster than DELETE (no row-by-row deletion)
- Resets AUTO_INCREMENT counter to 1
- Cannot use WHERE clause
- Cannot be rolled back (DDL command)
- Removes all rows at once

---

## Practical Examples

### Example 1: Complete Database Setup
```sql
-- Create database
CREATE DATABASE university;
USE university;

-- Create Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    date_of_birth DATE,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    gpa DECIMAL(3,2) CHECK (gpa >= 0 AND gpa <= 4.0)
);

-- Create Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    credits INT CHECK (credits > 0),
    department VARCHAR(50)
);

-- Create Enrollment table (many-to-many)
CREATE TABLE Enrollment (
    student_id INT,
    course_id INT,
    semester VARCHAR(20),
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id, semester),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
```

### Example 2: Modifying Existing Tables
```sql
-- Add new column
ALTER TABLE Students
ADD address TEXT;

-- Modify existing column
ALTER TABLE Students
MODIFY phone VARCHAR(15) NOT NULL;

-- Add foreign key for advisor
ALTER TABLE Students
ADD advisor_id INT,
ADD CONSTRAINT fk_advisor
FOREIGN KEY (advisor_id) REFERENCES Faculty(faculty_id);

-- Rename column
ALTER TABLE Students
CHANGE date_of_birth dob DATE;

-- Drop column
ALTER TABLE Students
DROP COLUMN address;
```

### Example 3: Table Maintenance
```sql
-- Remove all enrollment records for completed semester
TRUNCATE TABLE Enrollment;

-- Delete old test table
DROP TABLE IF EXISTS temp_students;

-- Rename table
RENAME TABLE Enrollment TO Course_Registration;
```

---

## Best Practices

**1. Always use IF EXISTS / IF NOT EXISTS**
```sql
CREATE DATABASE IF NOT EXISTS mydb;
DROP TABLE IF EXISTS old_table;
```
Avoids errors when object already exists or doesn't exist.

**2. Use descriptive constraint names**
```sql
ALTER TABLE Orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id);
```
Easier to identify and manage later.

**3. Define constraints during CREATE TABLE when possible**
```sql
-- Good
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Less preferred (adding constraint later)
CREATE TABLE Orders (order_id INT, customer_id INT);
ALTER TABLE Orders ADD PRIMARY KEY (order_id);
```

**4. Use appropriate data types**
```sql
-- Good
age TINYINT          -- 0-255, sufficient for age
price DECIMAL(10,2)  -- Exact precision for money

-- Wasteful
age INT              -- -2B to 2B, unnecessary
price FLOAT          -- Rounding errors for currency
```

**5. Add indexes for frequently queried columns**
```sql
CREATE INDEX idx_email ON Users(email);
CREATE INDEX idx_order_date ON Orders(order_date);
```

**6. Backup before DROP/TRUNCATE**
```sql
-- These are irreversible!
DROP TABLE Employees;     -- No undo
TRUNCATE TABLE Orders;    -- No rollback
```

---

## Key Takeaways

1. **CREATE** - defines new database objects (database, table)
2. **ALTER** - modifies existing table structure (add, modify, drop columns/constraints)
3. **DROP** - permanently deletes database objects (cannot undo)
4. **TRUNCATE** - removes all data, keeps structure (faster than DELETE)
5. **All DDL commands auto-commit** - changes are immediate and permanent
6. **Use constraints** to maintain data integrity
7. **Plan schema carefully** - ALTER operations can be complex on large tables