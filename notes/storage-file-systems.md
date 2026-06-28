# Storage and File Systems

---

## 1. File Organization

How records are physically arranged on disk.

| Type | Order | Insertion | Search | Best For |
|------|-------|-----------|--------|----------|
| **Heap** | None | Fast (append) | Slow (linear scan) | Bulk inserts |
| **Sequential** | Sorted by search key | Slow (shift to maintain order) | Fast (binary search) | Range queries |
| **Hashed** | By hash function → bucket | Fast | Fast (exact match only) | Equality lookups |
| **Clustered** | Related records from different relations stored together | — | Fast for joins | Frequent joins |

---

## 2. Indices

Index — smaller lookup structure pointing to actual data records. Like a book index.

### Types

| Index | Built On | Must Be | Why |
|-------|----------|---------|-----|
| **Primary** | Primary key (file sorted by it) | Sparse (usually) | One entry per block is enough |
| **Secondary** | Any non-key attribute | Dense | Data not sorted → every value needs an entry |

### Dense vs Sparse

| | Dense | Sparse |
|--|-------|--------|
| Entries | One per every search-key value | One per disk block |
| Space | More | Less |
| Speed | Faster lookup | Slightly slower (scan block after nearest entry) |

### Multilevel Index

Primary index too large for memory → build an outer index on top of the index file. Repeat as needed.

---

## 3. Static Hashing

Fixed number of buckets at creation time.

- **Hash function** h(key) → bucket address (e.g., key mod 5)
- **Bucket** — one disk block; stores one or more records
- **Overflow** — bucket full → **chaining** (linked overflow buckets)

**Problem** — DB size changes → wasted space or deep overflow chains. Not flexible.

---

## 4. Dynamic Hashing (Extendible Hashing)

Hash structure grows/shrinks as records change.

- **Directory** — array of pointers to buckets; size = 2^(Global Depth)
- **Global Depth (k)** — number of bits used to index the directory
- **Local Depth** — per-bucket; how many bits identify that bucket

**On overflow:**
- Local Depth < Global Depth → split bucket, update pointers
- Local Depth = Global Depth → **double the directory** (Global Depth + 1), then split

> **Linear Hashing** — alternative dynamic method; grows one bucket at a time instead of doubling a directory.

---

## 5. B-Trees

Self-balancing m-way search tree for disk-based storage.

**Properties:**
- Every node (except root) at least half-full
- All leaf nodes at the same level (balanced)
- Node with n keys has n+1 children
- Internal nodes store both keys and child pointers

**Operations:**

| Operation | Behavior |
|-----------|----------|
| Search | Follow keys down tree to correct child subtree |
| Insert | Add to leaf in sorted order; if node exceeds m-1 keys → **split**, push middle key up |
| Delete | If node drops below minimum → **borrow from sibling** (rotation) or **merge with sibling**; may propagate up |

---

## 6. B+ Trees

Extension of B-Trees. Standard for DB indexing.

**Key differences from B-Tree:**

| | B-Tree | B+ Tree |
|--|--------|---------|
| Data pointers | In all nodes | **Leaf nodes only** |
| Internal nodes | Keys + data ptrs | Keys only (navigation) |
| Leaf linking | No | **Linked list across all leaves** |

**Why preferred:**
- **Higher fan-out** — internal nodes smaller → more keys per block → shallower tree → fewer disk accesses
- **Range queries** — find range start via tree, then scan linked leaves linearly

---

## 7. Query Processing Overview

SQL → Relational Algebra → Optimized Plan → Result

| Step | What Happens |
|------|-------------|
| **Parsing & Translation** | Syntax check, verify relations/attrs in data dictionary, convert to relational algebra |
| **Optimization** | Query optimizer estimates cost of multiple plans using statistics, picks cheapest |
| **Evaluation** | Runtime processor executes the chosen plan |

---

## 8. Query Cost

Primary metric — **Disk I/O** (disk is far slower than RAM/CPU).

**Cost = (b × tT) + (S × tS)**

| Symbol | Meaning |
|--------|---------|
| b | Number of block transfers |
| tT | Transfer time per block |
| S | Number of disk seeks |
| tS | Seek time |

Goal — minimize disk accesses.

---

## 9. Selection Algorithms

| Algorithm | Condition | Cost |
|-----------|-----------|------|
| **Linear Scan** | Any | br (all blocks); br/2 for unique key on avg |
| **Binary Search** | File sorted on search attr | log₂(br) |
| **Index-Based** | Index exists | Typically most efficient |

---

## 10. Join Algorithms

R ⋈ S

| Algorithm | How | Cost |
|-----------|-----|------|
| **Nested Loop** | For every row in R, scan all of S | O(n × m) — very slow |
| **Block Nested Loop** | Load block of R, compare against blocks of S | Fewer disk reads than NL |
| **Indexed Nested Loop** | For each row in R, use index on S to find matches | Fast if index exists |
| **Merge Join** | Both tables sorted on join column; single merge pass | Efficient; needs sorted input |
| **Hash Join** | Hash both on join column; matching rows land in same bucket | Efficient for large unsorted tables |

---

## 11. Evaluation of Expressions

When a query has multiple operations:

| Method | How | Tradeoff |
|--------|-----|----------|
| **Materialization** | Evaluate one op → store result in temp file → pass to next op | Simple; more disk I/O |
| **Pipelining** | Output of one op fed directly to next op on-the-fly; no temp storage | Faster; less space; more complex |