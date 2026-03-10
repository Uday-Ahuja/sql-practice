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

> student_id 5 doesn't exist in Students. Charlie and Diana have no enrollments.

---

## INNER JOIN

Returns rows with a match in **both** tables.

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

Charlie, Diana (no enrollment) and enrollment 104 (no student) are excluded.

---

## LEFT JOIN

All rows from the left table + matching rows from the right. Unmatched right-side → NULL.

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

**Find rows with no match:**
```sql
SELECT s.name
FROM Students s
LEFT JOIN Enrollment e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;
-- Returns: Charlie, Diana
```

---

## RIGHT JOIN

Mirror of LEFT JOIN — all rows from the right table, NULLs for unmatched left side.  
Rarely needed; you can always rewrite as a LEFT JOIN by swapping table order.

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

**MySQL doesn't support FULL OUTER JOIN** — simulate with UNION:
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

Useful for generating all combinations (product-size pairs, test data). Avoid on large tables — 1000 × 1000 = 1,000,000 rows.

---

## SELF JOIN

A table joined with itself. Classic use case: hierarchical/parent-child data.

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

## EQUI JOIN

A join where the condition uses `=` (equality). Not a separate keyword — it's just INNER JOIN (or any join) with an `=` in the ON clause. Most joins you write are equi-joins.

```sql
SELECT s.name, e.course_name
FROM Students s
JOIN Enrollment e ON s.student_id = e.student_id;
--                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ equality condition → equi-join
```

The opposite is a **non-equi join**, where you use `<`, `>`, `BETWEEN`, etc.:
```sql
-- non-equi join example
SELECT e.name, s.grade
FROM Employees e
JOIN SalaryGrade s ON e.salary BETWEEN s.low_sal AND s.high_sal;
```

---

## NATURAL JOIN

Automatically joins on **all columns with the same name** in both tables. No ON clause needed.

```sql
SELECT name, course_name
FROM Students
NATURAL JOIN Enrollment;
```

Equivalent to:
```sql
SELECT s.name, e.course_name
FROM Students s
JOIN Enrollment e ON s.student_id = e.student_id;
```

> **Avoid in production.** If someone adds a column with a matching name later, the join condition silently changes. Fine for quick queries, risky in real schemas.

---

## Quick Reference

| Join | What it returns |
|------|-----------------|
| INNER | Matched rows only |
| LEFT | All of left + matches from right (NULL if no match) |
| RIGHT | All of right + matches from left (NULL if no match) |
| FULL | Everything from both (NULL where no match) |
| CROSS | Every possible combination (cartesian product) |
| SELF | Table joined to itself |
| EQUI | Any join using `=` as the condition |
| NATURAL | Auto-joins on columns with identical names (no ON clause) |

**When to use which:**  
INNER → only care about matched data  
LEFT → need all rows from the primary/driving table  
RIGHT → rarely; prefer rewriting as LEFT JOIN  
FULL → detect mismatches on both sides  
CROSS → generate all combinations  
SELF → hierarchical data, within-table comparisons  
EQUI → default for most joins  
NATURAL → avoid in production schemas  

---

## Common Mistakes

**1. Accidental CROSS JOIN — forgetting the ON clause**
```sql
-- Wrong
SELECT * FROM Students, Enrollment;

-- Correct
SELECT * FROM Students s
INNER JOIN Enrollment e ON s.student_id = e.student_id;
```

**2. WHERE instead of ON with LEFT JOIN — collapses it into an INNER JOIN**
```sql
-- Wrong: NULLs get filtered out
LEFT JOIN Enrollment e ON s.student_id = e.student_id
WHERE e.course_name = 'DBMS';

-- Correct: filter inside ON
LEFT JOIN Enrollment e
ON s.student_id = e.student_id AND e.course_name = 'DBMS';
```

**3. Ambiguous column names — always alias your tables**
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
- INNER JOIN is generally faster than OUTER JOINs — only use LEFT/RIGHT/FULL when you actually need unmatched rows
- Filter early with WHERE to reduce rows before the join