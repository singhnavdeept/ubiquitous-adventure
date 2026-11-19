# Degree, Cardinality, Schema vs. Instance, and Domains — GATE-Ready Guide

These four concepts form the **vocabulary foundation** of the relational model. GATE regularly asks direct definitional MCQs and uses them implicitly in normalization/indexing questions. Let's cover each with the PDF's treatment (where present) plus full expansion.

---

## 1. Degree (Arity)

### PDF Coverage (Page 4, Section 1.3.1)
> **Arity:** Number of attributes of database table.

### Full Treatment
**Degree (also called Arity)** = the **number of attributes (columns)** in a relation.

- Notation: If R(A₁, A₂, ..., Aₙ), then **degree(R) = n**.
- Also called **arity** — the two terms are **synonymous** in GATE.
- A relation of degree 1 is **unary**; degree 2 is **binary**; degree n is **n-ary**.

**Examples:**
- `Student(Sid, Sname, Age)` → degree = **3**
- `Enroll(Sid, Cid, Fee)` → degree = **3**
- `R(A)` → degree = **1** (unary)

**Relational Algebra connection:** Degree of a result relation:
- π (projection): **reduces or maintains** degree (keeps only listed attributes)
- σ (selection): **degree unchanged** (filters rows only)
- × (cross product): degree(R × S) = **degree(R) + degree(S)**
- ⋈ (natural join): degree(R ⋈ S) = degree(R) + degree(S) − (number of common attributes)
- ∪, ∩, −: **degree unchanged** (union-compatible)

> **GATE Trap:** "Degree of a relation after projection π_A,B(R) where R has 5 attributes" → **2**, not 5. Projection *reduces* degree. Selection *never* changes degree.

> **GATE Trap:** In natural join R(A,B,C) ⋈ S(B,C,D): common attributes = {B, C} = 2. Degree = 3 + 3 − 2 = **4** (result: A, B, C, D).

---

## 2. Cardinality

### PDF Coverage (Page 4, Section 1.3.2 — misspelled as "Cordinality")
> **Cardinality:** Number of records of database table.

### Full Treatment
**Cardinality** = the **number of tuples (rows/records)** in a relation *instance*.

- Notation: If R currently has 5 tuples, cardinality(R) = **5**.
- Cardinality **changes over time** as tuples are inserted/deleted — it is a property of the *instance*, not the *schema*.
- Cardinality can be **0** (empty relation) — a valid relation with zero tuples.

**Examples:**
- `Student` with 100 rows → cardinality = **100**
- Empty table → cardinality = **0** (but degree is still defined!)

**Relational Algebra connection:**
- σ (selection): cardinality **≤** original (0 to n)
- π (projection): cardinality **≤** original (duplicates removed in set semantics)
- × (cross product): |R × S| = **|R| × |S|**
- ⋈ (natural join): 0 to |R| × |S|
- ∪: max(|R|, |S|) to |R| + |S|

> **GATE Trap — Degree vs. Cardinality:**  
> A relation with **degree 0** and **cardinality 0**?  
> Degree 0 = no attributes (nullary relation) — possible in theory (a relation with only the empty tuple or no tuples).  
> Cardinality 0 = empty relation.  
> **Key distinction:** Degree is fixed by schema; cardinality varies with data.

> **GATE Trap — "Cardinality of a column":** Sometimes questions say "cardinality of attribute A" meaning the **number of distinct values** in column A. E.g., if A = {1,1,2,3,3}, cardinality of A = **3 distinct values**. This is *different* from relation cardinality. Context determines which is meant.

---

## 3. Schema vs. Instance

This is **not explicitly in the PDF** but is **foundational** and GATE has asked about it. Let's build it fully.

### 3.1 Schema (Intension)

**Schema** = the **logical structure/design** of the database — the *definition* of relations, their attributes, domains, and constraints. It is **time-invariant** (rarely changes).

