use lib222;
-- 1. Students in the IT department.
select s.Stid, s.Sname,s.Email,d.Deptname
from Student s 
join Department d on s.Deptid = d.Deptid
where Deptname='IT';

-- 2. Books in SIT library.
select b.Bname, b.Price from Books b
join Library l on b.Lid=l.Lid
where Lname="SITLib";

-- 3. Books with less than 3 copies in SIT Library.
select b.Bname, b.Price from Books b
join Library l on b.Lid=l.Lid
join Noofcopies n on b.Bid=n.Bid
where l.Lname="SITLib"
group by b.Bid,b.Bname
having sum(n.available_copies)<3 ;

-- 4. Sellers in the same city as SIT.
SELECT Slname, City
FROM Seller
WHERE City = (SELECT City FROM Library WHERE Lname = 'SITLib');

-- 5. Sellers selling books to SIT.
SELECT DISTINCT s.Slname, s.City
FROM Seller s
JOIN Purchase p ON s.Sid = p.Sid
JOIN Library l ON p.Lid = l.Lid
WHERE l.Lname = 'SITLib';

-- 6. Books authored by Brian Kernighan, and published by Tata McGraw Hill.
SELECT b.Bname, b.Price
FROM Books b
JOIN Writes w ON b.Bid = w.Bid
JOIN Author a ON w.Aid = a.Aid
JOIN Publisher p ON w.Pid = p.Pid
WHERE a.Aname = 'Brian Kernighan' 
AND p.Pname LIKE '%Macgraw%';

-- 7. Books authored by Ken Thompson.
SELECT b.Bname, b.Price
FROM Books b
JOIN Writes w ON b.Bid = w.Bid
JOIN Author a ON w.Aid = a.Aid
WHERE a.Aname = 'Ken Thompson';

-- 8. Books issued by Mayank.
SELECT b.Bname, i.Issuedate, i.Returndate
FROM Issue i
JOIN Books b ON i.Bid = b.Bid
JOIN Member m ON i.Memid = m.Memid
LEFT JOIN Student st ON m.Memid = st.Memid
LEFT JOIN Staff sta ON m.Memid = sta.Memid
WHERE st.Sname = 'Mayank' OR sta.Stname = 'Mayank';

-- 9. Books issued by SLS staff.
SELECT b.Bname, i.Issuedate
FROM Issue i
JOIN Books b ON i.Bid = b.Bid
JOIN Member m ON i.Memid = m.Memid
JOIN Staff sta ON m.Memid = sta.Memid
JOIN Department d ON sta.Deptid = d.Deptid
WHERE d.Institute_name = 'SLS';

-- 10. Publisher that provides books to SSBS through College Book Store.
SELECT DISTINCT p.Pname
FROM Publisher p
JOIN Purchase pu ON p.Pid = pu.Pid
JOIN Library l ON pu.Lid = l.Lid
JOIN Seller s ON pu.Sid = s.Sid
WHERE l.Lname LIKE '%SSBS%'
AND s.Slname LIKE '%College Book Store%';

-- 11. Institutes whose staff and students have issued book with bid 4444.
SELECT DISTINCT d.Institute_name
FROM Issue i
JOIN Member m ON i.Memid = m.Memid
JOIN Student st ON m.Memid = st.Memid
JOIN Department d ON st.Deptid = d.Deptid
WHERE i.Bid = 4444
UNION
SELECT DISTINCT d.Institute_name
FROM Issue i
JOIN Member m ON i.Memid = m.Memid
JOIN Staff sta ON m.Memid = sta.Memid
JOIN Department d ON sta.Deptid = d.Deptid
WHERE i.Bid = 4444;

-- 12. Sellers selling to libraries in the same city.
SELECT DISTINCT s.Slname, s.City, l.Lname
FROM Seller s
JOIN Purchase p ON s.Sid = p.Sid
JOIN Library l ON p.Lid = l.Lid
WHERE s.City = l.City;

-- 13. Authors with books costing more than 500.
SELECT DISTINCT a.Aname
FROM Author a
JOIN Writes w ON a.Aid = w.Aid
JOIN Books b ON w.Bid = b.Bid
WHERE b.Price > 500;

-- 14. Members who issued books belonging to E&TC dept of SITM.
SELECT DISTINCT m.Memid
FROM Issue i
JOIN Member m ON i.Memid = m.Memid
JOIN Books b ON i.Bid = b.Bid
JOIN Library l ON b.Lid = l.Lid
JOIN Department d ON l.Lid = d.Lid
WHERE d.Deptname = 'E&TC'
AND d.Institute_name = 'SITM';

-- 15. List books of SIT library. (same as Q2, likely expects copies info too)
SELECT b.Bname, b.Price, COUNT(n.Bnid) AS copies
FROM Books b
JOIN Library l ON b.Lid = l.Lid
JOIN Noofcopies n ON b.Bid = n.Bid
WHERE l.Lname = 'SITLib'
GROUP BY b.Bid, b.Bname, b.Price;

