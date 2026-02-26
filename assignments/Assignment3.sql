CREATE DATABASE lib222;
USE lib222;
CREATE TABLE SIULibrary (
    Slid INT PRIMARY KEY,
    Lname VARCHAR(100),
    Location VARCHAR(100),
    Noofbranches INT
);
CREATE TABLE Library (
    Lid INT PRIMARY KEY,
    Lname VARCHAR(100),
    City VARCHAR(50),
    Area VARCHAR(100),
    Slid INT,
    FOREIGN KEY (Slid) REFERENCES SIULibrary(Slid)
);
CREATE TABLE Books (
    Bid INT PRIMARY KEY,
    Bname VARCHAR(200),
    Price DECIMAL(10,2),
    Lid INT,
    FOREIGN KEY (Lid) REFERENCES Library(Lid)
);
CREATE TABLE Author (
    Aid INT PRIMARY KEY,
    Aname VARCHAR(100),
    Email VARCHAR(100),
    Phoneno VARCHAR(15)
);
CREATE TABLE Publisher (
    Pid INT PRIMARY KEY,
    Pname VARCHAR(100)
);
CREATE TABLE Writes (
    Bid INT,
    Aid INT,
    Pid INT,
    PRIMARY KEY (Bid, Aid, Pid),
    FOREIGN KEY (Bid) REFERENCES Books(Bid),
    FOREIGN KEY (Aid) REFERENCES Author(Aid),
    FOREIGN KEY (Pid) REFERENCES Publisher(Pid)
);
CREATE TABLE Seller (
    Sid INT PRIMARY KEY,
    Slname VARCHAR(100),
    City VARCHAR(50)
);
CREATE TABLE Sells (
    Sid INT,
    Bid INT,
    Pid INT,
    PRIMARY KEY (Sid, Bid, Pid),
    FOREIGN KEY (Sid) REFERENCES Seller(Sid),
    FOREIGN KEY (Bid) REFERENCES Books(Bid),
    FOREIGN KEY (Pid) REFERENCES Publisher(Pid)
);
CREATE TABLE Department (
    Deptid INT PRIMARY KEY,
    Deptname VARCHAR(100),
    Institute_name VARCHAR(100),
    Lid INT,
    FOREIGN KEY (Lid) REFERENCES Library(Lid) 
); 
CREATE TABLE Member (
    Memid INT PRIMARY KEY,
    Lid INT,
    FOREIGN KEY (Lid) REFERENCES Library(Lid)
);
CREATE TABLE Student (
    Stid INT PRIMARY KEY,
    Sname VARCHAR(100),
    Email VARCHAR(100),
    Memid INT,
    Deptid INT,
    FOREIGN KEY (Memid) REFERENCES Member(Memid),
    FOREIGN KEY (Deptid) REFERENCES Department(Deptid)
);
CREATE TABLE Staff (
    Staid INT PRIMARY KEY,
    Stname VARCHAR(100),
    Email VARCHAR(100),
    Memid INT,
    Deptid INT,
    FOREIGN KEY (Memid) REFERENCES Member(Memid),
    FOREIGN KEY (Deptid) REFERENCES Department(Deptid)
);
CREATE TABLE Employee (
    Empid INT PRIMARY KEY,
    Empname VARCHAR(100),
    Email VARCHAR(100),
    Salary DECIMAL(10,2),
    Lid INT,
    FOREIGN KEY (Lid) REFERENCES Library(Lid)
);
CREATE TABLE Noofcopies (
    Bnid INT PRIMARY KEY,
    Bid INT,
    Lid INT,
    FOREIGN KEY (Bid) REFERENCES Books(Bid),
    FOREIGN KEY (Lid) REFERENCES Library(Lid)
);
CREATE TABLE Purchase (
    Prid INT PRIMARY KEY,
    Lid INT,
    Sid INT,
    Pid INT,
    Bid INT,
    Quantity INT,
    PurchaseDate DATE,
    Totalcost DECIMAL(10,2),
    FOREIGN KEY (Lid) REFERENCES Library(Lid),
    FOREIGN KEY (Sid) REFERENCES Seller(Sid),
    FOREIGN KEY (Pid) REFERENCES Publisher(Pid),
    FOREIGN KEY (Bid) REFERENCES Books(Bid)
);
CREATE TABLE Issue (
    Issueid INT PRIMARY KEY,
    Memid INT,
    Bid INT,
    Bnid INT,
    Lid INT,
    Issuedate DATE,
    Returndate DATE,
    FOREIGN KEY (Memid) REFERENCES Member(Memid),
    FOREIGN KEY (Bid) REFERENCES Books(Bid),
    FOREIGN KEY (Bnid) REFERENCES Noofcopies(Bnid),
    FOREIGN KEY (Lid) REFERENCES Library(Lid)
);
CREATE TABLE Author_specialization (
    Spec_id INT PRIMARY KEY,
    Aid INT,
    Spec_name VARCHAR(100),
    FOREIGN KEY (Aid) REFERENCES Author(Aid)
);
INSERT INTO SIULibrary VALUES (1, 'Pune Central Library', 'Pune', 10);
INSERT INTO Library VALUES (1, 'SITLib', 'Pune', 'Lavale', 1);
INSERT INTO Library VALUES (2, 'SIBMLib', 'Pune', 'Lavale', 1);
INSERT INTO Library VALUES (3, 'SSACLib', 'Nagpur', 'Ramnagar', 1);
INSERT INTO Library VALUES (4, 'SSLALib', 'Pune', 'Vimannagar', 1);
INSERT INTO Library VALUES (5, 'SIBMBLib', 'Bangalore', 'Jaynagar', 1);
INSERT INTO Library VALUES (6, 'SITMHLib', 'Hyderabad', 'Banjara hills', 1);
INSERT INTO Library VALUES (7, 'SIOMLib', 'Pune', 'S.B.Road', 1);
INSERT INTO Library VALUES (8, 'SITMNLib', 'Noida', 'Golf course area', 1);
INSERT INTO Library VALUES (9, 'SSLAHLib', 'Hyderabad', 'Gacchibowli', 1);
INSERT INTO Library VALUES (10, 'SSBSLib', 'Pune', 'Tithnagar', 1);

