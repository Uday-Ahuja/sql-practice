# Codd's 12 Rules of Relational Database

Dr. E.F. Codd proposed 13 rules (numbered 0-12) that define what makes a database management system truly relational. These rules ensure data integrity, consistency, and proper relational database behavior.

---

## Rule 0: Foundation Rule

**The Foundation Rule**

A database system must manage data **using only relational capabilities**.

**Explanation:**
- System must qualify as relational, period
- If a system claims to be an RDBMS, it must use relational methods to manage data
- This is the prerequisite for all other rules

**Example:**
- Oracle, MySQL, PostgreSQL store data in tables and manipulate it using SQL
- All operations performed through relational algebra/SQL

---

## Rule 1: Information Rule

**All information must be stored as values in table cells.**

**Explanation:**
- Data must be represented logically as tables (rows and columns)
- No data should exist outside tables
- Every piece of information is a value at the intersection of a row and column

**Example:**
```
Student Table:
┌─────┬────────┬─────┐
│ ID  │ Name   │ Age │
├─────┼────────┼─────┤
│ 101 │ Alice  │ 20  │
│ 102 │ Bob    │ 21  │
└─────┴────────┴─────┘
```
All information (ID, Name, Age) stored as values in cells.

---

## Rule 2: Guaranteed Access Rule

**Each data value must be accessible using table name, primary key, and column name.**

**Explanation:**
- Every single value must be logically accessible
- Combination of table name + primary key + column name guarantees unique access
- No data should be "hidden" or inaccessible

**Example:**
```sql
SELECT Name 
FROM Student 
WHERE ID = 101;
```
Access "Alice" using: Table (Student) + Primary Key (101) + Column (Name)

---

## Rule 3: Systematic Treatment of NULL Values

**NULL values must be handled uniformly and systematically.**

**Explanation:**
- NULL represents missing, unknown, or inapplicable data
- DBMS must handle NULL consistently across all operations
- NULL ≠ 0, NULL ≠ empty string
- NULL in calculations propagates NULL

**Example:**
```
Phone = NULL  → phone number is unknown or not available
NULL + 5 = NULL
NULL AND TRUE = NULL
```

---

## Rule 4: Active Online Catalog (Data Dictionary)

**Database structure must be stored in an online catalog accessible via SQL.**

**Explanation:**
- Metadata (schema information) stored as tables
- Users can query database structure using same query language (SQL)
- Catalog contains info about tables, columns, constraints, etc.

**Example:**
```sql
USE sales;
SHOW TABLES;              -- List all tables
DESCRIBE customers;        -- Show table structure
SELECT * FROM INFORMATION_SCHEMA.TABLES;  -- Query catalog
```

---

## Rule 5: Comprehensive Data Sub-Language Rule

**One language must support DDL, DML, DCL, and transaction control.**

**Explanation:**
- Single language for all database operations
- Must support data definition, manipulation, control, and transactions
- SQL is the standard comprehensive language

**Example:**
```sql
-- DDL (Data Definition Language)
CREATE TABLE Student (ID INT, Name VARCHAR(50));

-- DML (Data Manipulation Language)
INSERT INTO Student VALUES (101, 'Alice');

-- DCL (Data Control Language)
GRANT SELECT ON Student TO user1;

-- TCL (Transaction Control Language)
COMMIT;
```

---

## Rule 6: View Updating Rule

**All theoretically updatable views must be updatable by the system.**

**Explanation:**
- If a view can logically be updated, the system must allow it
- Updates to views should propagate to base tables
- Views should behave like tables when possible

**Example:**
```sql
CREATE VIEW CS_Students AS 
SELECT * FROM Student WHERE Dept = 'CS';

-- Update view (updates base table)
UPDATE CS_Students SET Age = 21 WHERE ID = 101;
```

---

## Rule 7: High-Level Insert, Update, Delete Rule

**Set-level operations must be supported (not just row-by-row).**

**Explanation:**
- Operations should work on sets of rows, not just single rows
- INSERT, UPDATE, DELETE should handle multiple rows at once
- Supports relational algebra set operations

