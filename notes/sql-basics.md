# SQL Basics - Introduction and Fundamentals

## What is SQL?

**SQL (Structured Query Language)** - Standard language for managing and manipulating relational databases.

---

## Characteristics of SQL

**1. Non-Procedural Language**
- Specify **what** data you want, not **how** to get it
- Database engine determines optimal execution path
- Example: `SELECT * FROM Students WHERE age > 20`

**2. Standard Language**
- ANSI/ISO standard for relational databases
- Works across different DBMS (MySQL, PostgreSQL, Oracle, SQL Server)
- Minor syntax variations exist between vendors

**3. Easy to Learn**
- English-like syntax
- Intuitive commands (SELECT, INSERT, UPDATE, DELETE)
- Quick to write simple queries

**4. Case Insensitive**
- `SELECT`, `select`, `SeLeCt` are all same
- Convention: Keywords in UPPERCASE, table/column names in lowercase
- String values ARE case-sensitive: `'Alice'` ≠ `'alice'`

**5. Supports Multiple Operations**
- Data Definition (create tables)
- Data Manipulation (insert, update, delete)
- Data Query (retrieve data)
- Data Control (permissions, security)
- Transaction Control (commit, rollback)

---

## Advantages of SQL

**1. Universal Database Language**
- Works with all major RDBMS
- Portable skills across different database systems
- Industry standard for 40+ years

**2. High Performance**
- Optimized query execution by database engine
- Efficient data retrieval even from large datasets
- Built-in indexing and caching mechanisms

**3. Multiple Views**
- Create customized views for different users
- Same data, different perspectives
- Security through view-based access control

**4. Client-Server Architecture**
- Multiple users can access database simultaneously
- Centralized data management
- Remote database access over networks

**5. Easy Integration**
- Works with programming languages (Python, Java, PHP, Node.js)
- APIs and libraries available for all major languages
- Seamless integration with web applications

**6. Data Security**
- User authentication and authorization
- Row-level and column-level access control
- Encryption support for sensitive data

**7. Transaction Support**
- ACID properties (Atomicity, Consistency, Isolation, Durability)
- Rollback failed transactions
- Maintain data integrity

---

## SQL Data Types

Data types define what kind of values can be stored in columns.

### 1. Numeric Data Types

| Data Type | Description | Example |
|-----------|-------------|---------|
| **INT** | Integer values (-2B to 2B) | `age INT` |
| **TINYINT** | Small integers (0 to 255) | `status TINYINT` |
| **BIGINT** | Large integers | `population BIGINT` |
| **DECIMAL(p,s)** | Fixed-point decimal | `salary DECIMAL(10,2)` → 12345678.90 |
| **FLOAT** | Floating-point (approximate) | `temperature FLOAT` |
| **DOUBLE** | Double-precision float | `coordinates DOUBLE` |

**Example:**
```sql
CREATE TABLE Products (
    product_id INT,
    price DECIMAL(8,2),      -- Max 999999.99
    stock_quantity SMALLINT,  -- 0 to 32767
    rating FLOAT              -- 4.5, 3.7, etc.
);
```

---

### 2. String/Character Data Types

| Data Type | Description | Max Size | Example |
|-----------|-------------|----------|---------|
| **CHAR(n)** | Fixed-length string | 255 chars | `country_code CHAR(2)` → 'IN', 'US' |
| **VARCHAR(n)** | Variable-length string | 65,535 chars | `name VARCHAR(100)` |
| **TEXT** | Large text data | 65,535 chars | `description TEXT` |
| **MEDIUMTEXT** | Medium text | 16 MB | `article MEDIUMTEXT` |
| **LONGTEXT** | Very large text | 4 GB | `full_document LONGTEXT` |

**CHAR vs VARCHAR:**
```sql
CHAR(5):    'Hi'    stored as 'Hi   ' (padded with spaces)
VARCHAR(5): 'Hi'    stored as 'Hi' (no padding, saves space)
```

**Example:**
```sql
CREATE TABLE Users (
    username VARCHAR(50),      -- Variable length, efficient
    gender CHAR(1),           -- Fixed 'M' or 'F'
    bio TEXT,                 -- Large profile description
    password_hash CHAR(64)    -- Fixed hash length
);
```

---

### 3. Date and Time Data Types

| Data Type | Format | Range | Example |
|-----------|--------|-------|---------|
| **DATE** | YYYY-MM-DD | 1000-01-01 to 9999-12-31 | `'2025-03-15'` |
| **TIME** | HH:MM:SS | -838:59:59 to 838:59:59 | `'14:30:00'` |
| **DATETIME** | YYYY-MM-DD HH:MM:SS | 1000 to 9999 | `'2025-03-15 14:30:00'` |
| **TIMESTAMP** | YYYY-MM-DD HH:MM:SS | 1970 to 2038 | `'2025-03-15 14:30:00'` |
| **YEAR** | YYYY | 1901 to 2155 | `2025` |

