# Database Design, Analysis & Normalization

---

## 1. Database Basics

**Database** — organized collection of related data stored on servers.

**Goal of relational design** — store info without redundancy; allow accurate, easy retrieval.

**Poor design causes** — data redundancy, inconsistency, slow performance, hard maintenance.

---

## 2. Database Development Life Cycle (DDLC)

8-step cycle. Maintenance often loops back to earlier phases.

| Step | Name | Output / Focus |
|------|------|----------------|
| 1 | Planning | Mission statement; feasibility (technical, economic, operational) |
| 2 | Analysis | Requirement specification document; user use cases |
| 3 | Conceptual Design | ER Diagram; high-level model |
| 4 | Logical Design | Tables, PKs, FKs, normalization, integrity constraints |
| 5 | Physical Design | DBMS-specific: data types, indexing, storage, performance |
| 6 | Implementation | Install DBMS, create DB, load/convert data |
| 7 | Testing | Queries, transactions, performance, security checks |
| 8 | Deployment & Maintenance | Production rollout, backups, bug fixes, updates |

---

## 3. Functional Dependencies (FDs)

**FD (X → Y)** — X (determinant) uniquely determines Y (dependent).

| Type | Definition | Example |
|------|-----------|---------|
| Trivial | Y ⊆ X | ABC → AB |
| Non-Trivial | Y ⊄ X | ID → Name |
| Full FD | Non-prime attr depends on *whole* composite key | — |
| Partial Dependency | Non-prime attr depends on *part* of composite PK | — |
| Transitive Dependency | A → B and B → C, so A → C | — |
| Multivalued Dependency (MVD) | One value of A determines a *set* of B and C values, independent of each other | — |

### Armstrong's Axioms

**Primary (core rules):**
- **Reflexivity** — if Y ⊆ X, then X → Y
- **Augmentation** — if X → Y, then XZ → YZ
- **Transitivity** — if X → Y and Y → Z, then X → Z

**Secondary (derived):**
- Union, Decomposition, Pseudo-transitivity, Composition

### Keys
- **Candidate Key** — minimal set of attributes that uniquely identifies a row
- **Primary Key** — chosen candidate key

---

## 4. Database Anomalies

Caused by poor design, lack of normalization, redundancy.

| Anomaly | Description | Example |
|---------|-------------|---------|
| Insertion | Can't insert data without unrelated required data | Can't add department without a student enrolled |
| Deletion | Deleting a row removes unrelated useful info | Deleting last student in branch deletes branch info |
| Update | Changing one fact requires many row updates; risks inconsistency | Updating dept name across 100 rows |

---

## 5. Normalization

Systematic process to minimize redundancy and eliminate anomalies.

| Normal Form | Condition |
|-------------|-----------|
| **1NF** | All attributes atomic (no repeating groups, no multi-valued cells) |
| **2NF** | In 1NF + no partial dependencies (every non-prime attr depends on *full* PK) |
| **3NF** | In 2NF + no transitive dependencies. Every non-trivial X → Y: X is superkey OR Y is prime attr |
| **BCNF** | Stronger 3NF — every determinant must be a candidate key |
| **4NF** | In BCNF + no non-trivial multivalued dependencies |
| **5NF** | In 4NF + no join dependencies (table can't be split and re-joined without data loss) |

> 5NF also called **PJNF** (Project-Join Normal Form).

### Dependency → Normal Form Map
```
Partial Dependency   → violates 2NF
Transitive Dependency → violates 3NF
Determinant not CK   → violates BCNF
Multivalued Dependency → violates 4NF
Join Dependency      → violates 5NF
```