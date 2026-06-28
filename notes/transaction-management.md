# Transaction Management

---

## 1. Transaction

**Transaction** — a sequence of DB operations (read/write/update/delete) executed as a single logical unit.

### ACID Properties

| Property | Meaning |
|----------|---------|
| **Atomicity** | All or nothing — if partial failure, rollback all changes |
| **Consistency** | DB moves from one valid state to another; all integrity constraints preserved |
| **Isolation** | Concurrent transactions are unaware of each other; intermediate results hidden |
| **Durability** | Committed changes persist permanently, even after crash |

---

## 2. DB Architecture (Transaction Relevant)

| Component | Role |
|-----------|------|
| Buffer Manager | Holds data in RAM buffers before flushing to disk |
| Log Manager | Records all modifications to stable storage before applying them |
| Recovery Manager | Uses log / shadow pages to ensure atomicity and durability |

---

## 3. Schedules

**Schedule** — chronological ordering of operations from concurrent transactions.

| Type | Description | Consistency |
|------|-------------|-------------|
| **Serial** | Transactions run one after another, no interleaving | Always consistent |
| **Non-Serial** | Operations interleaved across transactions | Not guaranteed — needs serializability check |

---

## 4. Serializability

A non-serial schedule is **correct** if it is equivalent to some serial schedule.

### Conflict Serializability (CS)

Two operations **conflict** if:
- They belong to **different** transactions
- They access the **same data item**
- At least one is a **write**

**Testing via Precedence Graph:**
- Node for each transaction
- Edge Ti → Tj if Ti has a conflicting op on the same item before Tj
- **Acyclic graph** → schedule is Conflict Serializable

> If a schedule is CS → it is also View Serializable (CS ⊆ VS)

---

### View Serializability (VS)

View equivalent to a serial schedule if:

1. **Initial Read** — same transaction reads initial value of each item
2. **Intermediate Read** — if Ti reads a value written by Tj in one schedule, same in the other
3. **Final Write** — same transaction performs the last write on each item

> VS is a superset of CS — some schedules are VS but not CS (blind writes).

---

## 5. Concurrency Problems

| Problem | Description |
|---------|-------------|
| **Dirty Read** | Transaction reads uncommitted data written by another transaction |
| **Lost Update** | Two transactions update same item; one overwrites the other's change |
| **Unrepeatable Read** | Same read gives different result within a transaction (another TX committed in between) |
| **Phantom Read** | A re-executed query returns new rows inserted by another committed transaction |

---

## 6. Dirty Read → Schedule Classification

### Flowchart 1 — Recoverable vs Irrecoverable
Dirty read?
├── NO  → Recoverable ✅
└── YES → Commit order correct? (writer commits before reader)
├── YES → Recoverable ✅
└── NO  → Irrecoverable ❌

### Flowchart 2 — Cascadeless vs Cascading
Dirty read?
├── NO  → Cascadeless & Recoverable ✅
└── YES → Cascading rollback possible
└── Commit order correct?
├── YES → Recoverable (but cascading) ⚠️
└── NO  → Irrecoverable ❌
**Recoverable** — writer commits before reader commits.  
**Cascadeless** — no dirty reads at all; transactions only read committed data.  
**Irrecoverable** — reader commits before writer; cannot undo if writer fails.

---

## 7. Cascaded Aborts

If T1 fails → T2 (which read T1's dirty data) must also abort → T3 (which read T2's dirty data) aborts → chain reaction.

**Cascadeless schedules** prevent this by disallowing dirty reads entirely.

---

## 8. Locking Methods

| Lock | Access | Multiple holders? |
|------|--------|-------------------|
| **Shared (S)** | Read only | Yes |
| **Exclusive (X)** | Read + Write | No |

### Two-Phase Locking (2PL)

| Phase | Action |
|-------|--------|
| **Growing** | Acquire locks, cannot release any |
| **Shrinking** | Release locks, cannot acquire new ones |

**Strict 2PL** — all exclusive locks held until commit/abort. Prevents cascading rollbacks.

---

## 9. Deadlocks

**Deadlock** — cycle of transactions each waiting for a lock held by the next.

Example: T3 holds B, waits for A. T4 holds A, waits for B. Neither progresses.

| Strategy | Method |
|----------|--------|
| **Detection** | Maintain wait-for graph; check for cycles periodically |
| **Prevention** | Protocols that ensure cycles never form |
| **Recovery** | Roll back one transaction to break the cycle |

---

## 10. Timestamp-Based Concurrency Control

Each transaction gets a unique timestamp at start. Conflicts resolved by timestamp order.

- If Ti tries to read/write an item already accessed by a newer transaction → Ti is rolled back and restarted.
- **Thomas' Write Rule** — obsolete writes are ignored instead of causing rollback → allows some view serializable schedules.

---

## 11. Optimistic Concurrency Control

Assumes conflicts are rare.

1. **Read phase** — execute fully using local buffers
2. **Validation phase** — check if serializability was violated
3. **Write phase** — apply updates if valid; else rollback

---

## 12. Multi-Version Concurrency Control (MVCC)

- Each write creates a **new version** of the data item, timestamped.
- Reads fetch the **appropriate version** based on transaction timestamp.
- Reads never block — a valid version always exists.

---

## 13. Shadow Paging (Crash Recovery)

Maintains two page tables:
- **Shadow page table** — points to last consistent state; never modified during transaction
- **Current page table** — modified during transaction

On **commit** → shadow table updated to current.  
On **failure** → discard current table, revert to shadow. No undo/redo needed.

---

## 14. Log-Based Recovery

Log on stable storage records every change before it is applied.

| Type | When updates hit DB | On failure: needs |
|------|---------------------|-------------------|
| **Deferred Update** | Only after commit | Redo committed TXs only |
| **Immediate Update** | Before commit allowed | Undo uncommitted + Redo committed |

---

## 15. Checkpoints

Periodically:
1. Flush log records from RAM → stable storage
2. Flush modified pages → disk
3. Write checkpoint record to log

Recovery only scans log **from last checkpoint** — not the entire log. Reduces recovery time significantly.