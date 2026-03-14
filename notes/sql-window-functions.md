# SQL Window Functions

Window functions operate over a set of rows **without collapsing them** — unlike `GROUP BY`, every row stays in the result.

---

## Syntax

```sql
function() OVER (
  PARTITION BY col   -- define groups (optional)
  ORDER BY col       -- order within each group
  ROWS/RANGE ...     -- frame clause (optional)
)
```

---

## Sample Table

```
new_id | new_cat
-------|--------
100    | Agni
200    | Agni
500    | Dharti
700    | Dharti
200    | Vayu
300    | Vayu
500    | Vayu
```

---

## Aggregate Window Functions

Same as regular aggregates but applied per-window, row stays intact.

```sql
SELECT new_id, new_cat,
  SUM(new_id)   OVER (PARTITION BY new_cat ORDER BY new_id) AS Total,
  AVG(new_id)   OVER (PARTITION BY new_cat ORDER BY new_id) AS Average,
  COUNT(new_id) OVER (PARTITION BY new_cat ORDER BY new_id) AS Count,
  MIN(new_id)   OVER (PARTITION BY new_cat ORDER BY new_id) AS Min,
  MAX(new_id)   OVER (PARTITION BY new_cat ORDER BY new_id) AS Max
FROM test_data;
```

```
new_id | new_cat | Total | Average   | Count | Min | Max
-------|---------|-------|-----------|-------|-----|----
100    | Agni    | 300   | 150       | 2     | 100 | 200
200    | Agni    | 300   | 150       | 2     | 100 | 200
500    | Dharti  | 1200  | 600       | 2     | 500 | 700
700    | Dharti  | 1200  | 600       | 2     | 500 | 700
200    | Vayu    | 1000  | 333.33    | 3     | 200 | 500
300    | Vayu    | 1000  | 333.33    | 3     | 200 | 500
500    | Vayu    | 1000  | 333.33    | 3     | 200 | 500
```

Each row keeps its identity — no collapsing like `GROUP BY` would do.

---

## Ranking Functions

### RANK()

Ties get the same rank, **next rank is skipped** (competition-style).

```sql
SELECT emp_name, salary,
  RANK() OVER (ORDER BY salary DESC) AS rnk
FROM employee;
```

```
scores:  95, 90, 90, 85
ranks:    1,  2,  2,  4   ← 3 is skipped
```

Use when: bonus cutoffs, leaderboards, scholarship seats — where "how many people are ahead of me" is the logic.

> Rank 4 means exactly 3 people scored higher. If you use `DENSE_RANK` here and give top-3 bonuses, rank 3 sneaks in incorrectly.

---

### DENSE_RANK()

Ties get the same rank, **no skipping**.

```sql
SELECT student, marks,
  DENSE_RANK() OVER (ORDER BY marks DESC) AS drnk
FROM students;
```

```
marks:  98, 95, 95, 90
ranks:   1,  2,  2,  3   ← no gap
```

Use when: grade tiers, salary bands, product pricing levels — clean sequential categories matter.

---

### ROW_NUMBER()

Unique number for every row, no ties.

```sql
SELECT customer_id, order_date,
  ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
FROM orders;
```

Use when: pick latest 1 row per group, remove duplicates, time-based sequencing.

```sql
-- Get most recent order per customer
SELECT * FROM (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
  FROM orders
) t WHERE rn = 1;
```

---

### PERCENT_RANK()

Returns relative rank as a percentage between 0 and 1.  
Formula: `(rank - 1) / (total rows - 1)`

```sql
SELECT emp_name, salary,
  PERCENT_RANK() OVER (ORDER BY salary DESC) AS pct_rank
FROM employee;
```

```
0.0  → highest
0.5  → middle
1.0  → lowest
```

Use when: top 10% bonuses, bottom 20% review, scholarship cutoffs, sales performance tiers.

---

## RANK vs DENSE_RANK vs ROW_NUMBER

| | Ties allowed | Skips ranks | Unique rows |
|---|---|---|---|
| `RANK()` | ✅ | ✅ | ❌ |
| `DENSE_RANK()` | ✅ | ❌ | ❌ |
| `ROW_NUMBER()` | — | — | ✅ |

---

## Quick Reference

| Function | Purpose |
|----------|---------|
| `RANK()` | Competition ranking, skips after tie |
| `DENSE_RANK()` | Tier ranking, no gaps |
| `ROW_NUMBER()` | Unique serial per row |
| `PERCENT_RANK()` | Relative position 0–1 |
| `SUM/AVG/COUNT/MIN/MAX` + `OVER()` | Aggregate without collapsing rows |
| `PARTITION BY` | Resets window per group |
| `ORDER BY` inside OVER | Defines order within window |

---

## Common Mistakes

**Using GROUP BY when you need window functions**
```sql
-- Wrong: collapses rows, lose individual data
SELECT dept, AVG(salary) FROM emp GROUP BY dept;

-- Correct: keeps all rows, adds avg per dept
SELECT emp_name, dept, AVG(salary) OVER (PARTITION BY dept) FROM emp;
```

**Forgetting PARTITION BY — function runs over entire table**
```sql
-- Ranks everyone together, not per department
RANK() OVER (ORDER BY salary DESC)

-- Ranks within each department
RANK() OVER (PARTITION BY dept ORDER BY salary DESC)
```