**Types of schema:**
1. **Database Schema:** Overall logical structure of the entire database.
2. **Relation Schema:** Structure of one relation — e.g., `Student(Sid: integer, Sname: string, Age: integer)`.
3. **Physical Schema:** How data is stored on disk (file organization, indexes).
4. **View Schema:** Virtual tables derived from base tables.

**In SQL:** The schema is defined by `CREATE TABLE` statements:
```sql
CREATE TABLE Student (
  Sid INT PRIMARY KEY,
  Sname VARCHAR(50),
  Age INT
);
```
This is the **schema** — it describes *what* the table looks like, not *what data* it currently holds.

### 3.2 Instance (Extension)

**Instance** = the **actual data (set of tuples)** currently stored in the relation at a given moment. It is **time-varying** — changes with every INSERT/DELETE/UPDATE.

**Example instance of Student:**

| Sid | Sname | Age |
|---|---|---|
| 1 | Alice | 20 |
| 2 | Bob | 22 |
| 3 | Carol | 21 |

This specific set of 3 rows is the **instance** at this moment.

### 3.3 Schema vs. Instance — Comparison Table

| Aspect | **Schema** | **Instance** |
|---|---|---|
| Also called | Intension | Extension |
| Defines | Structure (attributes, domains, constraints) | Actual data (tuples) |
| Changes | Rarely (only on DDL: ALTER, CREATE, DROP) | Frequently (DML: INSERT, DELETE, UPDATE) |
| Analogy | Blueprint of a house | People currently living in it |
| Specified by | `CREATE TABLE` (DDL) | `INSERT` (DML) |
| Example | `Student(Sid, Sname, Age)` | `{(1,Alice,20), (2,Bob,22)}` |
| Cardinality | Not applicable (no data) | = number of tuples |
| Degree | = number of attributes | Same as schema's degree |

> **GATE Angle:** "The intension of a relation corresponds to ___" → **Schema**. "The extension corresponds to ___" → **Instance**.

> **Program-Data Independence:** Because schema is separate from instance, changing the instance (data) doesn't require changing programs. This is the **data independence** principle the PDF alludes to in Section 1.2 (file system limitation: "physical details managed by user").

### 3.4 Three-Schema Architecture (GATE Expansion)

The ANSI/SPARC architecture defines three levels — all are "schemas":

| Level          | Schema          | What it describes                                                        |
| -------------- | --------------- | ------------------------------------------------------------------------ |
| **External**   | View schema     | What each user/application sees                                          |
| **Conceptual** | Logical schema  | Entire DB structure (tables, constraints) — the "schema" in common usage |
| **Internal**   | Physical schema | Storage details (files, indexes, blocks)                                 |

**Mappings:** External↔Conceptual (logical data independence), Conceptual↔Internal (physical data independence).

---

## 4. Domain

### Full Treatment (not in PDF explicitly, but essential)

**Domain** = the **set of all possible atomic values** that an attribute can take. It defines the **data type and valid value range** for a column.

**Examples:**
- `Age` attribute → domain = set of positive integers (say 0–150)
- `Sname` → domain = set of all valid strings (say up to 50 characters)
- `Gender` → domain = {Male, Female, Other}
- `Sid` → domain = set of 4-digit integers, etc.

**Properties of domains:**
1. **Atomic:** Each value in a domain is indivisible (this is what 1NF enforces — PDF Section 1.9.1: "Every attribute of R must be atomic/single valued").
2. **Type-consistent:** All values in a column must come from the *same* domain.
3. **NULL:** NULL is a special marker (not a value from the domain) meaning "unknown" or "not applicable" — it is **not** part of any domain.

### 4.1 Domain and Union Compatibility (Direct GATE Link — PDF Page 20)

The PDF's Section 3.6 states: *"To apply set operations relations must be union computable. (i) Arity of R equal to Arity of S and (ii) Domain of attributes of R must be same as domain of attributes of S respectively."*

So **domain** is the criterion for union compatibility:

