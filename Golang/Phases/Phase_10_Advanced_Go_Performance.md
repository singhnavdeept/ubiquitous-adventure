---
tags: [golang, roadmap, fundamentals, basics]
aliases: ["Phase 10: Advanced Go & Performance"]
---
# Phase 10: Advanced Go & Performance

To become a senior Go engineer, you must understand how Go works under the hood and how to optimize it for high-throughput environments.

---

## 10.1 Go Runtime Internals

### Escape Analysis
In Go, variables can be allocated on the **Stack** (fast, automatically cleaned up when the function returns) or the **Heap** (slower, requires Garbage Collection).

The compiler performs "Escape Analysis" to determine where to place a variable. If a variable's lifetime extends beyond the function it was created in (e.g., returning a pointer to it), it "escapes" to the heap.

You can view escape analysis decisions using:
`go build -gcflags="-m" main.go`

### Garbage Collector (GC)
Go uses a concurrent, tri-color mark-and-sweep garbage collector. It is optimized for incredibly low pause times (usually sub-millisecond), prioritizing latency over total throughput. The only major knob you have to tune it is `GOGC` (which sets the target heap size percentage before triggering a GC cycle).

---

## 10.2 Profiling with `pprof`

When your application is slow or using too much memory, do not guess. Profile it.
Go has a built-in profiler: `pprof`.

```go
package main

import (
	"log"
	"net/http"
	_ "net/http/pprof" // Importing this registers the pprof endpoints on the default mux
)

func main() {
	go func() {
		log.Println(http.ListenAndServe("localhost:6060", nil))
	}()

	// ... your actual application logic ...
}
```

While the server is running, you can collect a 30-second CPU profile using the terminal:
`go tool pprof http://localhost:6060/debug/pprof/profile?seconds=30`

This opens an interactive shell where you can type `top` to see the most CPU-intensive functions, or `web` to generate a visual flame graph.

### sync.Pool
If your application creates and destroys thousands of temporary objects per second (like JSON buffers), it causes massive GC pressure. `sync.Pool` allows you to reuse memory objects across requests.

```go
var bufferPool = sync.Pool{
	New: func() interface{} {
		return new(bytes.Buffer)
	},
}

func handleRequest() {
	// Get a buffer from the pool (or create one if empty)
	buf := bufferPool.Get().(*bytes.Buffer)
	buf.Reset() // Always reset before use
	
	// Use the buffer...
	
	// Put it back in the pool for the next request to use
	bufferPool.Put(buf)
}
```

---

## 10.3 Generics (Go 1.18+)

Generics allow you to write functions and data structures that work with multiple types without relying on the empty interface `interface{}` (which requires runtime reflection/assertions and loses compile-time safety).

```go
package main

import "fmt"

// A generic function. 'T' is a type parameter constrained by the 'comparable' interface.
func FindIndex[T comparable](slice []T, target T) int {
	for i, v := range slice {
		if v == target {
			return i
		}
	}
	return -1
}

func main() {
	// Works with integers
	ints := []int{10, 20, 30}
	fmt.Println(FindIndex(ints, 20)) // Output: 1

	// Works with strings
	strings := []string{"apple", "banana", "cherry"}
	fmt.Println(FindIndex(strings, "cherry")) // Output: 2
}
```

---

## 10.4 Advanced Patterns

### Functional Options Pattern
When designing libraries or constructors with many optional parameters, the functional options pattern is the most idiomatic approach in Go.

```go
package main

import "time"

type Server struct {
	Host    string
	Port    int
	Timeout time.Duration
}

// Option is a function that modifies a Server
type Option func(*Server)

// Constructor
func NewServer(options ...Option) *Server {
	// Set defaults
	s := &Server{
		Host:    "localhost",
		Port:    8080,
		Timeout: 30 * time.Second,
	}

	// Apply options
	for _, opt := range options {
		opt(s)
	}
	return s
}

// Option providers
func WithPort(port int) Option {
	return func(s *Server) {
		s.Port = port
	}
}

func WithTimeout(t time.Duration) Option {
	return func(s *Server) {
		s.Timeout = t
	}
}

func main() {
	// Initialize with custom port and timeout, fallback to default Host
	s := NewServer(WithPort(9000), WithTimeout(1*time.Minute))
}
```

---

## 10.5 Code Generation

Go lacks macros, but it heavily utilizes code generation. `go generate` is a standard command that scans for special comments and runs external tools.

```go
package domain

//go:generate stringer -type=Pill
type Pill int

const (
	Placebo Pill = iota
	Aspirin
	Ibuprofen
)

// Running `go generate ./...` will execute the `stringer` tool, 
// which auto-generates a String() method for the Pill type, 
// allowing you to print fmt.Println(Aspirin) and see "Aspirin" instead of "1".
```

---

## Interview Questions - Phase 10

1. **What is Escape Analysis?**
   *Answer:* It's a phase during compilation where the Go compiler determines whether a variable can safely live on the stack (which is fast and automatically cleaned up) or if it "escapes" its scope and must be allocated on the heap (which is slower and requires the Garbage Collector to clean it up). Generally, passing pointers to local variables out of a function causes them to escape to the heap.

2. **How does Go's Garbage Collector work?**
   *Answer:* Go uses a concurrent, tri-color mark-and-sweep garbage collector. "Tri-color" refers to how it categorizes objects (White = dead, Grey = found but children unchecked, Black = found and children checked). "Concurrent" means it runs in the background alongside your application code, attempting to minimize "Stop The World" (STW) pauses to well under a millisecond, prioritizing low latency over high throughput.

3. **What is `sync.Pool` and when would you use it?**
   *Answer:* `sync.Pool` is a concurrent-safe object pool. You use it when you are frequently allocating and deallocating the exact same type of object (like large byte buffers or JSON encoder structs) hundreds or thousands of times per second. Instead of throwing them away to be Garbage Collected (which causes massive CPU pressure), you `Put` them back in the pool and `Get` them for reuse. 

4. **Why are Generics (Type Parameters) better than using `interface{}`?**
   *Answer:* Before generics, to write a flexible function (like a slice reverser), you had to accept `interface{}`. This caused two problems:
   1. It forces boxing/unboxing, which has a performance penalty.
   2. It loses compile-time type safety. If you accidentally pass an integer into a function expecting a string interface, it will compile but crash at runtime.
   Generics provide compile-time type safety and better performance via monomorphization (the compiler generates specific implementations for each type used).
