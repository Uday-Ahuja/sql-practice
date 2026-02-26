use lib222;
-- 1. Give library wise book details.
SELECT l.Lname, b.Bname, b.Price 
FROM Books b 
JOIN Library l ON b.Lid = l.Lid 
ORDER BY l.Lname;
-- 2. Give bookwise total copies which are available.
SELECT b.Bname, COUNT(n.Bnid) AS total_copies
FROM Books b
JOIN Noofcopies n ON b.Bid = n.Bid
GROUP BY b.Bid, b.Bname;

-- 3. Which library has total copies more than 100?
select l.lid, count(n.bnid) as number_of_books
from Library l 
join Noofcopies n on l.lid=n.lid 
group by l.Lid, l.Lname
having count(n.bnid)>100;

-- 4. Give institute wise department details.
select Deptid, Deptname, Institute_name from Department order by Institute_name, Deptid;

-- 5. Give citywise seller details.
select Slname , City from seller order by City;

-- 6. Give author wise book details that have authored more than 2 books.
SELECT a.Aname, b.Bname, b.Price
FROM Author a
JOIN Writes w ON a.Aid = w.Aid
JOIN Books b ON w.Bid = b.Bid
GROUP BY a.Aid, a.Aname, b.Bid, b.Bname, b.Price
HAVING COUNT(DISTINCT w.Bid) > 2;

-- 7. Give book details library wise whose price is less than 1000
select l.Lname , b.Bname, b.Price
from Books b 
join Library l on b.Lid=l.Lid
where b.price<1000
order by l.Lname;

-- 8. Give department wise staff details.
SELECT d.Deptname, s.Stname, s.Email
FROM Staff s
JOIN Department d ON s.Deptid = d.Deptid
ORDER BY d.Deptname;

-- 9. How many books are issued library wise
SELECT l.Lname, COUNT(i.Issueid) AS books_issued
FROM Library l
LEFT JOIN Issue i ON l.Lid = i.Lid
GROUP BY l.Lid, l.Lname
ORDER BY books_issued DESC;

-- 10. Give purchase details publisher wise.
SELECT p.Pname, pu.Prid, pu.Quantity, pu.Totalcost, pu.PurchaseDate
FROM Publisher p
JOIN Purchase pu ON p.Pid = pu.Pid
ORDER BY p.Pname;

-- 11. Display books in a descending order of their cost.
SELECT Bname, Price
FROM Books
ORDER BY Price DESC;