**File 10 — sql-comparisons.md:**

---

# SQL Comparisons Cheat Sheet

Quick reference for commonly confused SQL concepts.

---

## DELETE vs TRUNCATE vs DROP

| | DELETE | TRUNCATE | DROP |
|---|---|---|---|
| What it does | Removes specific rows | Removes all rows | Removes entire table |
| WHERE clause | ✅ supported | ❌ | ❌ |
| Rollback | ✅ (DML, transactional) | ❌ (DDL, auto-commit) | ❌ (DDL) |
| Resets AUTO_INCREMENT | ❌ | ✅ | ✅ |
| Table structure stays | ✅ | ✅ | ❌ |
| Speed | Slower (logs each row) | Faster | Fastest |

```sql
DELETE FROM students WHERE id = 5;     -- removes one row
TRUNCATE TABLE students;               -- wipes all rows, keeps table
DROP TABLE students;                   -- table gone entirely
```

---

## CHAR vs VARCHAR

| | CHAR | VARCHAR |
|---|---|---|
| Length | Fixed | Variable |
| Storage | Always n bytes | Actual length + 1-2 bytes overhead |
| Padding | Pads with spaces | No padding |
| Speed | Slightly faster | Slightly slower |
| Use when | Fixed-length data | Variable-length data |

```sql
CHAR(10)     -- always stores 10 bytes, e.g. 'Hi' → 'Hi        '
VARCHAR(10)  -- stores only what's needed, e.g. 'Hi' → 'Hi'
```

Use `CHAR` for: country codes, gender flags, fixed IDs.  
Use `VARCHAR` for: names, emails, addresses.

---

## WHERE vs HAVING

| | WHERE | HAVING |
|---|---|---|
| Filters | Individual rows | Groups |
| Used with | Any query | GROUP BY |
| Aggregate functions | ❌ | ✅ |
| Executes | Before grouping | After grouping |

```sql
-- WHERE filters rows before grouping
SELECT dept, COUNT(*) FROM emp
WHERE salary > 30000
GROUP BY dept;

-- HAVING filters after grouping
SELECT dept, COUNT(*) FROM emp
GROUP BY dept
HAVING COUNT(*) > 5;
```

---

## GROUP BY vs PARTITION BY

| | GROUP BY | PARTITION BY |
|---|---|---|
| Collapses rows | ✅ | ❌ |
| Used with | Aggregate functions | Window functions |
| Returns | One row per group | All rows retained |

```sql
-- GROUP BY: one row per dept
SELECT dept, AVG(salary) FROM emp GROUP BY dept;

-- PARTITION BY: all rows, avg added as column
SELECT emp_name, dept, AVG(salary) OVER (PARTITION BY dept) FROM emp;
```

---

## UNION vs UNION ALL

| | UNION | UNION ALL |
|---|---|---|
| Duplicates | Removed | Kept |
| Speed | Slower (dedup step) | Faster |
| Use when | Need distinct results | Duplicates are fine |

```sql
SELECT name FROM students
UNION
SELECT name FROM alumni;      -- removes duplicates

SELECT name FROM students
UNION ALL
SELECT name FROM alumni;      -- keeps everything
```

---

## IN vs EXISTS

| | IN | EXISTS |
|---|---|---|
| Works on | Value list / subquery | Subquery only |
| Returns | Matches values | TRUE/FALSE per row |
| NULLs | Problematic (returns nothing) | Handled better |
| Performance | Better for small lists | Better for large subqueries |

```sql
-- IN
SELECT name FROM students WHERE dept IN ('CS', 'IT');

-- EXISTS
SELECT name FROM students s
WHERE EXISTS (
  SELECT 1 FROM enrollment e WHERE e.student_id = s.student_id
);
```

---

## RANK vs DENSE_RANK vs ROW_NUMBER

| | Ties | Skips | Unique |
|---|---|---|---|
| `RANK()` | ✅ | ✅ | ❌ |
| `DENSE_RANK()` | ✅ | ❌ | ❌ |
| `ROW_NUMBER()` | — | — | ✅ |

```
scores:        95, 90, 90, 85
RANK:           1,  2,  2,  4
DENSE_RANK:     1,  2,  2,  3
ROW_NUMBER:     1,  2,  3,  4
```

---

## PRIMARY KEY vs UNIQUE KEY vs FOREIGN KEY

| | PRIMARY KEY | UNIQUE KEY | FOREIGN KEY |
|---|---|---|---|
| Uniqueness | ✅ | ✅ | ❌ (references PK) |
| NULLs allowed | ❌ | ✅ (one NULL) | ✅ |
| Count per table | One | Multiple | Multiple |
| Purpose | Identify row | Prevent duplicates | Enforce relationship |

---

## ON vs WHERE (with JOINs)

```sql
-- ON: applied during join — keeps LEFT JOIN behavior
SELECT s.name, e.course
FROM students s
LEFT JOIN enrollment e
ON s.id = e.student_id AND e.course = 'DBMS';
-- students with no DBMS enrollment still appear, course = NULL

-- WHERE: applied after join — kills NULLs, becomes INNER JOIN
SELECT s.name, e.course
FROM students s
LEFT JOIN enrollment e ON s.id = e.student_id
WHERE e.course = 'DBMS';
-- students with no enrollment are filtered out
```

---

## PROCEDURE vs FUNCTION vs TRIGGER

| | Procedure | Function | Trigger |
|---|---|---|---|
| Returns value | Optional (OUT param) | ✅ mandatory | ❌ |
| Called explicitly | ✅ (`CALL`) | ✅ (in query) | ❌ (auto on event) |
| Used in SELECT | ❌ | ✅ | ❌ |
| DML inside | ✅ | ❌ (MySQL) | ✅ |
| Use when | Multi-step logic | Computation/reuse | Auto-action on insert/update/delete |

---