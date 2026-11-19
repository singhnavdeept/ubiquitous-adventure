
# Deep Dive Notes: How Go (Golang) Executes Programs and Builds Binaries

---

# 1. Introduction

Go is a compiled, statically typed programming language designed for:
- Simplicity
- Fast compilation
- Concurrency
- Efficient binaries
- Minimal runtime overhead

Unlike interpreted languages such as Python or JavaScript, Go source code is transformed into native machine code before execution.

---

# 2. Lifecycle of a Go Program

The execution pipeline looks like this:

```text
.go source files
        ↓
Lexical Analysis
        ↓
Parsing
        ↓
AST (Abstract Syntax Tree)
        ↓
Type Checking
        ↓
Intermediate Representation (IR)
        ↓
Optimization
        ↓
Assembly Generation
        ↓
Machine Code Generation
        ↓
Linking
        ↓
Executable Binary
        ↓
OS Loader
        ↓
Runtime Initialization
        ↓
main.main()
```

---

# 3. What Happens When You Run `go run main.go`

Example:

```bash
go run main.go
```

Internally Go does NOT interpret the file.

Instead:

1. Creates a temporary build directory
2. Compiles the source code
3. Generates machine code
4. Creates a temporary executable
5. Executes the binary
6. Deletes temporary files

So:

```bash
go run
```

is effectively:

```bash
go build
./binary
```

performed automatically.

---

# 4. Structure of a Go Source File

Example:

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello")
}
```

Key components:

| Component | Purpose |
|---|---|
| `package main` | Entry package |
| `import` | Loads dependencies |
| `func main()` | Program entry point |

The binary execution begins from:

```go
func main()
```

but internally there are many runtime initialization steps before it.

---

# 5. Compilation Stages in Detail

---

# 5.1 Lexical Analysis (Tokenizer)

The compiler first converts text into tokens.

Example:

```go
x := 10
```

becomes:

```text
IDENTIFIER(x)
DECLARE(:=)
INTEGER(10)
```

Whitespace/comments are mostly discarded.

---

# 5.2 Parsing

The parser converts tokens into an AST (Abstract Syntax Tree).

Example:

```go
x := 10 + 20
```

becomes something conceptually like:

```text
Assignment
 ├── Variable(x)
 └── Addition
      ├── 10
      └── 20
```

This structured tree helps the compiler understand code semantics.

---

# 5.3 Type Checking

Go is statically typed.

The compiler validates:

- Variable types
- Function signatures
- Interface compatibility
- Package visibility
- Method sets

Example error:

```go
var x int = "hello"
```

Compiler stops immediately.

---

# 5.4 Intermediate Representation (IR)

Go converts the AST into an intermediate representation.

IR allows:
- Optimizations
- Escape analysis
- Inlining
- Dead code elimination

This stage is architecture-independent.

---

# 5.5 Escape Analysis

One of Go's most important optimizations.

The compiler decides:

Should a variable live:
- on the stack
- or on the heap?

Example:

```go
func test() *int {
    x := 10
    return &x
}
```

`x` escapes because it survives after function return.

So it gets allocated on the heap.

Without escaping:

```go
func test() int {
    x := 10
    return x
}
```

`x` stays on stack.

You can inspect this using:

```bash
go build -gcflags="-m"
```

---

# 5.6 Optimization

Go performs several optimizations:

| Optimization | Meaning |
|---|---|
| Inlining | Replace function call with function body |
| Dead code elimination | Remove unused code |
| Constant folding | Precompute constants |
| Bounds-check elimination | Remove unnecessary array bounds checks |
| Escape optimization | Reduce heap allocations |

---

# 5.7 Assembly Generation

The compiler converts IR into assembly specific to:
- x86
- ARM
- ARM64
- etc.

Example conceptual assembly:

```asm
MOV R1, 10
ADD R1, 20
```

You can inspect assembly using:

```bash
go tool compile -S main.go
```

---

# 5.8 Machine Code Generation

Assembly becomes machine instructions.

Example:

```text
10110000 01100001
```

This is CPU-executable binary code.

---

# 5.9 Linking

The linker combines:
- Your code
- Standard library
- Runtime
- Dependencies

into one executable.

This is why Go binaries are often large.

The linker resolves:
- function addresses
- symbol references
- package dependencies

---

# 6. The Go Runtime

Go binaries include a runtime.

The runtime handles:
- Garbage collection
- Goroutines
- Scheduler
- Stack management
- Channels
- Memory allocation
- Panic/recover
- Deferred functions

Unlike C, Go is not "runtime-free".

But its runtime is much smaller than JVM/.NET.

---

# 7. What Happens Before `main()`

Before your code executes:

## Runtime startup occurs

The runtime:
- initializes memory allocator
- starts scheduler
- initializes garbage collector
- sets up goroutine stacks

Then:

## Package initialization

For every imported package:

1. Global variables initialized
2. `init()` functions run

Example:

```go
func init() {
    fmt.Println("init")
}
```

Then finally:

```go
main.main()
```

runs.

Execution order:

```text
runtime init
↓
imported packages init
↓
current package init
↓
main()
```

---

# 8. Goroutines and Scheduler

Go uses lightweight threads called goroutines.

Example:

```go
go func() {
    fmt.Println("hello")
}()
```

Internally:
- runtime creates goroutine
- scheduler assigns it to OS thread

---

# 9. GMP Scheduler Model

Go runtime scheduler uses:

| Symbol | Meaning |
|---|---|
| G | Goroutine |
| M | Machine thread |
| P | Processor context |

Conceptually:

```text
Many Goroutines
        ↓
Scheduled onto
        ↓