INSERT INTO Books VALUES (1, 'Operating System', 1000, 1);
INSERT INTO Books VALUES (2, 'Management System', 2500, 2);
INSERT INTO Books VALUES (3, 'Supply chain management', 500, 8);
INSERT INTO Books VALUES (4, 'Bioinformatics', 780, 10);
INSERT INTO Books VALUES (5, 'Tele informatics', 4567, 10);
INSERT INTO Books VALUES (6, 'IP and Patents formation', 345, 4);
INSERT INTO Books VALUES (7, 'Engineering Graphics', 2456, 1);
INSERT INTO Books VALUES (8, 'Customer Management', 3467, 5);
INSERT INTO Books VALUES (9, 'Buying Pattern Analysis', 456, 8);
INSERT INTO Books VALUES (10, 'Digital Finance', 600, 8);
INSERT INTO Books VALUES (11, 'Telecommunication', 1500, 6);
INSERT INTO Books VALUES (12, 'Algorithms', 6754, 1);
INSERT INTO Books VALUES (13, 'Child Law', 1800, 4);
INSERT INTO Books VALUES (14, 'Multimanagers', 2345, 2);
INSERT INTO Books VALUES (15, 'MicroEconomics', 267, 5);
INSERT INTO Books VALUES (16, 'Electronics', 2341, 1);
INSERT INTO Books VALUES (17, 'Structure foundations', 1700, 3);
INSERT INTO Books VALUES (18, 'Ecohomes', 1234, 3);
INSERT INTO Books VALUES (19, 'Mobile Communication', 456, 6);
INSERT INTO Books VALUES (20, 'Labor Laws', 3452, 9);
INSERT INTO Books VALUES (21, 'Copyrights', 2789, 9);
INSERT INTO Books VALUES (22, 'Research Laws', 1100, 9);
INSERT INTO Books VALUES (23, 'DBMS', 700, 1);
INSERT INTO Books VALUES (24, 'Computer networks', 3451, 1);

INSERT INTO Author VALUES (1, 'Shruti', 'abc@gmail.com', '6447896542');
INSERT INTO Author VALUES (2, 'Shivam Kapoor', 'adf@gmail.com', '2345778998');
INSERT INTO Author VALUES (3, 'Ameya', 'ert@gmail.com', '23456789087');
INSERT INTO Author VALUES (4, 'Pooja Pai', 'edr@gamil.com', '32554565678');
INSERT INTO Author VALUES (5, 'Brian Kernighan', 'rtyu@gmail.com', '2143454657');
INSERT INTO Author VALUES (6, 'Ken Thompson', 'errt@gmail.com', '2343454565');

INSERT INTO Publisher VALUES (1, 'Tata Macgraw hill');
INSERT INTO Publisher VALUES (2, 'Pragati book store');
INSERT INTO Publisher VALUES (3, 'Prentice Hall');
INSERT INTO Publisher VALUES (4, 'oReilly');
INSERT INTO Publisher VALUES (5, 'Emrald publishing');

INSERT INTO Seller VALUES (1, 'Kohinoor', 'Pune');
INSERT INTO Seller VALUES (2, 'Shiksha', 'Pune');
INSERT INTO Seller VALUES (3, 'ABP', 'Noida');
INSERT INTO Seller VALUES (4, 'Technical', 'Hyderabad');
INSERT INTO Seller VALUES (5, 'Timenowta', 'Bangalore');
INSERT INTO Seller VALUES (6, 'Kirti', 'Pune');

