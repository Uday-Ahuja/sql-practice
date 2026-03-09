# SQL Aggregate Functions

Functions that operate on a set of rows and return a single value — used for stats, reporting, and summarization.

> All aggregate functions ignore NULLs **except** `COUNT(*)`.

---

## Sample Table: Employees

```
emp_id | name    | department | salary | bonus
-------|---------|------------|--------|-------
1      | Uday    | IT         | 60000  | 5000
2      | Rahul   | IT         | 75000  | NULL
3      | Aman    | HR         | 50000  | 3000
4      | Neha    | HR         | 52000  | NULL
5      | Simran  | Finance    | 80000  | 10000
```

---

## Core Functions

### COUNT

```sql
COUNT(*)          -- all rows including NULLs
COUNT(column)     -- non-NULL values only
COUNT(DISTINCT c) -- unique non-NULL values
```

```sql
SELECT COUNT(*)    FROM Employees;  -- 5
SELECT COUNT(bonus) FROM Employees; -- 3  (Rahul, Neha are NULL)
SELECT COUNT(DISTINCT department) FROM Employees; -- 3
```

### SUM / AVG

```sql
SELECT SUM(salary) FROM Employees;  -- 317000
SELECT SUM(bonus)  FROM Employees;  -- 18000  (NULLs skipped)

SELECT AVG(salary) FROM Employees;  -- 63400
SELECT AVG(bonus)  FROM Employees;  -- 6000   (18000 / 3, not / 5)
```

AVG divides by the count of non-NULL rows — watch this when NULLs mean "zero".

```sql
-- Treat NULL bonus as 0
SELECT AVG(IFNULL(bonus, 0)) FROM Employees;  -- 3600
```

### MIN / MAX

```sql
SELECT MIN(salary) FROM Employees;  -- 50000
SELECT MAX(bonus)  FROM Employees;  -- 10000  (NULLs ignored)
```

Find the row, not just the value:
```sql
SELECT name, salary FROM Employees
WHERE salary = (SELECT MIN(salary) FROM Employees);
-- Aman | 50000
```

### GROUP_CONCAT *(MySQL)*

Concatenates values across rows into a single string.

```sql
SELECT GROUP_CONCAT(name ORDER BY salary DESC SEPARATOR ', ')
FROM Employees;
-- 'Simran, Rahul, Uday, Neha, Aman'

SELECT GROUP_CONCAT(DISTINCT department SEPARATOR ' | ')
FROM Employees;
-- 'IT | HR | Finance'
```

---

## GROUP BY

Groups rows by a column, then applies aggregates per group.

```sql
SELECT department, COUNT(*) AS headcount, AVG(salary) AS avg_sal
FROM Employees
GROUP BY department;
```

```
department | headcount | avg_sal
-----------|-----------|--------
IT         | 2         | 67500
HR         | 2         | 51000
Finance    | 1         | 80000
```

Multiple columns:
```sql
GROUP BY department, year  -- groups by each unique (dept, year) pair
```

---

## HAVING

Filters **groups** after aggregation. WHERE filters rows before grouping.

```sql
-- Departments with avg salary > 60k
SELECT department, AVG(salary) AS avg_sal
FROM Employees
GROUP BY department
HAVING AVG(salary) > 60000;
```

```
department | avg_sal
-----------|--------
IT         | 67500
Finance    | 80000
```

Using both:
```sql
SELECT department, COUNT(*) AS headcount, AVG(salary) AS avg_sal
FROM Employees
WHERE salary > 50000          -- row-level filter first
GROUP BY department
HAVING COUNT(*) > 1           -- group-level filter after
ORDER BY avg_sal DESC;
```

---

## Execution Order

```
FROM → WHERE → GROUP BY → aggregates → HAVING → SELECT → ORDER BY
```

This is why you can't use a column alias from SELECT in a HAVING clause on some DBs — HAVING runs before SELECT.

---

## Quick Reference

| Function | Returns | NULLs |
|----------|---------|-------|
| `COUNT(*)` | row count | included |
| `COUNT(col)` | non-null count | excluded |
| `SUM(col)` | total | excluded |
| `AVG(col)` | mean of non-nulls | excluded |
| `MIN(col)` | smallest value | excluded |
| `MAX(col)` | largest value | excluded |
| `GROUP_CONCAT(col)` | comma-joined string | excluded |

| Clause | Filters | When |
|--------|---------|------|
| `WHERE` | rows | before grouping |
| `HAVING` | groups | after aggregation |

---

## Common Mistakes

**Selecting a non-grouped, non-aggregated column**
```sql
-- WRONG
SELECT name, department, AVG(salary) FROM Employees GROUP BY department;

-- CORRECT
SELECT department, AVG(salary) FROM Employees GROUP BY department;
```

**Using WHERE on an aggregate**
```sql
-- WRONG
SELECT department, COUNT(*) FROM Employees WHERE COUNT(*) > 1 GROUP BY department;

-- CORRECT
SELECT department, COUNT(*) FROM Employees GROUP BY department HAVING COUNT(*) > 1;
```

**NULL trap with AVG**
```sql
AVG(bonus)           -- (5000+3000+10000)/3 = 6000  ← probably not what you want
AVG(IFNULL(bonus,0)) -- 18000/5 = 3600              ← treats NULL as no bonus
```