use lib222;
-- 1. For each employee, calculate the percentage rank of their salary within their department.
SELECT 
    Empname,
    Lid AS Department,
    Salary,
    PERCENT_RANK() OVER (PARTITION BY Lid ORDER BY Salary DESC) AS pct_rank
FROM Employee;

-- 2. Show each employee's salary and the department median salary (simulate with window functions).
SELECT Empname, Lid AS Department, Salary,
    AVG(Salary) OVER (PARTITION BY Lid) AS avg_salary
FROM Employee;

-- 3. For each student, compute their percentage rank based on the number of books issued.
SELECT 
    s.Sname,
    COUNT(i.Issueid) AS books_issued,
    PERCENT_RANK() OVER (ORDER BY COUNT(i.Issueid) DESC) AS pct_rank
FROM Student s
LEFT JOIN Member m ON s.Memid = m.Memid
LEFT JOIN Issue i ON m.Memid = i.Memid
GROUP BY s.Stid, s.Sname;