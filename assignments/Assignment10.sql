-- Setup: log table for Books trigger
CREATE TABLE Books_Log (
    LogId INT AUTO_INCREMENT PRIMARY KEY,
    Bid INT,
    Old_Price DECIMAL(10,2),
    New_Price DECIMAL(10,2),
    Changed_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 1. AFTER UPDATE trigger on Books table
DELIMITER //
CREATE OR REPLACE TRIGGER after_books_update
AFTER UPDATE ON Books
FOR EACH ROW
BEGIN
    IF OLD.Price <> NEW.Price THEN
        INSERT INTO Books_Log(Bid, Old_Price, New_Price)
        VALUES (OLD.Bid, OLD.Price, NEW.Price);
    END IF;
END //
DELIMITER ;
-- Test Q1
UPDATE Books SET Price = 1200 WHERE Bid = 1;
SELECT * FROM Books_Log;

-- Setup: log table for BEFORE INSERT trigger
CREATE TABLE Books_Insert_Log (
    LogId INT AUTO_INCREMENT PRIMARY KEY,
    Bid INT,
    Bname VARCHAR(200),
    Price DECIMAL(10,2),
    Inserted_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 2. BEFORE INSERT trigger on Books table
DELIMITER //
CREATE OR REPLACE TRIGGER before_books_insert
BEFORE INSERT ON Books
FOR EACH ROW
BEGIN
    IF NEW.Price < 0 THEN
        SET NEW.Price = 0;
    END IF;
    INSERT INTO Books_Insert_Log(Bid, Bname, Price)
    VALUES (NEW.Bid, NEW.Bname, NEW.Price);
END //
DELIMITER ;
-- Test Q2
INSERT INTO Books VALUES (25, 'Test Book', -500, 1);
SELECT * FROM Books_Insert_Log;
SELECT * FROM Books WHERE Bid = 25;

-- Setup: log table for Purchase trigger
CREATE TABLE Purchase_Log (
    LogId INT AUTO_INCREMENT PRIMARY KEY,
    Prid INT,
    Old_Totalcost DECIMAL(10,2),
    New_Totalcost DECIMAL(10,2),
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 3. AFTER UPDATE trigger on Purchase table
DELIMITER //
CREATE OR REPLACE TRIGGER after_purchase_update
AFTER UPDATE ON Purchase
FOR EACH ROW
BEGIN
    IF OLD.Totalcost <> NEW.Totalcost THEN
        INSERT INTO Purchase_Log(Prid, Old_Totalcost, New_Totalcost)
        VALUES (OLD.Prid, OLD.Totalcost, NEW.Totalcost);
    END IF;
END //
DELIMITER ;
-- Test Q3
UPDATE Purchase SET Totalcost = 95000 WHERE Prid = 1001;
SELECT * FROM Purchase_Log;