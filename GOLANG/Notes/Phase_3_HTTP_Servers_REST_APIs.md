---
tags: [golang, roadmap, http, rest, api]
aliases: ["Phase 3: HTTP Servers & REST APIs"]
---

# Phase 3: HTTP Servers & REST APIs

> [!info] Go's Superpower: `net/http`
> Unlike many other languages where you need a heavy application server (like Tomcat for Java or Gunicorn for Python) or an external reverse proxy to handle concurrent connections efficiently, Go's standard library provides a highly scalable, production-ready HTTP server natively. 

In this phase, we explore the standard library, custom JSON serialization, advanced routing, and middleware patterns to build robust RESTful APIs.

---

## 3.1 Deep Dive: The `net/http` Standard Library

> [!deep-dive] Goroutines per Request
> One of the most important concepts to understand is that the `net/http` server **automatically spawns a new goroutine for every incoming request**. 
> This means your handler functions are executed concurrently. You MUST ensure that any shared state accessed within your handlers (like maps, caches, or global variables) is protected using synchronization primitives (like `sync.Mutex`) or channels to prevent data races.

### Building a Basic Server

The core interface in Go web programming is `http.Handler`:
```go
type Handler interface {
    ServeHTTP(ResponseWriter, *Request)
}
```

Here is a robust example of a standard library server:

```go
package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
	// 1. Enforce HTTP Methods
	if r.Method != http.MethodGet {
		// http.Error is a helper that sets the status code and writes the string body
		http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		return
	}

	// 2. Read headers
	clientIP := r.Header.Get("X-Forwarded-For")
	
	// 3. Write Response
	w.WriteHeader(http.StatusOK) // Always call this BEFORE w.Write
	fmt.Fprintf(w, "Hello! Your IP is: %s\n", clientIP)
}

func main() {
	// http.NewServeMux creates a new HTTP request multiplexer (router)
	mux := http.NewServeMux()
	mux.HandleFunc("/hello", helloHandler)

	// Custom Server struct allows us to set critical timeouts!
	// Never use http.ListenAndServe(":8080", nil) in production without timeouts.
	srv := &http.Server{
		Addr:         ":8080",
		Handler:      mux,
		ReadTimeout:  5 * time.Second,   // Max time to read request from client
		WriteTimeout: 10 * time.Second,  // Max time to write response to client
		IdleTimeout:  120 * time.Second, // Max time for connections using TCP Keep-Alive
	}

	fmt.Println("Server listening on :8080")
	if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		log.Fatalf("Server crashed: %v", err)
	}
}
```

---

## 3.2 Advanced JSON Handling

JSON is the lingua franca of REST APIs. Go handles JSON via reflection in the `encoding/json` package.

### Custom JSON Marshaling
Sometimes, you need full control over how a struct is serialized to JSON. You can do this by implementing the `json.Marshaler` or `json.Unmarshaler` interfaces.

> [!tip] Dealing with Dates and Enums
> Custom marshaling is heavily used for formatting timestamps, obfuscating sensitive data on the fly, or converting internal integer enums to readable string values for the client.

```go
package main

import (
	"encoding/json"
	"fmt"
	"strings"
	"time"
)

type Status int

const (
	Pending Status = iota
	Active
	Suspended
)

type User struct {
	ID        int       `json:"id"`
	Username  string    `json:"username"`
	Password  string    `json:"-"` // Never output
	Status    Status    `json:"status"`
	CreatedAt time.Time `json:"created_at"`
}

// Custom MarshalJSON for the User struct
func (u *User) MarshalJSON() ([]byte, error) {
	// Map internal integer to string
	var statusStr string
	switch u.Status {
	case Pending:
		statusStr = "pending"
	case Active:
		statusStr = "active"
	case Suspended:
		statusStr = "suspended"
	}

	// Create an anonymous alias struct to prevent infinite recursion during Marshal
	type Alias User
	return json.Marshal(&struct {
		*Alias
		Status    string `json:"status"`
		Username  string `json:"username"`
	}{
		Alias:    (*Alias)(u),
		Status:   statusStr,
		Username: strings.ToUpper(u.Username), // Example data transformation
	})
}

func main() {
	u := User{ID: 1, Username: "alice", Password: "123", Status: Active, CreatedAt: time.Now()}
	b, _ := json.Marshal(&u)
	fmt.Println(string(b))
	// Output: {"id":1,"username":"ALICE","status":"active","created_at":"2023-10-27T..."}
}
```