INSERT INTO Department VALUES (1, 'Civil', 'SIT', 1);
INSERT INTO Department VALUES (2, 'E&TC', 'SIT', 1);
INSERT INTO Department VALUES (3, 'Biology', 'SSBS', 10);
INSERT INTO Department VALUES (4, 'Law', 'SSLA', 4);
INSERT INTO Department VALUES (5, 'Structure', 'SSAC', 3);
INSERT INTO Department VALUES (6, 'Finance management', 'SIBM', 2);
INSERT INTO Department VALUES (7, 'Digital Telecommunications', 'SITMH', 6);
INSERT INTO Department VALUES (8, 'Clinical Research', 'SSBS', 10);

INSERT INTO Member VALUES (1, 1);
INSERT INTO Member VALUES (16, 1);
INSERT INTO Member VALUES (13, 1);
INSERT INTO Member VALUES (44, 1);
INSERT INTO Member VALUES (35, 1);
INSERT INTO Member VALUES (26, 10);
INSERT INTO Member VALUES (45, 1);
INSERT INTO Member VALUES (23, 10);
INSERT INTO Member VALUES (12, 3);
INSERT INTO Member VALUES (78, 1);
INSERT INTO Member VALUES (49, 4);
INSERT INTO Member VALUES (50, 1);

INSERT INTO Student VALUES (1, 'Pooja', 'aswq@gmail.com', 1, 1);
INSERT INTO Student VALUES (2, 'Satish', 'azsx@gmail.com', 16, 1);
INSERT INTO Student VALUES (3, 'Amar', 'cvnn@gmail.com', 13, 2);
INSERT INTO Student VALUES (4, 'Meera', 'lkio@gmail.com', 44, 2);
INSERT INTO Student VALUES (5, 'Ravi', 'fghj@gmail.com', 35, 2);
INSERT INTO Student VALUES (6, 'Adit', 'cfgb@gmail.com', 26, 3);

INSERT INTO Staff VALUES (1, 'Satish', 'sddf@gmail.com', 45, 1);
INSERT INTO Staff VALUES (2, 'Rachit', 'zxzxc@gmail.com', 23, 3);
INSERT INTO Staff VALUES (3, 'Seema', 'lkklk@gmail.com', 12, 5);
INSERT INTO Staff VALUES (4, 'Sayali', 'xzcxc@gmail.com', 78, 2);
INSERT INTO Staff VALUES (5, 'Aditya', 'cvvcb@gmail.com', 49, 4);
INSERT INTO Staff VALUES (6, 'Archit', 'gfdfg@gmail.com', 50, 1);

INSERT INTO Employee VALUES (111, 'Shilpa', 'sdfdsf@gmail.com', 10000, 1);
INSERT INTO Employee VALUES (222, 'Shivani', 'sadsf@gmail.com', 20000, 1);
INSERT INTO Employee VALUES (333, 'Hemani', 'ertet@gmail.com', 500000, 2);
INSERT INTO Employee VALUES (444, 'Rekha', 'scdsf@gmail.com', 35000, 3);
INSERT INTO Employee VALUES (555, 'Anil', 'asd@gmail.com', 45000, 5);
INSERT INTO Employee VALUES (666, 'Suhas', 'fdgfg@gmail.com', 20000, 2);

INSERT INTO Noofcopies VALUES (1, 1, 1);
INSERT INTO Noofcopies VALUES (2, 1, 2);
INSERT INTO Noofcopies VALUES (3, 1, 3);
INSERT INTO Noofcopies VALUES (4, 3, 1);
INSERT INTO Noofcopies VALUES (5, 3, 2);
INSERT INTO Noofcopies VALUES (6, 3, 3);
INSERT INTO Noofcopies VALUES (7, 2, 1);
INSERT INTO Noofcopies VALUES (8, 2, 2);
INSERT INTO Noofcopies VALUES (9, 4, 1);
INSERT INTO Noofcopies VALUES (10, 4, 2);
INSERT INTO Noofcopies VALUES (11, 4, 3);
INSERT INTO Noofcopies VALUES (12, 5, 1);
INSERT INTO Noofcopies VALUES (13, 5, 2);
INSERT INTO Noofcopies VALUES (14, 6, 1);
INSERT INTO Noofcopies VALUES (15, 7, 1);
INSERT INTO Noofcopies VALUES (16, 8, 1);
INSERT INTO Noofcopies VALUES (17, 8, 2);
INSERT INTO Noofcopies VALUES (18, 9, 1);
INSERT INTO Noofcopies VALUES (19, 10, 1);
INSERT INTO Noofcopies VALUES (20, 11, 1);
INSERT INTO Noofcopies VALUES (21, 12, 1);
INSERT INTO Noofcopies VALUES (22, 12, 2);
INSERT INTO Noofcopies VALUES (23, 13, 1);
INSERT INTO Noofcopies VALUES (24, 13, 2);
INSERT INTO Noofcopies VALUES (25, 14, 1);
INSERT INTO Noofcopies VALUES (26, 14, 2);
INSERT INTO Noofcopies VALUES (27, 14, 4);
INSERT INTO Noofcopies VALUES (28, 15, 1);
INSERT INTO Noofcopies VALUES (29, 15, 2);
INSERT INTO Noofcopies VALUES (30, 16, 1);
INSERT INTO Noofcopies VALUES (31, 16, 2);
INSERT INTO Noofcopies VALUES (32, 17, 1);

