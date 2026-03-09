# SQL Operators and Predicates

## What are Operators?

**Operators** - symbols or keywords used to perform operations on data in SQL queries.

Used primarily in **WHERE** clause to filter data.

---

## Types of Operators

### 1. Comparison Operators

Compare two values and return TRUE or FALSE.

| Operator | Description | Example |
|----------|-------------|---------|
| `=` | Equal to | `age = 20` |
| `!=` or `<>` | Not equal to | `status != 'active'` |
| `>` | Greater than | `salary > 50000` |
| `<` | Less than | `age < 18` |
| `>=` | Greater than or equal to | `marks >= 40` |
| `<=` | Less than or equal to | `price <= 1000` |

**Examples:**
```sql
-- Students aged exactly 20
SELECT * FROM Students WHERE age = 20;

-- Products costing more than 500
SELECT * FROM Products WHERE price > 500;

-- Orders placed before 2024
SELECT * FROM Orders WHERE order_date < '2024-01-01';

-- Employees with salary at least 30000
SELECT * FROM Employees WHERE salary >= 30000;
```

---

### 2. Logical Operators

Combine multiple conditions.

#### AND - All conditions must be TRUE
```sql
-- Students in CS department AND age > 20
SELECT * FROM Students 
WHERE department = 'CS' AND age > 20;

-- Products between 100 and 500
SELECT * FROM Products 
WHERE price >= 100 AND price <= 500;

-- Three conditions
SELECT * FROM Employees 
WHERE department = 'IT' AND salary > 50000 AND is_active = TRUE;
```

#### OR - At least one condition must be TRUE
```sql
-- Students in CS OR IT department
SELECT * FROM Students 
WHERE department = 'CS' OR department = 'IT';

-- Age less than 18 OR greater than 60
SELECT * FROM Customers 
WHERE age < 18 OR age > 60;

-- Multiple OR conditions
SELECT * FROM Products 
WHERE category = 'Electronics' OR category = 'Books' OR category = 'Toys';
```

#### NOT - Negates a condition
```sql
-- Students NOT in CS department
SELECT * FROM Students 
WHERE NOT department = 'CS';
-- Or equivalently:
SELECT * FROM Students 
WHERE department != 'CS';

-- Products NOT available
SELECT * FROM Products 
WHERE NOT is_available;
-- Or:
SELECT * FROM Products 
WHERE is_available = FALSE;
```

#### Combining AND/OR with Parentheses
```sql
-- (CS students older than 20) OR (IT students older than 22)
SELECT * FROM Students 
WHERE (department = 'CS' AND age > 20) OR (department = 'IT' AND age > 22);

-- NOT in CS department but either age < 18 or age > 25
SELECT * FROM Students 
WHERE NOT department = 'CS' AND (age < 18 OR age > 25);
```

---

### 3. BETWEEN Operator

Checks if value is within a range (inclusive).

**Syntax:**
```sql
column BETWEEN value1 AND value2
```
Equivalent to: `column >= value1 AND column <= value2`

**Examples:**
```sql
-- Students aged between 18 and 25 (inclusive)
SELECT * FROM Students 
WHERE age BETWEEN 18 AND 25;

-- Products priced between 100 and 1000
SELECT * FROM Products 
WHERE price BETWEEN 100 AND 1000;

-- Orders placed in January 2024
SELECT * FROM Orders 
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31';

-- NOT BETWEEN
SELECT * FROM Students 
WHERE age NOT BETWEEN 18 AND 25;
```

---

### 4. IN Operator

Checks if value matches any value in a list.

**Syntax:**
```sql
column IN (value1, value2, value3, ...)
```

**Examples:**
```sql
-- Students in CS, IT, or ECE departments
SELECT * FROM Students 
WHERE department IN ('CS', 'IT', 'ECE');

-- Orders from specific cities
SELECT * FROM Orders 
WHERE city IN ('Mumbai', 'Delhi', 'Bangalore', 'Pune');

-- Products with specific IDs
SELECT * FROM Products 
WHERE product_id IN (101, 205, 310, 420);

-- NOT IN
SELECT * FROM Students 
WHERE department NOT IN ('CS', 'IT');
```

**IN with Subquery:**
```sql
-- Students who have issued books
SELECT * FROM Students 
WHERE student_id IN (SELECT student_id FROM Issue);

-- Products never ordered
SELECT * FROM Products 
WHERE product_id NOT IN (SELECT product_id FROM Orders);
```

