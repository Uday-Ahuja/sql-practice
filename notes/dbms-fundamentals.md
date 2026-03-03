# DBMS Fundamentals

## What is DBMS?

**Database Management System** contains information about a particular enterprise:
- **Database** - collection of interrelated data
- **Set of programs** - to access and manage data
- **Environment** - convenient and efficient to use

**Examples of Database Applications:**
- Banking systems
- University records
- E-commerce platforms
- Library management systems

---

## Drawbacks of File Systems

**Why not use file systems to store data?**

1. **Data Redundancy and Inconsistency**
   - Same data duplicated in multiple files
   - Updates in one place don't reflect everywhere

2. **Difficulty in Accessing Data**
   - Need to write new programs for each new query
   - No standard interface for data retrieval

3. **Data Isolation**
   - Data scattered in different files and formats
   - Hard to retrieve related information

4. **Integrity Problems**
   - Constraints become buried in application code
   - Hard to add new constraints or change existing ones

5. **Atomicity of Updates**
   - Transactions must be "all or nothing"
   - Example: Money transfer must either complete fully or not happen at all

6. **Concurrent Access Issues**
   - Multiple users accessing data simultaneously needed for performance
   - Uncontrolled concurrent access leads to inconsistencies
   - Example: Two people withdrawing money from same account at same time

7. **Security Problems**
   - Hard to provide selective user access to specific data
   - Difficult to enforce access control policies

**DBMS solves all these problems.**

---

## Levels of Data Abstraction

DBMS provides three levels of abstraction to hide complexity:

### 1. Physical Level
- **How** data is actually stored
- Describes physical storage structures
- Example: Marks stored as float, name stored as string, indexing methods

### 2. Logical/Conceptual Level
- **What** data is stored and relationships between data
- Describes database schema and structure
- Example: How marks/CGPA and grades are related, table structures, constraints

### 3. View/External Level
- **User-specific** views of data
- Application programs hide data type details
- Different users see different views of same database
- Example: Student sees only their grades, admin sees all student records

---

## Instances and Schemas

### Schemas (Structure)

**Logical Schema:**
- Overall logical structure of database
- Defines tables, attributes, relationships, constraints
- Example: Student(rollno, name, marks, grade)

**Physical Schema:**
- How data is physically stored
- Storage structures, indexes, file organization

### Instance (Content)

- Actual content of database at a particular point in time
- Analogous to value of a variable
- Changes frequently as data is inserted/updated/deleted

---

## Data Independence

### Physical Data Independence

- Ability to modify **physical schema** without changing **logical schema**
- Changes in storage structures don't affect application programs

**Example:**
- Running factorial program on college PC (HDD) vs laptop (SSD)
- Storage device changes but program logic remains same
- Changing from sequential files to indexed files - queries remain same

### Logical Data Independence

- Ability to modify **logical schema** without changing **external schema/views**
- Changes in table structure don't affect user views

**Example:**
- Changing CGPA slabs for grade calculation (8.5→9.0 for A grade)
- Attributes visible to users remain unchanged
- Adding new tables to database - existing applications unaffected
- Splitting a table into two tables - views can hide this change

---

## Key Takeaway

**Three-Schema Architecture:**
```
View Level (External Schema)
         ↓
Logical Level (Conceptual Schema)
         ↓
Physical Level (Internal Schema)
```

Each level provides **independence** from the level below it, making database systems flexible and maintainable.
## Data Models

**Data Model** = Collection of tools for describing:
- Data
- Data relationships
- Data semantics
- Data constraints

### Types of Data Models

**1. Relational Model**
- Data organized in tables (relations)
- Most widely used model
- Example: MySQL, PostgreSQL, Oracle

**2. Entity-Relationship (ER) Model**
- Conceptual data model
- Uses entities, attributes, and relationships
- Used for database design

**3. Object-Based Model**
- Data stored as objects (like in OOP)
- Combines database capabilities with OOP features
- Example: Object-relational databases

**4. Semi-Structured Data Model**
- Data that doesn't fit rigid schema
- Example: XML, JSON
- Flexible structure, self-describing data

**5. Older Models (Legacy)**
- **Network Model** - data organized as graph
- **Hierarchical Model** - data organized as tree

---

## Relational Model Terminology

| Database Term | Relational Term | Analogy          |
|---------------|-----------------|------------------|
| Table         | Relation        | Spreadsheet      |
| Row           | Tuple           | Record           |
| Column        | Attribute       | Field            |

**Example:**
```
Student Table (Relation)
┌─────────┬──────────┬────────┐
│ Roll No │ Name     │ Marks  │  ← Attributes (Columns)
├─────────┼──────────┼────────┤
│ 101     │ Alice    │ 85     │  ← Tuple (Row)
│ 102     │ Bob      │ 90     │  ← Tuple (Row)
└─────────┴──────────┴────────┘
```