INSERT INTO Writes VALUES (1, 1, 2);
INSERT INTO Writes VALUES (2, 2, 3);
INSERT INTO Writes VALUES (3, 5, 2);
INSERT INTO Writes VALUES (4, 6, 4);
INSERT INTO Writes VALUES (5, 1, 5);
INSERT INTO Writes VALUES (6, 1, 2);
INSERT INTO Writes VALUES (7, 4, 1);
INSERT INTO Writes VALUES (8, 2, 2);
INSERT INTO Writes VALUES (9, 5, 5);
INSERT INTO Writes VALUES (10, 6, 4);
INSERT INTO Writes VALUES (11, 1, 1);
INSERT INTO Writes VALUES (12, 4, 2);
INSERT INTO Writes VALUES (13, 5, 5);
INSERT INTO Writes VALUES (14, 6, 2);
INSERT INTO Writes VALUES (15, 3, 1);
INSERT INTO Writes VALUES (16, 4, 2);
INSERT INTO Writes VALUES (17, 6, 5);
INSERT INTO Writes VALUES (18, 2, 4);
INSERT INTO Writes VALUES (19, 5, 1);
INSERT INTO Writes VALUES (20, 1, 2);
INSERT INTO Writes VALUES (21, 3, 5);
INSERT INTO Writes VALUES (22, 5, 2);
INSERT INTO Writes VALUES (23, 6, 1);
INSERT INTO Writes VALUES (24, 3, 3);

INSERT INTO Sells VALUES (1, 1, 2);
INSERT INTO Sells VALUES (5, 3, 2);
INSERT INTO Sells VALUES (3, 2, 3);
INSERT INTO Sells VALUES (2, 6, 5);
INSERT INTO Sells VALUES (1, 10, 5);
INSERT INTO Sells VALUES (4, 14, 1);

INSERT INTO Purchase VALUES (1001, 1, 1, 3, 1, 100, '2015-07-12', 70000);
INSERT INTO Purchase VALUES (1002, 2, 3, 4, 2, 1000, '2015-04-10', 80000);
INSERT INTO Purchase VALUES (1003, 1, 4, 2, 5, 45, '2016-08-01', 4500);
INSERT INTO Purchase VALUES (1004, 4, 1, 5, 6, 34, '2016-02-06', 23000);
INSERT INTO Purchase VALUES (1005, 3, 4, 1, 9, 20, '2017-03-15', 1200);
INSERT INTO Purchase VALUES (1006, 1, 2, 4, 10, 89, '2017-04-20', 4500);
INSERT INTO Purchase VALUES (1007, 2, 5, 2, 12, 67, '2018-07-25', 5600);
INSERT INTO Purchase VALUES (1008, 3, 2, 4, 15, 45, '2018-03-27', 50000);
INSERT INTO Purchase VALUES (1009, 4, 3, 1, 16, 340, '2019-02-12', 7800);
INSERT INTO Purchase VALUES (1010, 1, 1, 2, 17, 23, '2020-07-11', 10000);


SELECT Lname, Area FROM Library WHERE City = 'Pune';
SELECT Institute_name FROM Department WHERE Deptname = 'CS';
SELECT Bname, Price FROM Books WHERE Price BETWEEN 800 AND 12000;
SELECT Empname, Salary FROM Employee WHERE Salary <= 50000;
SELECT Slname, City FROM Seller WHERE Slname LIKE '%ta';
SELECT Lname, City FROM Library WHERE Area IS NULL;
SELECT Stname FROM Staff WHERE Stname NOT LIKE 'A%';
SELECT DISTINCT s.Lname, s.Location
FROM SIULibrary s
JOIN Library l ON s.Slid = l.Slid
WHERE l.City = 'Bangalore';
SELECT s.Sname, s.Email
FROM Student s
JOIN Department d ON s.Deptid = d.Deptid
WHERE d.Deptname = 'Civil';