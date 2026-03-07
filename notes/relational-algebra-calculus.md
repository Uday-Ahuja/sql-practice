# Relational Algebra and Relational Calculus

## Relational Query Languages

Query languages used to retrieve and manipulate data in relational databases. Two main categories:
- **Procedural** (how to get data) - Relational Algebra
- **Non-procedural** (what data to get) - Relational Calculus

---

## Relational Algebra

**Procedural query language** - specifies **how** to retrieve data through step-by-step operations.

### Basic Operations

**1. Select (σ - Sigma)**
- Selects rows that satisfy a condition
- Syntax: `σ condition (Relation)`
- Example: `σ age>20 (Student)` - selects students older than 20

**2. Project (π - Pi)**
- Selects specific columns, removes duplicates
- Syntax: `π column1, column2 (Relation)`
- Example: `π name, age (Student)` - shows only name and age columns

**3. Union (∪)**
- Combines tuples from two relations (removes duplicates)
- Relations must be union-compatible (same number/type of attributes)
- Syntax: `R ∪ S`
- Example: `CS_Students ∪ IT_Students` - all students from both departments

**4. Set Difference (−)**
- Tuples in first relation but not in second
- Syntax: `R − S`
- Example: `All_Students − Passed_Students` - students who failed

**5. Cartesian Product (×)**
- Combines every tuple of R with every tuple of S
- Syntax: `R × S`
- If R has m tuples and S has n tuples, result has m×n tuples
- Example: `Student × Course` - all possible student-course combinations

**6. Rename (ρ - Rho)**
- Renames relation or attributes
- Syntax: `ρ new_name (Relation)`
- Example: `ρ Stud (Student)` - renames Student table to Stud

### Additional Operations (Derived from Basic)

**7. Intersection (∩)**
- Tuples common to both relations
- Syntax: `R ∩ S`
- Equivalent to: `R − (R − S)`
- Example: `CS_Students ∩ Sports_Students` - CS students who play sports

**8. Natural Join (⋈)**
- Combines relations based on common attributes
- Automatically matches columns with same name
- Syntax: `R ⋈ S`
- Example: `Student ⋈ Enrollment` - joins on common StudentID

**9. Division (÷)**
- Finds tuples in R that match ALL tuples in S
- Complex operation, rarely used
- Example: Find students enrolled in ALL courses

---

## Relational Calculus

**Non-procedural query language** - specifies **what** data to retrieve, not how.

### Tuple Relational Calculus (TRC)

**Based on tuple variables** - variables that range over tuples.

**Syntax:**
```
{ t | condition(t) }
```
Read as: "Set of all tuples t such that condition(t) is true"

**Example 1:** Find all students older than 20
```
{ t | t ∈ Student ∧ t.age > 20 }
```

**Example 2:** Find names of students in CS department
```
{ t.name | t ∈ Student ∧ t.dept = 'CS' }
```

**Example 3:** Find students enrolled in course 'DBMS'
```
{ s | s ∈ Student ∧ ∃e ∈ Enrollment (e.studentID = s.studentID ∧ e.course = 'DBMS') }
```
Uses existential quantifier (∃) - "there exists"

**Quantifiers in TRC:**
- **∃ (Exists)** - at least one tuple satisfies condition
- **∀ (For all)** - all tuples satisfy condition

---

### Domain Relational Calculus (DRC)

**Based on domain variables** - variables that range over attribute values (domains).

**Syntax:**
```
{ <x1, x2, ..., xn> | condition(x1, x2, ..., xn) }
```

**Example 1:** Find student names and ages where age > 20
```
{ <n, a> | ∃id, d (Student(id, n, a, d) ∧ a > 20) }
```
Where: id=studentID, n=name, a=age, d=department

**Example 2:** Find names of CS students
```
{ <n> | ∃id, a (Student(id, n, a, 'CS')) }
```

**Difference from TRC:**
- TRC uses tuple variables (entire row)
- DRC uses domain variables (individual attribute values)
- DRC more granular, TRC more intuitive

---

## Comparison: Algebra vs Calculus

| Aspect | Relational Algebra | Relational Calculus |
|--------|-------------------|---------------------|
| **Type** | Procedural | Non-procedural |
| **Focus** | How to get data | What data to get |
| **Operations** | Step-by-step | Declarative |
| **Ease** | More complex | More intuitive |
| **SQL Relation** | Foundation for implementation | Foundation for concept |

**SQL is based on both:**
- SELECT statement semantics from relational calculus
- Query execution uses relational algebra operations

---

## Practical Examples

### Example Database:
```
Student(StudentID, Name, Age, Department)
Course(CourseID, CourseName, Credits)
Enrollment(StudentID, CourseID, Grade)
```

### Query: "Find names of CS students enrolled in DBMS course"

**Relational Algebra:**
```
π Name (σ Department='CS' (Student) ⋈ Enrollment ⋈ σ CourseName='DBMS' (Course))
```

**Tuple Relational Calculus:**
```
{ t.Name | t ∈ Student ∧ t.Department = 'CS' ∧ 
  ∃e ∈ Enrollment, c ∈ Course 
  (e.StudentID = t.StudentID ∧ e.CourseID = c.CourseID ∧ c.CourseName = 'DBMS') }
```

**Domain Relational Calculus:**
```
{ <n> | ∃sid, a (Student(sid, n, a, 'CS') ∧ 
  ∃cid, g (Enrollment(sid, cid, g) ∧ Course(cid, 'DBMS', cr))) }
```

**SQL (Actual Implementation):**
```sql
SELECT s.Name 
FROM Student s
JOIN Enrollment e ON s.StudentID = e.StudentID
JOIN Course c ON e.CourseID = c.CourseID
WHERE s.Department = 'CS' AND c.CourseName = 'DBMS';
```

---

## Key Takeaways

1. **Relational Algebra** = procedural, operations-based, shows execution steps
2. **Tuple Calculus** = declarative, tuple-based variables, focuses on result
3. **Domain Calculus** = declarative, domain-based variables, more granular
4. All three are **equivalent in expressive power** - can express same queries
5. SQL combines best of both worlds - calculus-like syntax with algebra-based execution

---

## Why Learn These?

- **Foundation of SQL** - understanding these helps write better queries
- **Query Optimization** - knowing algebra helps understand how databases execute queries
- **Theoretical Understanding** - comprehend relational model fundamentals
- **Interview Questions** - commonly asked in database courses and job interviews