**R(A, B) and S(C, D) are union-compatible iff:**
- degree(R) = degree(S) [same arity], **AND**
- domain(A) = domain(C) and domain(B) = domain(D) [corresponding domains match]

**Example (from PDF):**
- π_Sid,Sname(Student) ∩ π_Sid,marks(Marks) → **NOT allowed** (Sname and marks have different domains, even though arity = 2)
- π_Sid,Sname(Student) ∩ π_ID,Studname(Student2) → **Allowed** (same arity, same domains)

> **GATE Trap:** Arity match is **necessary but not sufficient** for set operations. **Domains must also match** column-wise.

### 4.2 Domain and Referential Integrity

The PDF's FK definition (Page 5) says a foreign key "references primary key or alternative key." For this to make sense, the FK's **domain must match** the referenced key's domain. E.g., `Enroll.Sid` must have the same domain as `Student.Sid` — otherwise comparison is meaningless.

### 4.3 Domain and Functional Dependencies

When we write X → Y, the attributes in X and Y draw values from their respective domains. Domain constraints are **independent** of FDs — FDs are about *value relationships*, domains are about *permissible values*. A relation can satisfy all domain constraints yet violate an FD (if data is bad), which is why FDs are *constraints* checked separately.

---

## 5. Putting It All Together — One Comprehensive Example

**Schema:**
```
Student(Sid: INT, Sname: VARCHAR(50), Age: INT, Dept: VARCHAR(10))
```
- **Degree** = 4 (four attributes)
- **Domains:** Sid → INT, Sname → VARCHAR(50), Age → INT, Dept → VARCHAR(10)
- **Schema** = the above definition

**Current Instance:**

| Sid | Sname | Age | Dept |
|---|---|---|---|
| 1 | Alice | 20 | CSE |
| 2 | Bob | 22 | ECE |
| 3 | Carol | 21 | CSE |

- **Cardinality** = 3 (three tuples)
- **Cardinality of Dept column** (distinct values) = 2 ({CSE, ECE})
- **Instance** = the three rows above

---

## 6. GATE-Style Practice Questions

**Q1.** A relation R has 5 attributes and 10 tuples. What are its degree and cardinality?  
→ **Degree = 5, Cardinality = 10.**

**Q2.** After π_{A,B}(R) where R(A,B,C,D) has 10 tuples, what is the maximum possible cardinality?  
→ **10** (projection removes duplicates, so ≤ 10). Degree = **2**.

**Q3.** R(A,B) with 3 tuples and S(C,D) with 4 tuples. What is the degree and cardinality of R × S?  
→ **Degree = 4, Cardinality = 12.**

**Q4.** Which of the following is time-varying: schema or instance?  
→ **Instance** (schema is time-invariant).

**Q5.** Two relations R(A: INT, B: CHAR) and S(X: INT, Y: INT) — are they union-compatible?  
→ **No.** Arity matches (2 = 2), but domain(B: CHAR) ≠ domain(Y: INT). Set operations not allowed.

**Q6.** The set of all permissible values for an attribute is called its ___  
→ **Domain.**

**Q7.** Can a relation have cardinality 0? Degree 0?  
→ **Cardinality 0: Yes** (empty relation). **Degree 0: Yes in theory** (nullary relation — no attributes; can hold at most the empty tuple). GATE rarely tests degree-0 but knows it's theoretically valid.

**Q8.** "Intension" and "Extension" of a relation refer to ___ and ___ respectively.  
→ **Schema** and **Instance**.

---

## 7. One-Line GATE Summary

> **Degree = #columns (fixed by schema); Cardinality = #rows (varies with instance); Schema = structure (intension); Instance = data (extension); Domain = set of valid atomic values per attribute (drives union compatibility).**

---

**Next in our Chapter 1 series:** We can proceed to **Section 1.5 — Referential Integrity in action** (worked ON DELETE/UPDATE CASCADE/SET NULL traces), or jump to **Section 1.6 — Functional Dependencies & Armstrong's Axioms** (the highest-yield GATE topic in this chapter). Which would you prefer?