---

### 5. LIKE Operator

Pattern matching for strings.

**Wildcards:**
- `%` - Matches zero or more characters
- `_` - Matches exactly one character

**Syntax:**
```sql
column LIKE 'pattern'
```

**Examples:**

**Using % (zero or more characters):**
```sql
-- Names starting with 'A'
SELECT * FROM Students WHERE name LIKE 'A%';

-- Names ending with 'a'
SELECT * FROM Students WHERE name LIKE '%a';

-- Names containing 'kumar'
SELECT * FROM Students WHERE name LIKE '%kumar%';

-- Email addresses from gmail
SELECT * FROM Users WHERE email LIKE '%@gmail.com';
```

**Using _ (exactly one character):**
```sql
-- Exactly 4-letter names
SELECT * FROM Students WHERE name LIKE '____';

-- Names starting with 'A' and exactly 5 letters
SELECT * FROM Students WHERE name LIKE 'A____';

-- Phone numbers with pattern: 98765-____
SELECT * FROM Contacts WHERE phone LIKE '98765-____';
```

**Combining % and _:**
```sql
-- Names starting with 'S', any character, then 'n'
SELECT * FROM Students WHERE name LIKE 'S_n%';
-- Matches: Sanjay, Sunny, Sandeep, etc.
```

**NOT LIKE:**
```sql
-- Names NOT starting with 'A'
SELECT * FROM Students WHERE name NOT LIKE 'A%';

-- Emails NOT from gmail
SELECT * FROM Users WHERE email NOT LIKE '%@gmail.com';
```

**Case Sensitivity:**
```sql
-- Case-insensitive search (MySQL default)
SELECT * FROM Students WHERE name LIKE 'john%';
-- Matches: John, JOHN, john, JoHn

-- Force case-sensitive (using BINARY)
SELECT * FROM Students WHERE name LIKE BINARY 'John%';
-- Matches only: John, Johnny (not JOHN, john)
```

---

### 6. IS NULL / IS NOT NULL

Checks for NULL values.

**Important:** Cannot use `= NULL` or `!= NULL`

**Syntax:**
```sql
column IS NULL
column IS NOT NULL
```

**Examples:**
```sql
-- Students with no email
SELECT * FROM Students WHERE email IS NULL;

-- Products with price defined
SELECT * FROM Products WHERE price IS NOT NULL;

-- Employees with no bonus
SELECT * FROM Employees WHERE bonus IS NULL;

-- Orders with return date (returned orders)
SELECT * FROM Orders WHERE return_date IS NOT NULL;
```

**Common Mistakes:**
```sql
-- WRONG - doesn't work
SELECT * FROM Students WHERE email = NULL;

-- CORRECT
SELECT * FROM Students WHERE email IS NULL;
```

---

### 7. Arithmetic Operators

Perform calculations.

| Operator | Operation | Example |
|----------|-----------|---------|
| `+` | Addition | `salary + bonus` |
| `-` | Subtraction | `price - discount` |
| `*` | Multiplication | `quantity * unit_price` |
| `/` | Division | `total / count` |
| `%` (MOD) | Modulo (remainder) | `number % 2` |

**Examples:**
```sql
-- Calculate total salary (salary + bonus)
SELECT name, salary, bonus, (salary + bonus) AS total_salary
FROM Employees;

-- Calculate discounted price
SELECT product_name, price, (price * 0.9) AS discounted_price
FROM Products;

-- Calculate age from birth year
SELECT name, (2025 - birth_year) AS age
FROM Students;

-- Find even student IDs
SELECT * FROM Students WHERE student_id % 2 = 0;

-- Calculate average price
SELECT SUM(price) / COUNT(*) AS avg_price FROM Products;
```

---

## WHERE Clause in Detail

The WHERE clause filters rows based on conditions.

### Basic Usage
```sql
SELECT column1, column2
FROM table_name
WHERE condition;
```

### Multiple Conditions
```sql
-- AND - all conditions must be true
SELECT * FROM Products 
WHERE category = 'Electronics' AND price < 50000 AND stock > 0;

-- OR - at least one condition must be true
SELECT * FROM Students 
WHERE department = 'CS' OR department = 'IT' OR department = 'ECE';

-- Combining AND/OR
SELECT * FROM Employees 
WHERE (department = 'Sales' AND salary > 40000) 
   OR (department = 'Marketing' AND salary > 50000);
```

