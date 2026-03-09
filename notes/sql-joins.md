# SQL Joins

Joins combine rows from multiple tables using a related column.
---

## Sample Tables

**Students**
```
student_id | name    | department
-----------|---------|------------
1          | Alice   | CS
2          | Bob     | IT
3          | Charlie | CS
4          | Diana   | NULL
```

**Enrollment**
```
enrollment_id | student_id | course_name
--------------|------------|-------------
101           | 1          | DBMS
102           | 2          | OS
103           | 1          | DSA
104           | 5          | Networks
```

> Note: student_id 5 doesn't exist in Students. Charlie and Diana have no enrollments.

---

## INNER JOIN

Returns only rows with a match in **both** tables.

```sql
SELECT s.name, e.course_name
FROM Students s
INNER JOIN Enrollment e ON s.student_id = e.student_id;
```

```
name  | course_name
------|-------------
Alice | DBMS
Alice | DSA
Bob   | OS
```

Charlie, Diana (no enrollment) and enrollment 104 (no student) are all excluded.

---

## LEFT JOIN

Returns **all rows from the left table** + matching rows from the right. Unmatched right-side columns come back as NULL.

```sql
SELECT s.name, e.course_name
FROM Students s
LEFT JOIN Enrollment e ON s.student_id = e.student_id;
```

```
name    | course_name
--------|-------------
Alice   | DBMS
Alice   | DSA
Bob     | OS
Charlie | NULL
Diana   | NULL
```

**Common use — find rows with no match:**
```sql
SELECT s.name
FROM Students s
LEFT JOIN Enrollment e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;
-- Returns Charlie, Diana
```

---

## RIGHT JOIN

Mirror of LEFT JOIN — all rows from the **right table**, NULLs for unmatched left side. Rarely needed; you can always rewrite it as a LEFT JOIN by swapping table order.

```sql
SELECT s.name, e.course_name
FROM Students s
RIGHT JOIN Enrollment e ON s.student_id = e.student_id;
```

```
name  | course_name
------|-------------
Alice | DBMS
Alice | DSA
Bob   | OS
NULL  | Networks
```

---

## FULL OUTER JOIN

All rows from both tables, NULLs wherever there's no match on either side.

```sql
SELECT s.name, e.course_name
FROM Students s
FULL OUTER JOIN Enrollment e ON s.student_id = e.student_id;
```

```
name    | course_name
--------|-------------
Alice   | DBMS
Alice   | DSA
Bob     | OS
Charlie | NULL
Diana   | NULL
NULL    | Networks
```

**MySQL doesn't support FULL OUTER JOIN** — simulate it with UNION:
```sql
SELECT s.name, e.course_name FROM Students s
LEFT JOIN Enrollment e ON s.student_id = e.student_id
UNION
SELECT s.name, e.course_name FROM Students s
RIGHT JOIN Enrollment e ON s.student_id = e.student_id;
```

---

## CROSS JOIN

Cartesian product — every row from table A paired with every row from table B.

```sql
SELECT s.name, c.course_name
FROM Students s
CROSS JOIN Courses c;
-- 4 students × 5 courses = 20 rows
```

Use cases: generating all combinations (e.g. product-size pairs, test data). Avoid on large tables — 1000 × 1000 = 1,000,000 rows.

---

## SELF JOIN

A table joined with itself. Useful for hierarchical data.

**Employees**
```
emp_id | name    | manager_id
-------|---------|------------
1      | Alice   | NULL
2      | Bob     | 1
3      | Charlie | 1
4      | Diana   | 2
```

```sql
SELECT e.name AS employee, m.name AS manager
FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.emp_id;
```

```
employee | manager
---------|--------
Alice    | NULL
Bob      | Alice
Charlie  | Alice
Diana    | Bob
```

---

## Quick Reference

| Join | What it returns |
|------|-----------------|
| INNER | Matched rows only |
| LEFT | All of left + matches from right (NULL if no match) |
| RIGHT | All of right + matches from left (NULL if no match) |
| FULL | Everything from both (NULL where no match) |
| CROSS | Every possible combination |
| SELF | Table joined to itself |

### When to use which

INNER JOIN → when you only care about matched data  
LEFT JOIN → when you need all rows from the primary table  
RIGHT JOIN → rarely used (prefer rewriting as LEFT JOIN)  
FULL JOIN → when you want to detect mismatches on both sides
---

## Common Mistakes

**1. Accidental CROSS JOIN** — forgetting the ON clause
```sql
-- Wrong: produces cartesian product
SELECT * FROM Students, Enrollment;

-- Correct
SELECT * FROM Students s
INNER JOIN Enrollment e ON s.student_id = e.student_id;
```

**2. WHERE instead of ON with LEFT JOIN** — collapses it into an INNER JOIN
```sql
-- Wrong: filters out NULLs, defeating the LEFT JOIN
LEFT JOIN Enrollment e ON s.student_id = e.student_id
WHERE e.course_name = 'DBMS';

-- Correct: move the filter into the ON clause
LEFT JOIN Enrollment e
ON s.student_id = e.student_id AND e.course_name = 'DBMS';
```

**3. Ambiguous column names** — always alias your tables
```sql
-- Wrong
SELECT student_id FROM Students JOIN Enrollment ON student_id = student_id;

-- Correct
SELECT s.student_id FROM Students s
JOIN Enrollment e ON s.student_id = e.student_id;
```

---

## Performance Tips

- Index your join columns (foreign keys especially)
- INNER JOIN is generally faster than OUTER JOINs — only use LEFT/RIGHT when you actually need unmatched rows
- Filter early with WHERE to reduce rows before the join