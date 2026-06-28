-- 1. Write a PL/SQL function to multiply 2 numbers
delimiter //
create function mul(a int, b int) 
returns int 
deterministic
begin
declare m int;
set m=a*b;
return m;
end //
delimiter ;
select mul(2,3);

-- 2. Write a PL/SQL function to find maximum of 2 numbers.
delimiter //
create function compare(a int, b int) 
returns varchar (25) 
deterministic
begin
if (a>b) then
return 'A is greater';
elseif a=b then 
return 'A equals B'; 
else 
return 'B is greater';
end if;
end //
delimiter ;
select compare(2,3);

-- 3. Write a PL/SQL function to define total number of books in SIU Library
DELIMITER //
CREATE FUNCTION total_books_siu()
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM Books b
    JOIN Library l ON b.Lid = l.Lid
    JOIN SIULibrary s ON l.Slid = s.Slid;
    RETURN total;
END //
DELIMITER ;
SELECT total_books_siu();
-- 4. Write a PL/SQL function to find average of 4 numbers.
DELIMITER //
CREATE FUNCTION avg_four(a DECIMAL(10,2), b DECIMAL(10,2), 
									c DECIMAL(10,2), d DECIMAL(10,2))
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    RETURN (a + b + c + d) / 4;
END //
DELIMITER ;
SELECT avg_four(10, 20, 30, 40);

-- 5. Write a PL/SQL function to find factorial.
delimiter //
create function factorial(n int) 
returns int 
deterministic
begin
declare i int default 1;
declare fac int default 1;
while i<=n do
set fac = fac*i;
set i=i+1;
end while;
return fac;
end //
delimiter ;
select factorial(5);

-- 6. Name of library with cheapest books
DELIMITER //
CREATE FUNCTION cheapest_book_library()
RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
    DECLARE lib_name VARCHAR(100);
    SELECT l.Lname INTO lib_name
    FROM Books b
    JOIN Library l ON b.Lid = l.Lid
    WHERE b.Price = (SELECT MIN(Price) FROM Books)
    LIMIT 1;
    RETURN lib_name;
END //
DELIMITER ;
SELECT cheapest_book_library();

-- 7. Total books issued by SIT Staff
DELIMITER //
CREATE FUNCTION books_issued_sit_staff()
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(i.Issueid) INTO total
    FROM Issue i
    JOIN Member m ON i.Memid = m.Memid
    JOIN Staff sta ON m.Memid = sta.Memid
    JOIN Department d ON sta.Deptid = d.Deptid
    JOIN Library l ON m.Lid = l.Lid
    WHERE l.Lname = 'SITLib';
    RETURN total;
END //
DELIMITER ;
SELECT books_issued_sit_staff();