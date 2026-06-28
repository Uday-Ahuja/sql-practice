use lib222;
-- 1. Details of books of a given library
DELIMITER //
CREATE PROCEDURE get_books_by_library(IN lib_name VARCHAR(100))
BEGIN
    SELECT b.Bid, b.Bname, b.Price
    FROM Books b
    JOIN Library l ON b.Lid = l.Lid
    WHERE l.Lname = lib_name;
END //
DELIMITER ;
CALL get_books_by_library('SITLib');

-- 2. Total books written by a particular author
DELIMITER //
CREATE PROCEDURE count_books_by_author(
    IN author_name VARCHAR(100),
    OUT total INT
)
BEGIN
    SELECT COUNT(DISTINCT w.Bid) INTO total
    FROM Writes w
    JOIN Author a ON w.Aid = a.Aid
    WHERE a.Aname = author_name;
END //
DELIMITER ;
CALL count_books_by_author('Shruti', @total);
SELECT @total;

-- 3. Increase price of books by 10% sold by a particular seller to a particular library
DELIMITER //
CREATE PROCEDURE increase_price_by_seller(
    IN seller_name VARCHAR(100),
    IN lib_name VARCHAR(100)
)
BEGIN
    UPDATE Books b
    JOIN Purchase p ON b.Bid = p.Bid
    JOIN Seller s ON p.Sid = s.Sid
    JOIN Library l ON p.Lid = l.Lid
    SET b.Price = b.Price * 1.10
    WHERE s.Slname = seller_name AND l.Lname = lib_name;
END //
DELIMITER ;
CALL increase_price_by_seller('Kohinoor', 'SITLib');

-- 4. Count publishers providing books to a particular library
DELIMITER //
CREATE PROCEDURE count_publishers_for_library(
    IN lib_name VARCHAR(100),
    OUT pub_count INT
)
BEGIN
    SELECT COUNT(DISTINCT p.Pid) INTO pub_count
    FROM Purchase pu
    JOIN Library l ON pu.Lid = l.Lid
    JOIN Publisher p ON pu.Pid = p.Pid
    WHERE l.Lname = lib_name;
END //
DELIMITER ;
CALL count_publishers_for_library('SITLib', @count);
SELECT @count;

-- 5. Costliest and cheapest books in a particular library
DELIMITER //
CREATE PROCEDURE costliest_cheapest_books(
    IN lib_name VARCHAR(100),
    OUT max_book VARCHAR(200),
    OUT min_book VARCHAR(200))
BEGIN
    SELECT Bname INTO max_book
    FROM Books b JOIN Library l ON b.Lid = l.Lid
    WHERE l.Lname = lib_name
    ORDER BY b.Price DESC LIMIT 1;
    SELECT Bname INTO min_book
    FROM Books b JOIN Library l ON b.Lid = l.Lid
    WHERE l.Lname = lib_name
    ORDER BY b.Price ASC LIMIT 1;
END //
DELIMITER ;
CALL costliest_cheapest_books('SITLib', @max_b, @min_b);
SELECT @max_b AS costliest, @min_b AS cheapest;

-- 6. Update price of books by 25% written by a particular author
DELIMITER //
CREATE PROCEDURE update_price_by_author(IN author_name VARCHAR(100))
BEGIN
    UPDATE Books b
    JOIN Writes w ON b.Bid = w.Bid
    JOIN Author a ON w.Aid = a.Aid
    SET b.Price = b.Price * 1.25
    WHERE a.Aname = author_name;
END //
DELIMITER ;
CALL update_price_by_author('Shruti');

-- 7. Total money spent by a library in a particular month
DELIMITER //
CREATE PROCEDURE money_spent_by_library(
    IN lib_name VARCHAR(100),
    IN month_no INT,
    OUT total_spent DECIMAL(10,2)
)
BEGIN
    SELECT SUM(Totalcost) INTO total_spent
    FROM Purchase p
    JOIN Library l ON p.Lid = l.Lid
    WHERE l.Lname = lib_name
    AND MONTH(p.PurchaseDate) = month_no;
END //
DELIMITER ;
CALL money_spent_by_library('SITLib', 7, @spent);
SELECT @spent;