### Safely Decoding JSON Requests
Never read massive JSON payloads directly into memory using `io.ReadAll`. Always use `json.NewDecoder`.

```go
func decodeSafely(w http.ResponseWriter, r *http.Request) {
	var payload map[string]interface{}

	// Limit the request body size to 1MB to prevent Denial of Service (OOM)
	r.Body = http.MaxBytesReader(w, r.Body, 1048576)

	decoder := json.NewDecoder(r.Body)
	// DisallowUnknownFields causes the Decoder to return an error when the destination 
	// is a struct and the input contains object keys which do not match any exported fields.
	decoder.DisallowUnknownFields()

	if err := decoder.Decode(&payload); err != nil {
		http.Error(w, "Bad Request: Invalid JSON", http.StatusBadRequest)
		return
	}
}
```

---

## 3.3 HTTP Routers and Frameworks

While `http.ServeMux` received major upgrades in Go 1.22 (finally supporting path parameters like `/users/{id}`), third-party routers are still heavily entrenched in the ecosystem.

> [!info] Chi vs Gin
> **Chi**: Minimalist, deeply idiomatic. It fully embraces standard `http.Handler` and `context.Context`.
> **Gin**: Massive, batteries-included framework. Uses a custom `gin.Context`. Extremely fast but less idiomatic.

### Using `go-chi/chi`

```go
package main

import (
	"fmt"
	"net/http"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

func main() {
	r := chi.NewRouter()

	// Inject standard Chi middlewares
	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer) // Recovers from panics, preventing server crashes

	// Grouping routes is clean and easy
	r.Route("/api/v1/users", func(r chi.Router) {
		r.Get("/", listUsers)           // GET /api/v1/users
		r.Post("/", createUser)         // POST /api/v1/users
		
		r.Route("/{userID}", func(r chi.Router) {
			r.Get("/", getUser)         // GET /api/v1/users/123
			r.Put("/", updateUser)      // PUT /api/v1/users/123
			r.Delete("/", deleteUser)   // DELETE /api/v1/users/123
		})
	})

	http.ListenAndServe(":3000", r)
}

func getUser(w http.ResponseWriter, r *http.Request) {
	// Extracting path parameters in Chi
	userID := chi.URLParam(r, "userID")
	fmt.Fprintf(w, "Data for user %s", userID)
}
// ... other handlers omitted ...
```

---

## 3.4 REST API Best Practices

### 1. The Envelope Pattern
Wrapping JSON responses in a standard "envelope" makes life infinitely easier for frontend developers parsing the API.

```go
type Envelope map[string]any

func writeJSON(w http.ResponseWriter, status int, data Envelope) error {
	js, err := json.Marshal(data)
	if err != nil {
		return err
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	w.Write(js)
	return nil
}

// Success Usage:
// writeJSON(w, http.StatusOK, Envelope{"user": userObj, "metadata": metaObj})

// Error Usage:
// writeJSON(w, http.StatusNotFound, Envelope{"error": "user not found"})
```

### 2. Pagination
Never return thousands of records at once.
- **Offset-based**: `?limit=10&offset=20`. Simple, but slow on huge tables because the database still has to scan the offset rows.
- **Cursor-based**: `?limit=10&cursor=eyJpZCI6MTB9`. Highly performant for infinite-scroll applications.

---

## 3.5 Advanced Middleware Patterns

Middleware is code that executes *before* and *after* your final handler. It is usually structured as a closure.

### Injecting Dependencies via Context
A very common pattern is using middleware to authenticate a user, and then passing that User ID down to the final handler using the request's Context.

> [!warning] Context Keys
> Always use custom types for Context keys to avoid collisions with other packages that might use strings.

