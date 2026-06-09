---
tags: [golang, roadmap, testing, mocking]
aliases: ["Phase 6: Testing"]
---
# Phase 6: Testing

Testing in Go is built directly into the standard library. You do not need massive external frameworks to write robust tests. 

---

## 6.1 Standard Library Testing

Go test files must end with `_test.go` and be in the same package as the code they are testing. Test functions must start with `Test` and take `*testing.T` as a parameter.

### Table-Driven Tests
This is the idiomatic way to write unit tests in Go. It allows you to define multiple test cases in a single slice and iterate over them.

```go
// math.go
package math

func Add(a, b int) int {
	return a + b
}
```

```go
// math_test.go
package math

import "testing"

func TestAdd(t *testing.T) {
	// 1. Define the table of test cases
	tests := []struct {
		name     string
		a        int
		b        int
		expected int
	}{
		{"positive numbers", 2, 3, 5},
		{"negative numbers", -1, -2, -3},
		{"zeroes", 0, 0, 0},
	}

	// 2. Iterate over them
	for _, tc := range tests {
		// Run creates a sub-test
		t.Run(tc.name, func(t *testing.T) {
			result := Add(tc.a, tc.b)
			if result != tc.expected {
				t.Errorf("expected %d, got %d", tc.expected, result)
			}
		})
	}
}
```

Run tests using: `go test -v ./...`

---

## 6.2 HTTP Handler Testing

The `net/http/httptest` package provides utilities to test HTTP handlers without actually starting a server on a port.

```go
package main

import (
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprint(w, "Hello, testing!")
}

func TestHelloHandler(t *testing.T) {
	// Create a new incoming request
	req, err := http.NewRequest("GET", "/hello", nil)
	if err != nil {
		t.Fatal(err)
	}

	// Create a ResponseRecorder to record the handler's response
	rr := httptest.NewRecorder()

	// Call the handler directly, passing in the recorder and request
	handler := http.HandlerFunc(helloHandler)
	handler.ServeHTTP(rr, req)

	// Check the status code
	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v", status, http.StatusOK)
	}

	// Check the response body
	expected := "Hello, testing!"
	if rr.Body.String() != expected {
		t.Errorf("handler returned unexpected body: got %v want %v", rr.Body.String(), expected)
	}
}
```

---

## 6.3 Mocking Interfaces

To test business logic independently of external dependencies (like a database or an external API), you should rely on Interfaces.

```go
package main

import (
	"fmt"
	"testing"
)

// 1. Define the Interface
type UserRepository interface {
	GetUserByID(id string) (string, error)
}

// 2. The Business Logic uses the interface, not a concrete struct
type UserService struct {
	Repo UserRepository
}

func (s *UserService) GetUserName(id string) (string, error) {
	user, err := s.Repo.GetUserByID(id)
	if err != nil {
		return "", err
	}
	return "User: " + user, nil
}

// 3. Create a Mock for testing
type MockRepo struct {
	MockUser string
	MockErr  error
}

func (m *MockRepo) GetUserByID(id string) (string, error) {
	return m.MockUser, m.MockErr
}

// 4. Test using the Mock
func TestGetUserName(t *testing.T) {
	mockRepo := &MockRepo{MockUser: "Alice", MockErr: nil}
	service := UserService{Repo: mockRepo}

	result, err := service.GetUserName("123")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if result != "User: Alice" {
		t.Errorf("expected User: Alice, got %s", result)
	}
}
```
*Note: For large interfaces, developers often use tools like `vektra/mockery` or Google's `gomock` to auto-generate these mock structs.*

---

## 6.4 Database Testing (Testcontainers)

Mocking the database is good for unit tests, but terrible for ensuring your complex SQL queries actually work. For integration testing, use **Testcontainers** (`testcontainers-go`). 

Testcontainers spins up an ephemeral Docker container (e.g., PostgreSQL) exclusively for the duration of your test run.

```go
// Concept Example (Pseudo-code)
func TestDatabaseQueries(t *testing.T) {
	// 1. Spin up a real Postgres DB inside a Docker container
	// pgContainer, err := postgres.RunContainer(...)
	
	// 2. Connect your standard database/sql DB to it
	// db, err := sql.Open("postgres", pgContainer.ConnectionString())
	
	// 3. Run your migrations (create tables)
	// migrate.Up()

	// 4. Run real SQL queries against it
	// result := repo.InsertUser("Bob")
	
	// 5. Container is automatically destroyed when test ends.
}
```

---

## Interview Questions - Phase 6

1. **What is a "Table-Driven Test" in Go, and why is it preferred?**
   *Answer:* A table-driven test uses a slice of anonymous structs to define inputs and expected outputs for a function. You then iterate over this slice, calling `t.Run()` for each case. It is preferred because it vastly reduces boilerplate code, makes it extremely easy to add new test cases, and keeps test output organized.

2. **How does `httptest.NewRecorder()` work?**
   *Answer:* `httptest.NewRecorder()` returns an implementation of the `http.ResponseWriter` interface. Instead of writing data over a real network socket back to a client, it records all mutations (status codes, headers, body writes) into memory. This allows you to inspect exactly what the HTTP handler would have sent without needing to start a real HTTP server.

3. **Why do we use Interfaces for Mocking in Go?**
   *Answer:* Go does not support monkey-patching methods on concrete structs easily. If a service directly embeds a concrete PostgreSQL database struct, you cannot swap it out during testing. By defining an Interface (e.g., `UserRepository`) and passing that interface into the service (Dependency Injection), you can inject a lightweight `MockRepository` struct during testing that satisfies the same interface but returns hardcoded test data.

4. **What are the pros and cons of using Testcontainers vs. Mocking the Database?**
   *Answer:* 
   - **Mocking**: Extremely fast, no external dependencies, good for testing specific business logic edge cases. Con: Provides zero confidence that your SQL syntax is actually valid.
   - **Testcontainers**: High confidence. Proves that your migrations, schema, and SQL queries execute correctly against the exact database engine you use in production. Con: Slower test execution time (requires spinning up Docker containers) and requires Docker to be running on the CI/CD agent.