**DATETIME vs TIMESTAMP:**
- **DATETIME:** Stores absolute time, doesn't adjust for timezone
- **TIMESTAMP:** Stores in UTC, converts to current timezone on retrieval
- TIMESTAMP auto-updates on row modification

**Example:**
```sql
CREATE TABLE Orders (
    order_id INT,
    order_date DATE,              -- Just the date
    order_time TIME,              -- Just the time
    created_at DATETIME,          -- Full timestamp
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

---

### 4. Boolean Data Type

| Data Type | Values | Storage |
|-----------|--------|---------|
| **BOOLEAN** / **BOOL** | TRUE (1), FALSE (0) | TINYINT(1) |

**Example:**
```sql
CREATE TABLE Products (
    product_id INT,
    is_available BOOLEAN DEFAULT TRUE,
    is_featured BOOL,
    in_stock TINYINT(1)  -- Same as BOOLEAN
);

INSERT INTO Products VALUES (1, TRUE, 1, 0);
-- TRUE = 1, FALSE = 0
```

---

### 5. Binary Data Types

| Data Type | Description | Max Size |
|-----------|-------------|----------|
| **BLOB** | Binary Large Object | 65 KB |
| **MEDIUMBLOB** | Medium binary data | 16 MB |
| **LONGBLOB** | Large binary data | 4 GB |

**Use Cases:**
- Store images, PDFs, audio files
- Not recommended - better to store file paths and keep files on disk

**Example:**
```sql
CREATE TABLE Documents (
    doc_id INT,
    file_name VARCHAR(255),
    file_data BLOB,           -- Small files
    thumbnail MEDIUMBLOB      -- Images
);
```

---

### 6. Special Data Types

**ENUM - Enumerated List**
```sql
CREATE TABLE Orders (
    order_id INT,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled')
);

INSERT INTO Orders VALUES (1, 'pending');  -- Valid
INSERT INTO Orders VALUES (2, 'unknown');  -- Error
```

**SET - Multiple Values from List**
```sql
CREATE TABLE Users (
    user_id INT,
    permissions SET('read', 'write', 'delete', 'admin')
);

INSERT INTO Users VALUES (1, 'read,write');      -- Multiple values
INSERT INTO Users VALUES (2, 'admin');           -- Single value
```

---

## Data Type Selection Guidelines

**Choose wisely to optimize storage and performance:**

1. **Use smallest appropriate data type**
   - `TINYINT` for age (0-127) instead of `INT`
   - `VARCHAR(50)` instead of `VARCHAR(255)` if name won't exceed 50 chars

2. **VARCHAR vs TEXT**
   - Use `VARCHAR` for short to medium text (better indexing)
   - Use `TEXT` only for very large content (articles, descriptions)

3. **INT vs BIGINT**
   - Use `INT` for most ID columns (supports 2 billion rows)
   - Use `BIGINT` only when expecting > 2 billion records

4. **DECIMAL for money**
   - Never use `FLOAT` or `DOUBLE` for currency (rounding errors)
   - Always use `DECIMAL(10,2)` for precise financial data

5. **DATETIME vs TIMESTAMP**
   - Use `DATETIME` for birthdates, historical dates
   - Use `TIMESTAMP` for created_at, updated_at (auto-update)

---

## Practical Example: Complete Table
```sql
CREATE TABLE Employees (
    -- Primary Key
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- String Data
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    
    -- Numeric Data
    age TINYINT CHECK (age >= 18),
    salary DECIMAL(10,2) DEFAULT 30000.00,
    
    -- Date/Time Data
    birth_date DATE,
    hire_date DATE NOT NULL,
    last_login TIMESTAMP,
    
    -- Boolean Data
    is_active BOOLEAN DEFAULT TRUE,
    is_manager BOOL DEFAULT FALSE,
    
    -- ENUM Data
    department ENUM('IT', 'HR', 'Finance', 'Sales'),
    employment_type ENUM('Full-time', 'Part-time', 'Contract'),
    
    -- Metadata
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

---

## Key Takeaways

1. **SQL is universal** - works across all major databases
2. **Choose appropriate data types** - impacts storage and performance
3. **VARCHAR for variable text**, CHAR for fixed-length
4. **DECIMAL for money**, never FLOAT
5. **TIMESTAMP auto-updates**, DATETIME doesn't
6. **ENUM restricts values** to predefined list
7. **Smaller data types save space** and improve query speed

---