-- 16. Books written by "Ken Coel". (not in data, query still valid)
SELECT b.Bname, b.Price
FROM Books b
JOIN Writes w ON b.Bid = w.Bid
JOIN Author a ON w.Aid = a.Aid
WHERE a.Aname = 'Ken Coel';

-- 17. Staff members whose salary... (Staff has no salary column — using Employee)
-- Assuming question means: staff members whose linked employee earns less than at least one employee
SELECT DISTINCT sta.Stname
FROM Staff sta
JOIN Member m ON sta.Memid = m.Memid
JOIN Employee e ON m.Lid = e.Lid
WHERE e.Salary < (SELECT MAX(Salary) FROM Employee);

-- 18. Books whose price is greater than at least one book in the library.
SELECT DISTINCT b.Bname, b.Price
FROM Books b
WHERE b.Price > (SELECT MIN(Price) FROM Books);

-- 19. Employees whose salary is greater than ALL employees of CS department.
SELECT Empname, Salary
FROM Employee
WHERE Salary > ALL (
    SELECT e.Salary FROM Employee e
    JOIN Library l ON e.Lid = l.Lid
    JOIN Department d ON l.Lid = d.Lid
    WHERE d.Deptname = 'CS'
);

-- 20. Purchases whose total cost > all purchases by SIT library.
SELECT *
FROM Purchase
WHERE Totalcost > ALL (
    SELECT p.Totalcost FROM Purchase p
    JOIN Library l ON p.Lid = l.Lid
    WHERE l.Lname = 'SITLib'
);

-- 21. SIU library located in Nashik with branch named SIOM library (EXISTS).
SELECT s.Lname, s.Location
FROM SIULibrary s
WHERE EXISTS (
    SELECT 1 FROM Library l
    WHERE l.Slid = s.Slid
    AND l.City = 'Nashik'
    AND l.Lname = 'SIOMLib'
);

-- 22. Staff whose name starts with 'S' and not in CS dept (NOT EXISTS).
SELECT sta.Stname
FROM Staff sta
WHERE sta.Stname LIKE 'S%'
AND NOT EXISTS (
    SELECT 1 FROM Department d
    WHERE d.Deptid = sta.Deptid
    AND d.Deptname = 'CS'
);

-- 23. Books issued by student Shivani.
SELECT b.Bname, i.Issuedate, i.Returndate
FROM Issue i
JOIN Books b ON i.Bid = b.Bid
JOIN Member m ON i.Memid = m.Memid
JOIN Student st ON m.Memid = st.Memid
WHERE st.Sname = 'Shivani';

-- 24. Seller from whom SIT library purchased books of Technical Publications.
SELECT DISTINCT s.Slname, s.City
FROM Seller s
JOIN Purchase p ON s.Sid = p.Sid
JOIN Library l ON p.Lid = l.Lid
JOIN Publisher pub ON p.Pid = pub.Pid
WHERE l.Lname = 'SITLib'
AND pub.Pname LIKE '%Technical%';

-- 25. Books issued by staff of SSLA law department.
SELECT b.Bname, i.Issuedate
FROM Issue i
JOIN Books b ON i.Bid = b.Bid
JOIN Member m ON i.Memid = m.Memid
JOIN Staff sta ON m.Memid = sta.Memid
JOIN Department d ON sta.Deptid = d.Deptid
WHERE d.Institute_name = 'SSLA'
AND d.Deptname = 'Law';

-- 26. Sellers in same city as SCHC library.
SELECT s.Slname, s.City
FROM Seller s
WHERE s.City = (
    SELECT City FROM Library WHERE Lname LIKE '%SCHC%'
);

-- 27. Publishers whose books are provided by seller 'pragati books store' to SSBS library.
SELECT DISTINCT pub.Pname
FROM Publisher pub
JOIN Purchase p ON pub.Pid = p.Pid
JOIN Library l ON p.Lid = l.Lid
JOIN Seller s ON p.Sid = s.Sid
WHERE s.Slname LIKE '%pragati%'
AND l.Lname LIKE '%SSBS%';

-- 28. Books published by 'Shivam Kapoor' with Wiley publications.
SELECT b.Bname, b.Price
FROM Books b
JOIN Writes w ON b.Bid = w.Bid
JOIN Author a ON w.Aid = a.Aid
JOIN Publisher p ON w.Pid = p.Pid
WHERE a.Aname = 'Shivam Kapoor'
AND p.Pname LIKE '%Wiley%';

-- 29. Purchase details of SIBM library for December.
SELECT p.*
FROM Purchase p
JOIN Library l ON p.Lid = l.Lid
WHERE l.Lname LIKE '%SIBM%'
AND MONTH(p.PurchaseDate) = 12;

-- 30. Institute of member who issued book number 453.
SELECT DISTINCT d.Institute_name
FROM Issue i
JOIN Member m ON i.Memid = m.Memid
LEFT JOIN Student st ON m.Memid = st.Memid
LEFT JOIN Staff sta ON m.Memid = sta.Memid
LEFT JOIN Department d ON d.Deptid = COALESCE(st.Deptid, sta.Deptid)
WHERE i.Bid = 453;