### Complex WHERE Conditions
```sql
-- Multiple operators combined
SELECT * FROM Products
WHERE category IN ('Electronics', 'Books')
  AND price BETWEEN 500 AND 5000
  AND product_name LIKE '%Pro%'
  AND stock IS NOT NULL
  AND is_available = TRUE;
```

### WHERE with Subqueries
```sql
-- Students in departments with > 50 students
SELECT * FROM Students
WHERE department IN (
    SELECT department 
    FROM Students 
    GROUP BY department 
    HAVING COUNT(*) > 50
);

-- Employees earning more than average
SELECT * FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);
```

---

## Practical Examples

### Example 1: Find Active High-Value Customers
```sql
SELECT customer_name, total_purchases, city
FROM Customers
WHERE is_active = TRUE
  AND total_purchases > 100000
  AND city IN ('Mumbai', 'Delhi', 'Bangalore')
  AND registration_date >= '2023-01-01'
ORDER BY total_purchases DESC;
```

### Example 2: Search Products
```sql
SELECT product_name, price, category
FROM Products
WHERE (category = 'Electronics' OR category = 'Accessories')
  AND price BETWEEN 1000 AND 50000
  AND (product_name LIKE '%phone%' OR product_name LIKE '%charger%')
  AND stock > 0
  AND discount IS NOT NULL;
```

### Example 3: Filter Students
```sql
SELECT name, department, gpa, email
FROM Students
WHERE department IN ('CS', 'IT', 'ECE')
  AND gpa >= 3.5
  AND email IS NOT NULL
  AND (name LIKE 'A%' OR name LIKE 'S%')
ORDER BY gpa DESC
LIMIT 10;
```

### Example 4: Find Overdue Orders
```sql
SELECT order_id, customer_name, order_date, due_date
FROM Orders
WHERE return_date IS NULL
  AND due_date < CURRENT_DATE
  AND amount > 5000
ORDER BY due_date ASC;
```

---

## Operator Precedence

When multiple operators are used, SQL evaluates them in this order:

1. **Parentheses** `()`
2. **Arithmetic** `*, /, %` then `+, -`
3. **Comparison** `=, !=, <, >, <=, >=`
4. **NOT**
5. **AND**
6. **OR**

**Example:**
```sql
SELECT * FROM Students 
WHERE department = 'CS' OR department = 'IT' AND age > 20;

-- Evaluates as:
WHERE department = 'CS' OR (department = 'IT' AND age > 20)

-- Use parentheses for clarity:
WHERE (department = 'CS' OR department = 'IT') AND age > 20;
```

---

## Best Practices

**1. Use BETWEEN for ranges**
```sql
-- Good
WHERE age BETWEEN 18 AND 25

-- Less readable
WHERE age >= 18 AND age <= 25
```

**2. Use IN for multiple values**
```sql
-- Good
WHERE city IN ('Mumbai', 'Delhi', 'Pune')

-- Verbose
WHERE city = 'Mumbai' OR city = 'Delhi' OR city = 'Pune'
```

**3. Use IS NULL, not = NULL**
```sql
-- Correct
WHERE email IS NULL

-- Wrong - doesn't work
WHERE email = NULL
```

**4. Use parentheses for complex conditions**
```sql
-- Clear intent
WHERE (dept = 'CS' AND age > 20) OR (dept = 'IT' AND age > 22)

-- Ambiguous
WHERE dept = 'CS' AND age > 20 OR dept = 'IT' AND age > 22
```

**5. LIKE can be slow - use sparingly**
```sql
-- Slow (full table scan)
WHERE name LIKE '%john%'

-- Faster (can use index)
WHERE name LIKE 'john%'
```

---

## Key Takeaways

1. **Comparison operators** - `=, !=, <, >, <=, >=`
2. **Logical operators** - `AND, OR, NOT`
3. **BETWEEN** - inclusive range check
4. **IN** - check against list of values
5. **LIKE** - pattern matching with `%` and `_`
6. **IS NULL** - check for NULL values (never use `= NULL`)
7. **WHERE clause** - filters rows before processing
8. **Operator precedence** - use parentheses for clarity
9. **Combine operators** for complex filtering logic