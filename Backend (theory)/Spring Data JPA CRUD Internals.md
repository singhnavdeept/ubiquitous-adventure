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
  // Simplified Spring Data JPA's SimpleJpaRepository class implementation under the hood
  @Transactional // Ensures the save method executes inside a database transaction boundary
  public <S extends T> S save(S entity) {
      // Checks if the entity has no ID (meaning it is a new record)
      if (entityInformation.isNew(entity)) {
          entityManager.persist(entity); // Calls JPA EntityManager to schedule a SQL INSERT statement
          return entity; // Returns the original entity reference
      } else {
          return entityManager.merge(entity); // Calls JPA EntityManager to update the record in the DB (creates a merged copy)
      }
  }
  ```
- **Entity State Check**: Spring determines if an entity is "new" by checking if its primary key (ID) is `null` (or `0` for primitives). If it has an ID, Spring assumes it exists in the database and calls `merge(entity)`.

### 2. `findById(ID id)` (Read)
- **How it works**: Calls `entityManager.find(Class<T> entityClass, Object primaryKey)`.
- **Optional Wrapper**: It returns `java.util.Optional<T>` instead of raw type `T`. This forces the developer to handle the "resource not found" scenario cleanly, preventing `NullPointerException` bugs.
  ```java
  // Executed in Service layer
  Student student = studentRepository.findById(1L) // Searches database table for student where primary key id = 1
      // Returns an Optional. If no record matches id = 1, throws ResourceNotFoundException
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
// The interface extends JpaRepository to inherit database access methods
public interface StudentRepository extends JpaRepository<Student, Long> {
    
    // Derived query finding a single student record matching the exact email parameter
    // SQL equivalent: SELECT * FROM students WHERE email = ?
    Optional<Student> findByEmail(String email);

    // Derived query matching name and age exactly
    // SQL equivalent: SELECT * FROM students WHERE name = ? AND age = ?
    List<Student> findByNameAndAge(String name, Integer age);

    // Derived query filtering age greater than input and sorting by name ascending
    // SQL equivalent: SELECT * FROM students WHERE age > ? ORDER BY name ASC
    List<Student> findByAgeGreaterThanOrderByNameAsc(Integer age);

    // Derived query performing a suffix wildcard match on email
    // SQL equivalent: SELECT * FROM students WHERE email LIKE '%?1'
    List<Student> findByEmailEndingWith(String suffix);

    // Derived query performing case-insensitive matching on the name field
    // SQL equivalent: SELECT * FROM students WHERE LOWER(name) = LOWER(?)
    List<Student> findByNameIgnoreCase(String name);
}
```

---

## 📝 4. Custom Queries: JPQL vs. Native SQL

For complex queries (e.g., joins, reporting, bulk updates), derived queries become unreadable. You can write custom queries using the `@Query` annotation.

### 1. JPQL (Java Persistence Query Language)
JPQL queries **Entities (Java classes) and class variables**, not actual database tables and columns. It is database-agnostic.
```java
// Uses Entity class name 'Student' and property variable 'email' (not database columns)
@Query("SELECT s FROM Student s WHERE s.email = :email") // Defines custom JPQL query string
Optional<Student> findByEmailCustom(@Param("email") String email); // Binds method argument 'email' to query parameter ':email'
```

### 2. Native SQL
Queries the **actual database tables and columns** directly. Useful for database-specific features (e.g. Postgres JSON/vector functions).
```java
// Uses actual physical database table 'students' and column 'email_address'
@Query(value = "SELECT * FROM students WHERE email_address = :email", nativeQuery = true) // nativeQuery=true executes SQL directly
Optional<Student> findByEmailNative(@Param("email") String email); // Binds 'email' method argument to query parameter ':email'
```

### 3. Parameter Binding
- **Named Parameters (Recommended)**: Uses `:parameterName` matched via `@Param("parameterName")`.
- **Positional Parameters**: Uses `?1`, `?2` based on argument order.
  ```java
  // Positional bindings map arguments based on order sequence: ?1 binds to 'name', ?2 binds to 'age'
  @Query("SELECT s FROM Student s WHERE s.name = ?1 AND s.age = ?2") // Defines JPQL query with positional parameters
  List<Student> findByNameAndAgePositional(String name, Integer age); // Method signature
  ```

### 4. Modifying Queries (UPDATE / DELETE)
For write operations using `@Query`, you **must** annotate the method with `@Modifying`.
```java
@Modifying // Tells Spring to treat this query as a write operation (DML: UPDATE/DELETE) rather than a read operation (SELECT)
@Transactional // Enforces transaction boundary required for database modifications
@Query("UPDATE Student s SET s.department = :dept WHERE s.id = :id") // Defines JPQL update query
int updateDepartment(@Param("id") Long id, @Param("dept") String dept); // Returns the count of affected database rows
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
@Service // Registers this class as the business logic service bean in Spring context
public class StudentService {
    
    @Autowired // Auto-wires dependency injection for repository layer
    private StudentRepository repository;

    @Transactional // Starts a database transaction. Auto-commits and flushes changes on method success.
    public void updateAge(Long id, Integer newAge) {
        // 1. Fetching the student record loads it from DB. It is placed in the Persistent (MANAGED) state.
        Student student = repository.findById(id).orElseThrow();
        
        // 2. Modifying the managed entity object's field directly in memory.
        student.setAge(newAge);
        
        // CRITICAL: NO NEED TO CALL repository.save(student);
        // On method exit, the transaction commits. Hibernate performs "Dirty Checking", 
        // detects that 'age' was modified in the Persistence Context, and automatically triggers SQL UPDATE.
    }
}
```

---

## 📊 6. Pagination, Sorting, & Transaction Management

For large datasets, loading all rows via `findAll()` will cause Out-Of-Memory errors. Spring Boot handles pagination natively.

### 1. Pagination & Sorting Implementation
Inject a `Pageable` parameter into your controller and pass it to the repository:

```java
// Controller Web Endpoint
@GetMapping("/paginated") // Maps GET requests to /paginated path
public ResponseEntity<Page<Student>> getStudents(
        @RequestParam(defaultValue = "0") int page, // Page index query parameter (defaults to page 0)
        @RequestParam(defaultValue = "10") int size, // Page size query parameter (defaults to 10 rows per page)
        @RequestParam(defaultValue = "id") String sortBy) { // Column name used to sort the dataset (defaults to ID)
            
    // Creates a Pageable configuration containing page index, size, and sort order (ID descending)
    Pageable pageable = PageRequest.of(page, size, Sort.by(sortBy).descending());
    
    // Queries the database. Executes SELECT LIMIT OFFSET and SELECT COUNT queries.
    Page<Student> result = studentRepository.findAll(pageable);
    
    // Returns the Page payload containing metadata (totalPages, totalElements) and data list with HTTP 200 OK
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
