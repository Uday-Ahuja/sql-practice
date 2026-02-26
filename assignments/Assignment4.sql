use lib222;
-- Add available_copies column to Noofcopies table
ALTER TABLE Noofcopies ADD COLUMN available_copies INT DEFAULT 1;

-- Update with sample data (assuming most books have 3-5 copies available)
UPDATE Noofcopies SET available_copies = 5 WHERE Bnid IN (1,2,3,4,5);
UPDATE Noofcopies SET available_copies = 3 WHERE Bnid IN (6,7,8,9,10);
UPDATE Noofcopies SET available_copies = 4 WHERE Bnid IN (11,12,13,14,15);
UPDATE Noofcopies SET available_copies = 2 WHERE Bnid IN (16,17,18,19,20);
UPDATE Noofcopies SET available_copies = 6 WHERE Bnid IN (21,22,23,24,25);
UPDATE Noofcopies SET available_copies = 1 WHERE Bnid IN (26,27,28,29,30,31,32);

-- 1. Find the cheapest book of SIBM library
SELECT b.Bname, b.Price 
FROM Books b 
JOIN Library l ON b.Lid = l.Lid 
WHERE l.Lname = 'SIBMLib' 
ORDER BY b.Price ASC 
LIMIT 1;

-- 2. Which library has the costliest book?
SELECT l.Lname, b.Bname, b.Price 
FROM Books b 
JOIN Library l ON b.Lid = l.Lid 
WHERE b.Price = (SELECT MAX(Price) FROM Books);

-- 3. How many students from SIT issued the book?
SELECT COUNT(DISTINCT i.Memid) AS student_count
FROM Issue i
JOIN Member m ON i.Memid = m.Memid
JOIN Library l ON m.Lid = l.Lid
WHERE l.Lname = 'SITLib';

-- 4. What is the average cost of books in SITMN library?
SELECT AVG(b.Price) AS average_price
FROM Books b
JOIN Library l ON b.Lid = l.Lid
WHERE l.Lname = 'SITMNLib';

-- 5. What is the total cost of purchase made by SIT in the month of January to June?
SELECT SUM(p.Totalcost) AS total_cost
FROM Purchase p
JOIN Library l ON p.Lid = l.Lid
WHERE l.Lname = 'SITLib' 
AND MONTH(p.PurchaseDate) BETWEEN 1 AND 6;

-- 6. How many books are written by "Shruti"
SELECT COUNT(DISTINCT w.Bid) AS book_count
FROM Writes w
JOIN Author a ON w.Aid = a.Aid
WHERE a.Aname = 'Shruti';

-- 7. What is the costliest book published by "Pragati Book Store"
SELECT b.Bname, b.Price
FROM Books b
JOIN Writes w ON b.Bid = w.Bid
JOIN Publisher p ON w.Pid = p.Pid
WHERE p.Pname = 'Pragati book store'
ORDER BY b.Price DESC
LIMIT 1;

-- 8. How many total copies of books do SIT has?
SELECT SUM(n.available_copies) AS total_copies
FROM Noofcopies n
JOIN Library l ON n.Lid = l.Lid
WHERE l.Lname = 'SITLib';

-- 9. What is the average cost of books written by "Shivam Kapoor"?
SELECT AVG(b.Price) AS average_price
FROM Books b
JOIN Writes w ON b.Bid = w.Bid
JOIN Author a ON w.Aid = a.Aid
WHERE a.Aname = 'Shivam Kapoor';

-- 10. How many books are sold by seller living in Pune?
SELECT COUNT(DISTINCT s.Bid) AS book_count
FROM Sells s
JOIN Seller sel ON s.Sid = sel.Sid
WHERE sel.City = 'Pune';

-- 11. Print the student name in capital who belongs to SSBS
SELECT UPPER(st.Sname) AS student_name
FROM Student st
JOIN Department d ON st.Deptid = d.Deptid
WHERE d.Institute_name = 'SSBS';

-- 12. Add two months to the issue date of book written by "Shivam Kapoor"
SELECT i.Issueid, i.Issuedate, 
       DATE_ADD(i.Issuedate, INTERVAL 2 MONTH) AS new_date
FROM Issue i
JOIN Books b ON i.Bid = b.Bid
JOIN Writes w ON b.Bid = w.Bid
JOIN Author a ON w.Aid= a.Aid
WHERE a.Aname = 'Shivam Kapoor';

-- 13. What was the last day of the month when Satish issued the book?
SELECT LAST_DAY(i.Issuedate) AS last_day_of_month
FROM Issue i
JOIN Member m ON i.Memid = m.Memid
JOIN Student st ON m.Memid = st.Memid
WHERE st.Sname = 'Satish';

-- 14. How many books are issued from January to march 2010 & 2020?
SELECT COUNT(*) AS book_count
FROM Issue
WHERE (YEAR(Issuedate) = 2010 OR YEAR(Issuedate) = 2020)
AND MONTH(Issuedate) BETWEEN 1 AND 3;

-- 15. How many books have copies less than 5 available in the SIBM library?
SELECT COUNT(DISTINCT n.Bid) AS book_count
FROM Noofcopies n
JOIN Library l ON n.Lid = l.Lid
WHERE l.Lname = 'SIBMLib' 
AND n.available_copies < 5;