```go
package main

import (
	"context"
	"fmt"
	"net/http"
)

// Custom type for context key prevents collisions
type contextKey string
const userIDKey contextKey = "userID"

// Auth Middleware
func requireAuth(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		token := r.Header.Get("Authorization")
		
		if token != "secret-token" {
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		// Hardcoded for example: Extract user ID from token
		userID := "user_999"

		// Create a new context carrying the user ID
		ctx := context.WithValue(r.Context(), userIDKey, userID)
		
		// Create a new request with the new context
		reqWithCtx := r.WithContext(ctx)

		// Pass the new request to the next handler
		next.ServeHTTP(w, reqWithCtx)
	})
}

// Final Handler
func dashboardHandler(w http.ResponseWriter, r *http.Request) {
	// Extract the user ID from the context safely
	userID, ok := r.Context().Value(userIDKey).(string)
	if !ok {
		http.Error(w, "Server Error", http.StatusInternalServerError)
		return
	}

	fmt.Fprintf(w, "Welcome to the dashboard, User ID: %s", userID)
}

func main() {
	mux := http.NewServeMux()
	
	// Wrap the dashboard handler with the auth middleware
	mux.Handle("/dashboard", requireAuth(http.HandlerFunc(dashboardHandler)))
	
	http.ListenAndServe(":8080", mux)
}
```

---

## 3.6 Configuration Management

Modern cloud-native apps follow the 12-Factor App methodology, meaning configuration should strictly live in the environment.

While `os.Getenv` works, libraries like `spf13/viper` allow you to elegantly merge configurations from environment variables, `.env` files, JSON configs, and command-line flags.

```go
package main

import (
	"fmt"
	"log"
	"github.com/spf13/viper"
)

type Config struct {
	Port     int    `mapstructure:"PORT"`
	DBHost   string `mapstructure:"DB_HOST"`
	LogLevel string `mapstructure:"LOG_LEVEL"`
}

func LoadConfig(path string) (config Config, err error) {
	viper.AddConfigPath(path)
	viper.SetConfigName("app")
	viper.SetConfigType("env")

	viper.AutomaticEnv() // Automatically override with Env vars if they exist

	if err = viper.ReadInConfig(); err != nil {
		return
	}
	err = viper.Unmarshal(&config)
	return
}

func main() {
	cfg, err := LoadConfig(".")
	if err != nil {
		log.Fatal("cannot load config:", err)
	}
	fmt.Printf("Starting server on port %d with log level %s\n", cfg.Port, cfg.LogLevel)
}
```

---

## Interview Questions - Phase 3

1. **How does `net/http` handle concurrency?**
   *Answer:* The `net/http` server automatically spawns a new goroutine for every incoming HTTP request. This means multiple requests are handled concurrently. Developers must be acutely aware of this and use Mutexes or channels when reading/writing to shared state (like global maps or caches) inside HTTP handlers to prevent data races.

2. **Why shouldn't you use `ioutil.ReadAll` (or `io.ReadAll`) to read a JSON request body?**
   *Answer:* `ReadAll` loads the entire payload into memory at once. If a client sends a massive payload (e.g., a 2GB file instead of a JSON object), it will spike your server's memory and potentially crash it (OOM). Instead, use `json.NewDecoder(r.Body).Decode(&struct)` which streams the data and is much more memory efficient. You should also wrap `r.Body` with `http.MaxBytesReader` to limit the payload size.

3. **What does the `json:"-"` struct tag do?**
   *Answer:* It tells the `encoding/json` package to completely ignore the field during both marshaling and unmarshaling. This is crucial for fields like passwords or internal state that should never be leaked to the client.

4. **How do you safely pass data (like User IDs) from Middleware to the final HTTP Handler?**
   *Answer:* You use the `context` package. In the middleware, you create a new context containing the value using `context.WithValue(r.Context(), key, value)`. You then clone the request with the new context using `r.WithContext(ctx)` and pass the cloned request to `next.ServeHTTP`. To prevent key collisions across different packages, the `key` should always be a custom unexported type, not a standard string.

5. **Why is `go-chi` often preferred over standard `net/http` for routing?**
   *Answer:* While `net/http` is great, before Go 1.22 it lacked native support for path parameters (e.g., `/users/{id}`). `go-chi` provides an elegant router that supports path parameters, regex routing, and robust middleware chains, while remaining 100% compatible with the standard `http.Handler` interface, meaning you don't get locked into a custom framework context.

6. **What happens if you call `w.Write()` before calling `w.WriteHeader()`?**
   *Answer:* If you call `w.Write()` first, the `net/http` package will automatically send an HTTP 200 OK status code. Any subsequent call to `w.WriteHeader(http.StatusNotFound)` will be ignored, and you will see a "superfluous response.WriteHeader" error in your logs. You must always write the headers and status code before writing the body.