Few OS Threads
```

This allows millions of goroutines efficiently.

---

# 10. Stack vs Heap

---

## Stack

Fast memory:
- function-local
- automatically freed
- contiguous

---

## Heap

Dynamic memory:
- managed by garbage collector
- slower
- survives function returns

Heap allocations increase GC pressure.

---

# 11. Garbage Collection

Go uses a concurrent tri-color mark-and-sweep garbage collector.

Main phases:

1. Mark reachable objects
2. Sweep unreachable memory
3. Reuse memory

Goals:
- low pause times
- concurrency
- scalability

---

# 12. Static Linking

Go often produces statically linked binaries.

Meaning:
- dependencies embedded into executable
- easier deployment
- fewer runtime dependencies

This is why Go apps deploy easily inside Docker.

---

# 13. Cross Compilation

Go can compile for other OS/architectures.

Example:

```bash
GOOS=linux GOARCH=amd64 go build
```

Examples:

| GOOS | GOARCH |
|---|---|
| windows | amd64 |
| linux | arm64 |
| darwin | amd64 |

---

# 14. Binary Structure

A Go binary contains:

```text
Executable Header
Code Segment
Data Segment
Runtime
Symbol Table
Debug Info
Embedded Dependencies
```

---

# 15. Why Go Binaries Are Large

Reasons:
- static linking
- embedded runtime
- debug symbols
- GC metadata

Reduce size:

```bash
go build -ldflags="-s -w"
```

---

# 16. Dynamic vs Static Linking

---

## Static Linking

Everything bundled.

Pros:
- portable
- easy deployment

Cons:
- larger binaries

---

## Dynamic Linking

External shared libraries used.

Pros:
- smaller executable

Cons:
- dependency management complexity

Go prefers static linking.

---

# 17. What Happens During Execution

When binary starts:

```text
OS Loader
    ↓
Memory Mapping
    ↓
Runtime Initialization
    ↓
Scheduler Start
    ↓
Package init()
    ↓
main.main()
```

---

# 18. Memory Layout

Typical Go process memory:

```text
+-------------------+
| Code Segment      |
+-------------------+
| Global Variables  |
+-------------------+
| Heap              |
+-------------------+
| Goroutine Stacks  |
+-------------------+
```

---

# 19. Why Go Compiles Fast

Go was designed for fast builds.

Reasons:
- simplified language grammar
- aggressive package caching
- limited metaprogramming
- parallel compilation
- simple dependency model

Build cache location:

```bash
go env GOCACHE
```

---

# 20. Build Cache

Go caches compiled packages.

If package unchanged:
- compiler reuses cached object files

This drastically improves rebuild times.

---

# 21. Inspecting Build Process

Useful commands:

---

## View environment

```bash
go env
```

---

## Verbose build

```bash
go build -x
```

Shows compiler/linker commands.

---

## View assembly

```bash
go tool compile -S main.go
```

---

## Escape analysis

```bash
go build -gcflags="-m"
```

---

## Benchmark allocations

```bash
go test -bench=. -benchmem
```

---

# 22. Build Modes

Go supports multiple build modes.

Examples:

| Mode | Purpose |
|---|---|
| executable | Normal app |
| shared | Shared library |
| plugin | Runtime plugin |
| archive | Package archive |

---

# 23. Runtime vs Compile Time

---

## Compile Time

Occurs during build:
- type checking
- optimizations
- machine code generation

---

## Runtime

Occurs during execution:
- scheduling
- GC
- memory allocation
- goroutines

---

# 24. Why Go Feels Fast

Go combines:
- native machine code
- lightweight runtime
- efficient scheduler
- low-overhead GC
- static typing

This produces:
- low startup latency
- high throughput
- strong concurrency performance

---

# 25. End-to-End Example

Source:

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello")
}
```

Execution pipeline:

```text
Source Code
    ↓
Tokenizer
    ↓
Parser
    ↓
AST
    ↓
Type Checker
    ↓
IR
    ↓
Optimizer
    ↓
Assembly
    ↓
Machine Code
    ↓
Linker
    ↓
Binary
    ↓
OS Loader
    ↓
Runtime Init
    ↓
main()
```

---

# 26. Key Takeaways

- Go is compiled, not interpreted
- `go run` still compiles binaries
- Go binaries contain runtime + dependencies
- Runtime manages goroutines and GC
- Compiler performs escape analysis and optimizations
- Linker combines all packages into executable
- Scheduler multiplexes goroutines onto threads
- Static linking simplifies deployment
- Build cache enables extremely fast compilation

---

# 27. Important Internal Packages

| Package | Purpose |
|---|---|
| runtime | Scheduler, GC, goroutines |
| runtime/internal | Low-level runtime internals |
| cmd/compile | Compiler |
| cmd/link | Linker |
| sync | Concurrency primitives |
| reflect | Runtime reflection |

---

# 28. Suggested Next Topics

After this, study:

1. Go memory model
2. Escape analysis deeply
3. Goroutine scheduler internals
4. Channels implementation
5. Interface internals
6. Garbage collector phases
7. Stack growth mechanism
8. cgo internals
9. Netpoller
10. Runtime source code

---

# 29. Recommended Commands Cheat Sheet

```bash
go run .
go build
go build -x
go build -gcflags="-m"
go tool compile -S main.go
go env
```

---

# 30. Final Mental Model

Think of Go execution like this:

```text
You write Go code
        ↓
Compiler transforms it into machine code
        ↓
Linker bundles runtime + dependencies
        ↓
OS loads binary into memory
        ↓
Go runtime initializes scheduler + GC
        ↓
main() executes
        ↓
Runtime manages concurrency + memory until program exits
```
