# SQL Analytic Functions

Analytic functions compute values across a window of rows. Unlike aggregates, they don't collapse rows. Unlike ranking functions, they return computed values rather than positions.

---

## LAG / LEAD

Access a value from a previous or next row without a self-join.

```sql
LAG(col, offset, default)   -- look back
LEAD(col, offset, default)  -- look ahead
```

```sql
SELECT emp_name, salary,
  LAG(salary, 1, 0)  OVER (ORDER BY salary) AS prev_salary,
  LEAD(salary, 1, 0) OVER (ORDER BY salary) AS next_salary
FROM employee;
```

```
emp_name | salary | prev_salary | next_salary
---------|--------|-------------|------------
Aman     | 30000  | 0           | 45000
Neha     | 45000  | 30000       | 60000
Ravi     | 60000  | 45000       | 0
```

Use when: month-over-month comparison, detect changes between rows, time-series analysis.

```sql
-- Find salary increase from previous employee
SELECT emp_name, salary,
  salary - LAG(salary) OVER (ORDER BY salary) AS increase
FROM employee;
```

---

## FIRST_VALUE / LAST_VALUE

Return the first or last value in the window frame.

```sql
SELECT emp_name, dept, salary,
  FIRST_VALUE(salary) OVER (PARTITION BY dept ORDER BY salary DESC) AS highest_in_dept,
  LAST_VALUE(salary)  OVER (
    PARTITION BY dept ORDER BY salary DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS lowest_in_dept
FROM employee;
```

> `LAST_VALUE` needs an explicit frame clause — by default the frame ends at the current row, so without it you get the current row's value, not the actual last.

---

## NTH_VALUE

Returns the value of the nth row in the window.

```sql
SELECT emp_name, salary,
  NTH_VALUE(salary, 2) OVER (ORDER BY salary DESC) AS second_highest
FROM employee;
```

---

## NTILE

Divides rows into n equal buckets and assigns a bucket number.

```sql
SELECT emp_name, salary,
  NTILE(4) OVER (ORDER BY salary DESC) AS quartile
FROM employee;
```

```
emp_name | salary | quartile
---------|--------|----------
Ravi     | 90000  | 1          ← top 25%
Neha     | 75000  | 1
Aman     | 60000  | 2
Priya    | 50000  | 2
...
```

Use when: quartile analysis, splitting into performance tiers, load distribution.

---

## CUME_DIST

Cumulative distribution — what fraction of rows have a value ≤ current row.  
Range: `(0, 1]` — always > 0, can be 1.

```sql
SELECT student, score,
  CUME_DIST() OVER (ORDER BY score) AS cum_dist
FROM marks;
```

```
student | score | cum_dist
--------|-------|----------
D       | 60    | 0.25
C       | 75    | 0.50
B       | 80    | 0.75
A       | 98    | 1.00
```

`CUME_DIST = 0.75` → 75% of students scored ≤ this score.

---

## PERCENT_RANK vs CUME_DIST

| | PERCENT_RANK | CUME_DIST |
|---|---|---|
| Range | `[0, 1]` | `(0, 1]` |
| First row | Always 0 | > 0 |
| Formula | `(rank-1)/(n-1)` | `rank/n` |
| Interpretation | Relative rank | Fraction ≤ current value |

```
scores:        60, 75, 80, 98
PERCENT_RANK:   0, 0.33, 0.67, 1.0
CUME_DIST:    0.25, 0.50, 0.75, 1.0
```

---

## Quick Reference

| Function | Purpose |
|----------|---------|
| `LAG(col, n)` | Value from n rows before |
| `LEAD(col, n)` | Value from n rows ahead |
| `FIRST_VALUE(col)` | First value in window frame |
| `LAST_VALUE(col)` | Last value in window frame (needs explicit frame) |
| `NTH_VALUE(col, n)` | nth value in window |
| `NTILE(n)` | Divide rows into n buckets |
| `CUME_DIST()` | Cumulative distribution (fraction ≤ current) |
| `PERCENT_RANK()` | Relative rank as 0–1 |

---

## Common Mistakes

**LAST_VALUE without frame clause**
```sql
-- Wrong: returns current row's value most of the time
LAST_VALUE(salary) OVER (ORDER BY salary DESC)

-- Correct: explicit unbounded frame
LAST_VALUE(salary) OVER (
  ORDER BY salary DESC
  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
```

**LAG/LEAD without default — returns NULL on boundary rows**
```sql
LAG(salary, 1)    -- first row returns NULL
LAG(salary, 1, 0) -- first row returns 0
```