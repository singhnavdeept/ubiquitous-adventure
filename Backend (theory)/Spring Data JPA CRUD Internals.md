---
title: "Spring Data JPA CRUD Internals & Implementation"
tags:
  - java
  - spring-boot
  - jpa
  - hibernate
  - crud
  - database
created: 2026-06-05
type: study-note
---

# 🗄️ Spring Data JPA CRUD Internals & Implementation

This guide provides an in-depth explanation of how CRUD (Create, Read, Update, Delete) is implemented in **Spring Boot** using **Spring Data JPA** and **Hibernate**. It details the repository hierarchy, method execution internals, derived query parsing, custom query annotations, and Hibernate entity states.

---

## 📂 Table of Contents
1. [The Spring Data JPA Repository Hierarchy](#1-the-spring-data-jpa-repository-hierarchy)
2. [Out-of-the-Box CRUD Methods under the Hood](#2-out-of-the-box-crud-methods-under-the-hood)
3. [Derived Query Generation (Method Signatures)](#3-derived-query-generation-method-signatures)
4. [Custom Queries: JPQL vs. Native SQL](#4-custom-queries-jpql-vs-native-sql)
5. [Hibernate Entity Lifecycle States (Crucial for Updates)](#5-hibernate-entity-lifecycle-states-crucial-for-updates)
6. [Pagination, Sorting, & Transaction Management](#6-pagination-sorting--transaction-management)

---

## 🏛️ 1. The Spring Data JPA Repository Hierarchy

Spring Data JPA provides interfaces that abstract away boilerplate database access code. You define an interface, and Spring creates a dynamic proxy implementation at runtime.

```
                  Repository<T, ID>  (Marker Interface)
                         ^
                         |
                CrudRepository<T, ID> (Basic CRUD Operations)
                         ^
                         |
         PagingAndSortingRepository<T, ID> (Pagination & Sorting)
                         ^
                         |
                ListCrudRepository<T, ID>
                         ^
                         |
                 JpaRepository<T, ID> (JPA-Specific: Flush, Batch, Custom mapping)
```

### Key Interfaces and Roles:
1. **`Repository<T, ID>`**: The root interface. It has no methods; it is a marker interface used by Spring to locate candidate repository beans during component scanning.
2. **`CrudRepository<T, ID>`**: Adds basic CRUD operations (e.g., `save()`, `findById()`, `deleteById()`).
3. **`PagingAndSortingRepository<T, ID>`**: Extends repository capabilities to support pagination (`Pageable`) and sorting (`Sort`).
4. **`JpaRepository<T, ID>`**: Inherits all the above and adds JPA-specific features such as:
   - `flush()`: Flushes pending changes immediately to the database.
   - `saveAndFlush()`: Saves and flushes in a single call.
   - `deleteInBatch()`: Performs bulk SQL deletes (e.g., `DELETE FROM table`), which is much faster than standard deletes that load and remove entities one by one.

---

## ⚙️ 2. Out-of-the-Box CRUD Methods under the Hood

When you inject a `JpaRepository` interface, the runtime proxy directs calls to Hibernate's `EntityManager`. Here is how they operate under the hood:

### 1. `save(S entity)` (Create / Update)
The `save()` method does double duty. It handles both **Inserts** and **Updates** by checking the entity state:
- **How it works**:
  ```java
  // Simplified SimpleJpaRepository implementation
  @Transactional
  public <S extends T> S save(S entity) {
      if (entityInformation.isNew(entity)) {
          entityManager.persist(entity); // Triggers SQL INSERT
          return entity;
      } else {
          return entityManager.merge(entity); // Triggers SQL UPDATE / SELECT
      }
  }
  ```
- **Entity State Check**: Spring determines if an entity is "new" by checking if its primary key (ID) is `null` (or `0` for primitives). If it has an ID, Spring assumes it exists in the database and calls `merge(entity)`.

### 2. `findById(ID id)` (Read)
- **How it works**: Calls `entityManager.find(Class<T> entityClass, Object primaryKey)`.
- **Optional Wrapper**: It returns `java.util.Optional<T>` instead of raw type `T`. This forces the developer to handle the "resource not found" scenario cleanly, preventing `NullPointerException` bugs.
  ```java
  Student student = studentRepository.findById(1L)
      .orElseThrow(() -> new ResourceNotFoundException("Student not found"));
  ```

### 3. `deleteById(ID id)` (Delete)
- **How it works**:
  1. It first executes a `SELECT` query to load the entity: `findById(id)`.
  2. If the entity exists, it calls `entityManager.remove(entity)`.
  - **Performance Note**: This is a safe delete but involves a roundtrip to the DB (SELECT followed by DELETE). For high-performance batch operations, write a custom query like `deleteInBatch()`.

---

## 🔍 3. Derived Query Generation (Method Signatures)

One of Spring Data JPA's most powerful features is **Query Methods**. Spring parses the method name of your repository interface at application startup and builds the Abstract Syntax Tree (AST) to generate the SQL query dynamically.

### Parsing Rules:
Method names must follow the convention: `find[Subject]By[Predicate]`:
* **Subject**: Optional (e.g. `find`, `read`, `query`, `count`, `get`). You can add modifiers like `findFirst3` or `findDistinct`.
* **Predicate**: The criteria columns joined by logical operators.

### Common Derived Query Patterns:
```java
public interface StudentRepository extends JpaRepository<Student, Long> {
    
    // SQL: SELECT * FROM students WHERE email = ?
    Optional<Student> findByEmail(String email);

    // SQL: SELECT * FROM students WHERE name = ? AND age = ?
    List<Student> findByNameAndAge(String name, Integer age);

    // SQL: SELECT * FROM students WHERE age > ? ORDER BY name ASC
    List<Student> findByAgeGreaterThanOrderByNameAsc(Integer age);

    // SQL: SELECT * FROM students WHERE email LIKE '%@gmail.com'
    List<Student> findByEmailEndingWith(String suffix);

    // SQL: SELECT * FROM students WHERE LOWER(name) = LOWER(?)
    List<Student> findByNameIgnoreCase(String name);
}
```

---

## 📝 4. Custom Queries: JPQL vs. Native SQL

For complex queries (e.g., joins, reporting, bulk updates), derived queries become unreadable. You can write custom queries using the `@Query` annotation.

### 1. JPQL (Java Persistence Query Language)
JPQL queries **Entities (Java classes) and class variables**, not actual database tables and columns. It is database-agnostic.
```java
// Note: We use the Entity class 'Student' and variable names 'email', not database column names.
@Query("SELECT s FROM Student s WHERE s.email = :email")
Optional<Student> findByEmailCustom(@Param("email") String email);
```

### 2. Native SQL
Queries the **actual database tables and columns** directly. Useful for database-specific features (e.g. Postgres JSON/vector functions).
```java
@Query(value = "SELECT * FROM students WHERE email_address = :email", nativeQuery = true)
Optional<Student> findByEmailNative(@Param("email") String email);
```

### 3. Parameter Binding
- **Named Parameters (Recommended)**: Uses `:parameterName` matched via `@Param("parameterName")`.
- **Positional Parameters**: Uses `?1`, `?2` based on argument order.
  ```java
  @Query("SELECT s FROM Student s WHERE s.name = ?1 AND s.age = ?2")
  List<Student> findByNameAndAgePositional(String name, Integer age);
  ```

### 4. Modifying Queries (UPDATE / DELETE)
For write operations using `@Query`, you **must** annotate the method with `@Modifying`.
```java
@Modifying
@Transactional
@Query("UPDATE Student s SET s.department = :dept WHERE s.id = :id")
int updateDepartment(@Param("id") Long id, @Param("dept") String dept);
```
- **Why `@Modifying`?**: It tells Spring to execute the query as an update statement rather than a select query, returning the number of affected rows (an `int` or `void`) instead of a result list.

---

## 🔄 5. Hibernate Entity Lifecycle States

Understanding entity lifecycle states is critical for updating data correctly. Hibernate tracks all loaded entities inside its **Persistence Context (First-Level Cache)**.

```
       +------------------+
       |    TRANSIENT     | <-- new Student() (Not in DB, not tracked)
       +------------------+
                |
          save() / persist()
                v
       +------------------+
       |    PERSISTENT    | <-- Tracked by Session. Synchronizes with 
       |    (MANAGED)     |     DB at the end of transaction (Dirty Checking).
       +------------------+
           |          |
    close() /      delete()
    detach()          v
           |   +------------------+
           |   |     REMOVED      | <-- Scheduled for SQL DELETE
           v   +------------------+
       +------------------+
       |     DETACHED     | <-- In DB, but no longer tracked by session.
       +------------------+     Must call merge() to re-attach.
```

### The Power of "Dirty Checking" (Implicit Updates)
If an entity is in the **Persistent (Managed)** state (meaning it was loaded via `findById` inside an active `@Transactional` service method), **you do not need to call `save()` to update it!**
At the end of the transaction, Hibernate performs a dirty-check, identifies that fields were modified, and automatically generates and executes the SQL `UPDATE` statement.

#### Example:
```java
@Service
public class StudentService {
    
    @Autowired
    private StudentRepository repository;

    @Transactional
    public void updateAge(Long id, Integer newAge) {
        // 1. Fetching puts the object in the MANAGED state
        Student student = repository.findById(id).orElseThrow();
        
        // 2. Modifying the object directly
        student.setAge(newAge);
        
        // NO NEED to call repository.save(student);
        // Hibernate automatically detects the change and flushes SQL UPDATE on method exit.
    }
}
```

---

## 📊 6. Pagination, Sorting, & Transaction Management

For large datasets, loading all rows via `findAll()` will cause Out-Of-Memory errors. Spring Boot handles pagination natively.

### 1. Pagination & Sorting Implementation
Inject a `Pageable` parameter into your controller and pass it to the repository:

```java
// Controller Layer
@GetMapping("/paginated")
public ResponseEntity<Page<Student>> getStudents(
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size,
        @RequestParam(defaultValue = "id") String sortBy) {
            
    // Create Pageable configuration
    Pageable pageable = PageRequest.of(page, size, Sort.by(sortBy).descending());
    
    Page<Student> result = studentRepository.findAll(pageable);
    return ResponseEntity.ok(result);
}
```
Spring Data JPA executes **two SQL queries** under the hood:
1. `SELECT LIMIT ? OFFSET ?` to fetch the records for the active page.
2. `SELECT COUNT(*)` to calculate total pages and records for UI paginators.

### 2. Transaction Management (`@Transactional`)
- **`@Transactional(readOnly = true)`**: Optimizes performance for read queries. Hibernate bypasses dirty checking, disabling session snapshot caching, which saves memory.
- **Propagation**:
  - `REQUIRED` (Default): If a transaction is already active, use it. If not, create a new one.
  - `REQUIRES_NEW`: Always suspend the current transaction and spawn a separate, independent transaction block (useful for audit logging).