**Example:**
```sql
-- Delete all CS department students (set operation)
DELETE FROM Student WHERE Dept = 'CS';

-- Update multiple rows at once
UPDATE Student SET Age = Age + 1 WHERE Dept = 'IT';

-- Insert multiple rows
INSERT INTO Student VALUES (101, 'A'), (102, 'B'), (103, 'C');
```

---

## Rule 8: Physical Data Independence

**Changes in physical storage must not affect applications.**

**Explanation:**
- How data is physically stored should be hidden from users
- Changing storage structures shouldn't require changing queries
- Applications remain unaffected by physical-level changes

**Example:**
- Moving database files from HDD to SSD
- Changing indexing strategy from B-tree to Hash
- Reorganizing file storage locations
- **SQL queries remain unchanged** - no application code changes needed

---

## Rule 9: Logical Data Independence

**Logical schema changes must not affect user views or applications.**

**Explanation:**
- Changes to table structures shouldn't break existing applications
- User views should remain consistent even when base tables change
- Applications insulated from schema modifications

**Example:**
```sql
-- Original table
Student(ID, Name, Age)

-- Split into two tables
Student(ID, Name)
StudentDetails(ID, Age)

-- View keeps same interface
CREATE VIEW StudentView AS 
SELECT s.ID, s.Name, sd.Age 
FROM Student s JOIN StudentDetails sd ON s.ID = sd.ID;

-- Applications using StudentView see no change
```

---

## Rule 10: Integrity Independence

**Integrity constraints must be stored in the database catalog, not in applications.**

**Explanation:**
- Constraints defined at database level, not application level
- DBMS enforces constraints automatically
- Cannot bypass constraints through different applications

**Example:**
```sql
CREATE TABLE Student (
    ID INT PRIMARY KEY,
    Age INT CHECK(Age >= 18),      -- Constraint in database
    Email VARCHAR(100) UNIQUE,
    Dept VARCHAR(50) NOT NULL
);

-- DBMS enforces these constraints
-- INSERT INTO Student VALUES (101, 15, 'a@b.c', 'CS');  -- FAILS (Age < 18)
```

---

## Rule 11: Distribution Independence

**Users must not be aware of whether data is distributed across locations.**

**Explanation:**
- Data can be distributed across multiple servers/locations
- Users query as if data is in one place
- DBMS handles data distribution transparently

**Example:**
```
User queries: SELECT * FROM Customer;

Behind the scenes:
- CustomerUS stored in New York server
- CustomerEU stored in London server
- CustomerAsia stored in Singapore server

User sees unified result - distribution is hidden
```

---

## Rule 12: Non-Subversion Rule

**Low-level access must not bypass security or integrity rules.**

**Explanation:**
- If system provides low-level interface (file-level access), it cannot bypass constraints
- All data access (high or low level) must respect integrity and security rules
- Cannot circumvent rules by accessing data files directly

**Example:**
```
❌ WRONG: Directly editing database files to bypass CHECK constraints
✅ RIGHT: All access through DBMS enforces CHECK(Age >= 18)

Even if file-level access exists, constraints must still be enforced
```

---

## Summary Table

| Rule | Name | Key Point |
|------|------|-----------|
| 0 | Foundation | Must be relational |
| 1 | Information | Data in tables only |
| 2 | Guaranteed Access | Access via table+key+column |
| 3 | NULL Handling | Consistent NULL treatment |
| 4 | Catalog | Metadata queryable |
| 5 | Comprehensive Language | One language for all ops |
| 6 | View Updating | Updatable views |
| 7 | Set Operations | Bulk operations |
| 8 | Physical Independence | Storage changes don't affect apps |
| 9 | Logical Independence | Schema changes don't affect views |
| 10 | Integrity Independence | Constraints in database |
| 11 | Distribution Independence | Distributed data transparent |
| 12 | Non-Subversion | Cannot bypass rules |

---

## Reality Check

**No commercial RDBMS fully satisfies all 12 rules.** These are theoretical ideals:
- MySQL, PostgreSQL, Oracle come close but have limitations
- Rules provide a benchmark for evaluating relational database systems
- Most modern RDBMS satisfy 8-10 rules reasonably well