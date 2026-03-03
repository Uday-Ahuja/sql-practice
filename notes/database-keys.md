# Database Keys

## Overview

Keys are attributes or combinations of attributes used to uniquely identify tuples (rows) in a table and establish relationships between tables.

---

## Types of Keys

### Super Key

**Definition:** Pool of all possible keys/combinations that can uniquely identify a tuple.

**Characteristics:**
- Any attribute or combination of attributes that uniquely identifies a row
- Can contain redundant attributes
- Multiple super keys exist for a table

**Example:** Student table with attributes: PRN, Aadhar, Email, Name
- Super Keys: {PRN}, {Aadhar}, {Email}, {PRN, Name}, {Aadhar, Email}, {PRN, Aadhar, Email}, etc.

---

### Candidate Key

**Definition:** Minimal super key - smallest key that can uniquely identify a tuple.

**Characteristics:**
- No proper subset should be a super key
- Cannot contain any redundant attributes
- A table can have multiple candidate keys

**Example:** From Student table above:
- **Candidate Keys:** {PRN}, {Aadhar}, {Email} (all are minimal)
- **NOT Candidate Key:** {PRN, Aadhar} (redundant - PRN alone is sufficient)

---

### Primary Key

**Definition:** One candidate key chosen as the main identifier for a table.

**Characteristics:**
- Must be **unique**
- Cannot be **NULL**
- Only **one** primary key per table
- Used to identify tuples uniquely

**Example:** Employee table
- Attributes: emp_id, pan_card, phone, name
- Candidate Keys: emp_id, pan_card, phone
- **Primary Key:** emp_id (chosen as PK)
- Remaining become alternate keys

---

### Alternate Key

**Definition:** All candidate keys that were NOT chosen as primary key.

**Relationship:**
```
All Candidate Keys = Primary Key + Alternate Keys
```

**Example:** Employee table
- Primary Key: emp_id
- **Alternate Keys:** pan_card, phone

---

### Foreign Key

**Definition:** Primary key of one table referenced in another related table.

**Purpose:**
- Creates relationships between tables
- Maintains referential integrity
- Links related data across tables

**Example:**
```
Student(student_id, name)           ← student_id is PK
Enrollment(enrollment_id, student_id, course_id)  ← student_id is FK
```

---

### Composite Key

**Definition:** Combination of two or more attributes used together to uniquely identify a tuple.

**When Used:**
- When no single attribute can uniquely identify records
- Common in junction/bridge tables for many-to-many relationships

**Example:** Marks table
- Attributes: student_id, course_name, marks
- **Primary Key (Composite):** {student_id, course_name}
- Neither alone can uniquely identify marks, both needed together

---

### Surrogate Key

**Definition:** Artificially created key when no natural primary key exists.

**Characteristics:**
- System-generated (usually auto-increment)
- Has no business meaning
- Used when natural keys are complex or unavailable

**Example:** Superstore scenario
- No customer_id available, bill lost
- Use **{date, time, bill_amount}** together to identify customer's transaction
- Or create surrogate key: transaction_id (auto-generated)

---

### Unique Key

**Definition:** Constraint ensuring all values in a column are unique.

**Difference from Primary Key:**
- **Can be NULL** (primary key cannot)
- **Multiple** unique keys allowed per table (only one primary key)
- Not necessarily used for identification

**Example:** User table
- Primary Key: user_id
- **Unique Keys:** email, phone (both must be unique but can be NULL)

---

## Comprehensive Examples

### Library System

**Book Table:**
```
Book(book_id, isbn, title, accession_number)
```

- **Super Keys:** {book_id}, {isbn}, {accession_number}, {book_id, title}, {isbn, title}, etc.
- **Candidate Keys:** {book_id}, {isbn}, {accession_number}
- **Primary Key:** book_id
- **Alternate Keys:** isbn, accession_number

---

### Order System

**Order_Item Table (Bridge Table):**
```
Order_Item(order_id, item_id, quantity)
```

- **Composite Primary Key:** {order_id, item_id}
- **Foreign Keys:**
  - order_id → Order(order_id)
  - item_id → Item(item_id)

---

## Key Relationships Summary
```
Super Keys (All possible unique identifiers)
    ↓
Candidate Keys (Minimal super keys)
    ↓
┌───────────┴───────────┐
│                       │
Primary Key       Alternate Keys
(Chosen one)      (Not chosen)
```

**Foreign Keys** link tables by referencing primary keys of other tables.

**Composite Keys** combine multiple attributes when needed.

**Surrogate Keys** are artificial identifiers when natural keys don't exist.

**Unique Keys** enforce uniqueness without being primary keys.