---
tags: [golang, roadmap, databases, sql, redis]
aliases: ["Phase 4: Databases"]
---
# Phase 4: Databases

Connecting Go to databases is primarily handled by the `database/sql` standard library, often supplemented by third-party drivers or ORMs (Object-Relational Mappers).

---

## 4.1 PostgreSQL with `database/sql`

The `database/sql` package provides a generic interface around SQL databases. You must import a specific driver (like `lib/pq` or `pgx`) to interact with PostgreSQL.

```go
package main

import (
	"database/sql"
	"fmt"
	"log"

	// The underscore indicates we are importing the package solely for its side effects 
	// (registering the driver with database/sql), without directly calling any of its functions.
	_ "github.com/lib/pq"
)

type User struct {
	ID   int
	Name string
}

func main() {
	connStr := "user=postgres password=secret dbname=mydb sslmode=disable"
	
	// Open does not actually establish a connection immediately, it prepares the pool.
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Ping actually tests the connection
	if err = db.Ping(); err != nil {
		log.Fatal("Could not connect to database:", err)
	}

	fmt.Println("Connected to PostgreSQL!")

	// 1. Executing a Query (Insert)
	// ALWAYS use parameterized queries ($1, $2) to prevent SQL Injection!
	insertQuery := `INSERT INTO users (name) VALUES ($1) RETURNING id`
	var id int
	err = db.QueryRow(insertQuery, "Alice").Scan(&id)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("Inserted user with ID: %d\n", id)

	// 2. Querying Data
	rows, err := db.Query("SELECT id, name FROM users WHERE id = $1", id)
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close() // ALWAYS close rows to prevent connection leaks

	var users []User
	for rows.Next() {
		var u User
		if err := rows.Scan(&u.ID, &u.Name); err != nil {
			log.Fatal(err)
		}
		users = append(users, u)
	}
	
	// Check for errors encountered during iteration
	if err := rows.Err(); err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Found Users: %+v\n", users)
}
```

---

## 4.2 SQL Drivers & Query Builders

- **`lib/pq`**: The classic pure Go Postgres driver.
- **`jackc/pgx`**: Faster, heavily recommended for modern projects. Supports advanced Postgres features natively.
- **`jmoiron/sqlx`**: An extension of `database/sql` that allows you to easily map database rows directly into Go structs, drastically reducing boilerplate `.Scan()` code.
- **`squirrel`**: A fluent SQL query builder. It helps construct SQL strings dynamically without relying on an ORM.

```go
// Example using sqlx
// var users []User
// err := db.Select(&users, "SELECT * FROM users ORDER BY name ASC")
```

---

## 4.3 ORM: GORM

GORM is the most popular ORM for Go. It provides a highly productive abstraction over raw SQL, offering Auto Migration, Associations, and Hooks.

```go
package main

import (
	"fmt"
	"log"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

// GORM Model Definition
type Product struct {
	gorm.Model // Embeds ID, CreatedAt, UpdatedAt, DeletedAt
	Code  string
	Price uint
}

func main() {
	dsn := "host=localhost user=postgres password=secret dbname=mydb port=5432 sslmode=disable"
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("failed to connect database")
	}

	// Migrate the schema (creates tables if they don't exist)
	db.AutoMigrate(&Product{})

	// Create
	db.Create(&Product{Code: "D42", Price: 100})

	// Read
	var product Product
	db.First(&product, 1) // find product with integer primary key 1
	db.First(&product, "code = ?", "D42") // find product with code D42
	
	fmt.Printf("Found product: %s, Price: %d\n", product.Code, product.Price)

	// Update - update product's price to 200
	db.Model(&product).Update("Price", 200)

	// Delete - soft delete (sets DeletedAt, doesn't actually remove row)
	db.Delete(&product, 1)
}
```

---

## 4.4 Database Migrations

You should never manually execute SQL commands in production to alter schemas. Use a migration tool to version control your database schema.
- **`golang-migrate/migrate`**: Uses standard `up.sql` and `down.sql` files.
- **`pressly/goose`**: Allows migrations to be written in standard SQL or Go code.

*Migration Example (`000001_create_users_table.up.sql`):*
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
```

---

## 4.5 Redis

Redis is heavily used in Go for caching, rate limiting, and pub/sub messaging.

```go
package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/go-redis/redis/v8"
)

func main() {
	ctx := context.Background()

	rdb := redis.NewClient(&redis.Options{
		Addr:     "localhost:6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	// Set a key with a TTL (Time To Live) of 1 hour
	err := rdb.Set(ctx, "session:123", "alice_token", 1*time.Hour).Err()
	if err != nil {
		log.Fatal(err)
	}

	// Get the key
	val, err := rdb.Get(ctx, "session:123").Result()
	if err == redis.Nil {
		fmt.Println("Key does not exist")
	} else if err != nil {
		log.Fatal(err)
	} else {
		fmt.Println("Session token:", val)
	}
}
```

---

## Interview Questions - Phase 4

1. **Why do we use the blank identifier `_` when importing a database driver like `github.com/lib/pq`?**
   *Answer:* We import it using the blank identifier to invoke the package's `init()` function. The `init()` function inside the driver package registers the Postgres driver with the standard `database/sql` package so it knows how to handle the `"postgres"` connection string, without us explicitly calling any exported functions from the driver itself.

2. **What is SQL Injection and how do you prevent it in Go?**
   *Answer:* SQL Injection occurs when malicious user input is concatenated directly into an SQL query string, altering the query's logic. In Go, you prevent this by ALWAYS using parameterized queries (e.g., `db.Query("SELECT * FROM users WHERE name = $1", userInput)`). The database driver handles escaping the input safely.

3. **Why is it critical to call `defer rows.Close()` after `db.Query()`?**
   *Answer:* When you execute a query that returns multiple rows, it holds an open connection to the database from the connection pool. If you don't close the rows (either by iterating all the way through them via `rows.Next()` or explicitly calling `rows.Close()`), the connection will never be released back to the pool, eventually causing a connection leak and crashing the application.

4. **What is the difference between `database/sql` and an ORM like GORM?**
   *Answer:* `database/sql` is a low-level, standard library package that requires you to write raw SQL queries and manually scan resulting rows into Go structs. GORM is a high-level ORM that abstracts away SQL, allowing you to interact with the database using Go objects and methods (e.g., `db.Create(&user)`). ORMs increase developer speed but can hide complex/inefficient queries, whereas raw SQL gives you maximum control and performance.

5. **What is the "Cache-Aside" pattern using Redis?**
   *Answer:* It's the most common caching pattern. When an application needs data, it first checks Redis. If the data is found (Cache Hit), it returns it immediately. If not found (Cache Miss), the application queries the primary database (e.g., PostgreSQL), stores the result in Redis with a TTL, and then returns the data to the user. Future requests will hit the cache.
