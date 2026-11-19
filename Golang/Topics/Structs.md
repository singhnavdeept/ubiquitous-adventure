---
title: "Structs in Go: The Backbone of Domain Modeling"
date: "2026-06-25"
excerpt: "How to define, initialize, embed, tag, and control the visibility of structs in Go—and why they are not classes, but something more useful."
tags: ["golang", "structs", "data-modeling", "go-basics", "type-system", "embedding", "memory-alignment"]
aliases: ["Structs in Go: The Backbone of Domain Modeling", "Go Structs Deep Dive"]
---

# Structs in Go: The Backbone of Domain Modeling

> [!info] Go's Design Philosophy: Structs vs. Classes
> A struct in Go is a **composite type** that groups together zero or more fields under a single name. It is the closest thing Go has to an object—but it is not an object. There are no constructors, no inheritance, no classes, and no implicit `this` or `self` pointer. 
> 
> What Go gives you instead is a lightweight, predictable, and contiguous block of memory that the compiler understands completely. This design avoids the complex class hierarchy traps of OOP (like the Fragile Base Class Problem) in favor of composition, visibility rules, and explicit memory layout.

---

## Part 1: Defining a Struct

### Basic Syntax & Memory Layout

```go
type Person struct {
    FirstName string // 16 bytes (string header: ptr + len)
    LastName  string // 16 bytes
    Age       int    // 8 bytes (on 64-bit architectures)
    Email     string // 16 bytes
}
```

When you define a struct type, you are defining a template for memory allocation. In Go, the fields are laid out in the exact order they are declared in the source code. The compiler may insert alignment padding between fields to satisfy CPU alignment constraints, but it will never reorder fields to optimize space.

### Exported vs. Unexported Fields (Encapsulation)

Go's visibility is governed entirely by casing at the package level:
- Fields starting with an **uppercase letter** are **exported** (public) and accessible from other packages.
- Fields starting with a lowercase letter are **unexported** (private) and accessible only within the package they are defined.

```go
package bank

type Account struct {
    ID       int     // Exported: visible to any package importing "bank"
    balance  float64 // Unexported: visible ONLY within package "bank"
    Owner    string  // Exported
}
```

> [!warning] Encapsulation via Packages, Not Classes
> Since access control is package-based, code inside the same package (`bank` in this case) can freely read and write the lowercase `balance` field of any `Account` instance. Encapsulation boundaries are packages, not the struct boundaries themselves.

### Structs with No Fields (Empty Structs)

An empty struct `struct{}` contains no fields and occupies **zero bytes** of memory. 

```go
package main

import (
	"fmt"
	"unsafe"
)

func main() {
	var s struct{}
	fmt.Println(unsafe.Sizeof(s)) // Outputs: 0
}
```

Because they occupy no space, empty structs are heavily optimized by the Go runtime. Every instance of an empty struct points to a special static memory location called `zerobase` in the Go runtime.

#### Common Use Cases of `struct{}`
1. **Map-Based Sets**: Implementing a set using a map where you only care about the keys. Using `struct{}` as the value saves memory compared to `bool`.
   ```go
   visited := make(map[string]struct{})
   visited["page_one"] = struct{}{}
   
   if _, exists := visited["page_one"]; exists {
       fmt.Println("Visited!")
   }
   ```
2. **Signal Channels**: Token signals where no data needs to be passed, only the occurrence of an event.
   ```go
   done := make(chan struct{})
   
   // In a goroutine:
   close(done) // Signals that work is complete without allocating data
   ```

---

## Part 2: Initializing Structs

### Named Fields (Recommended)

```go
p := Person{
    FirstName: "Alice",
    LastName:  "Johnson",
    Age:       32,
    Email:     "alice@example.com",
}
```

> [!tip] Best Practice: Always Use Named Fields
> Using field names makes the code self-documenting and resilient to structural changes. If a new field is added to the struct definition or fields are reordered, named-field initializations remain valid and compile without error.

Omitted fields automatically receive their respective **zero values**:
- `0` for numeric types
- `""` for strings
- `false` for booleans
- `nil` for pointers, slices, maps, channels, and interfaces

### Positional Fields (Avoid for Large Structs)

```go
p := Person{"Alice", "Johnson", 32, "alice@example.com"}
```

This syntax is compact but fragile. If any fields are added, removed, or reordered, the compiler will fail to build, or worse, types of the same format might swap values silently (e.g., swapping `FirstName` and `LastName` if they are adjacent strings). Limit positional initialization to tiny, immutable, mathematical utility structs like `image.Point{10, 20}` or `color.RGBA{255, 0, 0, 255}`.

### Zero-Value Guarantees and Constructors

In Go, there is no automatic execution of constructor logic. A struct variable declared without initialization immediately contains its safe zero-value:

```go
var p Person
fmt.Println(p.Age)       // 0
fmt.Println(p.FirstName) // ""
```

When a struct's zero value is not ready for immediate use (e.g., it contains uninitialized internal maps, slices, or channels that must be allocated), the Go convention is to write a **constructor function** prefixed with `New`:

```go
package cache

import "sync"

type InMemoryCache struct {
    mu    sync.RWMutex
    items map[string]string // Nil map is unusable (writes panic)
}

// NewInMemoryCache allocates and initializes the internal map
func NewInMemoryCache() *InMemoryCache {
    return &InMemoryCache{
        items: make(map[string]string),
    }
}
```

### Allocation: `new` vs. Composite Literals

Go provides multiple ways to allocate a struct, and the compiler uses **escape analysis** to determine whether the struct is allocated on the stack or the heap:

```go
p1 := new(Person)       // Returns *Person: allocates zero-valued struct
p2 := &Person{}         // Returns *Person: equivalent to new(Person)
p3 := &Person{Age: 30}  // Returns *Person: allows inline field initialization
```

- `new(T)` allocates zeroed storage for a new item of type `T` and returns its address (`*T`). It does not allow custom initialization.
- `&T{}` allocates and returns a pointer while allowing inline field assignments.
- **Community Standard**: Prefer the composite literal `&Person{}` or `Person{}` as it is more expressive and consistent.

---

## Part 3: Pointers to Structs

### Automatic Dereferencing (Dot Operator Syntactic Sugar)

Unlike languages like C/C++ which use `->` for pointers and `.` for values, Go uses the dot operator `.` for both. The compiler automatically dereferences pointers to structs when accessing fields or calling methods.

```go
p := Person{FirstName: "Bob"}
ptr := &p

fmt.Println(p.FirstName)   // Bob
fmt.Println(ptr.FirstName) // Bob (Syntactic sugar for (*ptr).FirstName)

ptr.Age = 45               // Automatically dereferences: same as (*ptr).Age = 45
```

### When to Use Pointer Receivers / Pointers vs. Values

Selecting between value (`T`) and pointer (`*T`) types is a critical design choice in Go:

| Parameter Type | Copy Behavior | Mutability | Memory Overhead | Use Cases |
| :--- | :--- | :--- | :--- | :--- |
| **Value (`T`)** | Deep copy of values (excluding reference fields) | Immutable (modifies copy only) | Copies all fields; expensive for large structs | Small, read-only data objects; primitives |
| **Pointer (`*T`)** | Copies the address (8 bytes on 64-bit) | Mutable (modifies original instance) | 8-byte pointer copy; low overhead | Large structs, stateful objects, locks (`sync.Mutex`) |

> [!caution] The Mutex Copying Trap
> Structs containing synchronization primitives (like `sync.Mutex` or `sync.RWMutex`) **must never be copied**. Copying a mutex duplicates its internal state (which tracks locked/unlocked status and waiter lists), leading to undefined behavior or deadlocks.
> Always pass structs containing mutexes by pointer, and configure methods to use pointer receivers.
> You can catch accidental copies using the command: `go vet ./...`

---

## Part 4: Composition over Inheritance (Embedding)

Go implements the design principle **"Composition over Inheritance"** directly through **anonymous fields** (also called struct embedding).

### Struct Embedding Syntax

By declaring a field with a type but no explicit field name, that type is embedded inside the struct.

```go
package main

import "fmt"

type Address struct {
    Street string
    City   string
}

type Employee struct {
    Name    string
    Address // Embedded struct (Anonymous field)
}

func main() {
    e := Employee{
        Name: "John Doe",
        Address: Address{
            Street: "100 Pine St",
            City:   "Seattle",
        },
    }

    // Promoted Fields: accessed directly as if they belong to Employee
    fmt.Println(e.Street) // Prints: "100 Pine St"
    
    // Explicit access is still valid:
    fmt.Println(e.Address.Street) // Prints: "100 Pine St"
}
```

### Interface Promotion via Embedding

If an embedded struct implements a specific interface, the embedding struct automatically implements that interface by promotion, unless overridden.

```go
package main

import "io"

type CustomWriter struct {
    io.Writer // Embedded interface
    Logger    func(string)
}

// CustomWriter now implicitly satisfies io.Writer.
// Calling CustomWriter.Write() will invoke the embedded io.Writer's Write method.
```

### Method Shadowing (Overriding)

If the embedding type implements a method with the exact signature as a method on the embedded type, the embedding type's method **shadows** (overrides) the embedded one.

```go
func (a Address) String() string {
    return a.Street + ", " + a.City
}

// Employee overrides String()
func (e Employee) String() string {
    return fmt.Sprintf("%s living at (%s)", e.Name, e.Address.String())
}
```

---

## Part 5: Struct Tags

Struct tags are metadata string literals attached to struct fields. They are ignored by the standard Go compiler but are readable at runtime using **reflection** via the `reflect` package.

```go
type User struct {
    ID       int64  `json:"id" db:"user_id"`
    Username string `json:"username" db:"username"`
    Email    string `json:"email,omitempty"`
    Password string `json:"-"` // Omitted from JSON serialization
}
```

### How Tags Work Under the Hood

Standard struct tags are formatted as space-separated key-value pairs: `key:"value" key2:"value2"`.

```go
package main

import (
	"fmt"
	"reflect"
)

type Product struct {
	Name  string `tag_key:"custom_value"`
	Price float64
}

func main() {
	p := Product{Name: "Laptop", Price: 1200.00}
	t := reflect.TypeOf(p)
	
	// Access field by name
	field, _ := t.FieldByName("Name")
	
	// Get the value of the specific key in the tag
	tagValue := field.Tag.Get("tag_key")
	fmt.Println("Tag Value:", tagValue) // Outputs: Tag Value: custom_value
}
```

### Common Tag Conventions

- **`json`**: Managed by `encoding/json` for web API payloads.
- **`db`**: Managed by SQL ORMs / mappers like `sqlx` or `gorm` to match database columns.
- **`validate`**: Used by libraries like `go-playground/validator` for input constraints.

### The `omitempty` Option and the Boolean Trap

The `omitempty` option omits a field from JSON output if the field holds its **zero value**.

> [!danger] The Boolean/Integer `omitempty` Trap
> If a struct field is a boolean:
> ```go
> type Feature struct {
>     Enabled bool `json:"enabled,omitempty"`
> }
> ```
> If `Enabled` is `false`, it matches the zero value of `bool`. The field will be omitted entirely from the JSON payload. A consumer reading the JSON won't know if the value was explicitly set to `false` or left unprovided.
> 
> **Solution**: Use pointers to represent nullable/optional primitives:
> ```go
> type Feature struct {
>     Enabled *bool `json:"enabled,omitempty"`
> }
> ```
> Now, `nil` represents absence (omitted), while `&false` explicitly encodes `"enabled": false`.

---

## Part 6: Structs as Method Receivers

Methods in Go are simply functions declared with a special **receiver** argument appearing between the `func` keyword and the function name.

```go
// Value Receiver: Receives a copy of the struct. Cannot modify internal state.
func (p Person) FullName() string {
    return p.FirstName + " " + p.LastName
}

// Pointer Receiver: Receives the address of the struct. Can mutate original fields.
func (p *Person) UpdateEmail(newEmail string) {
    p.Email = newEmail
}
```

### The Consistency Rule
> [!important] Keep Receiver Types Uniform
> If any method on your struct requires a **pointer receiver** (to modify state, prevent copy overhead, or preserve a mutex), **all** methods on that struct should use a pointer receiver. Mixing value and pointer receivers can lead to confusing behavior, especially when assigning instances to interfaces.

---

## Part 7: Memory Layout, Padding, and Alignment

To optimize CPU memory accesses, modern compilers align data fields to boundaries matching their sizes (e.g., a 4-byte integer aligns on a 4-byte boundary, an 8-byte pointer on an 8-byte boundary).

### Understanding Padding
If a small field is followed by a larger field, the compiler inserts unused **padding bytes** between them to align the larger field.

```go
// Inefficient Layout (Size: 24 bytes)
type BadLayout struct {
    A bool  // 1 byte
    // 7 bytes of padding inserted here
    B int64 // 8 bytes
    C bool  // 1 byte
    // 7 bytes of padding inserted here to align struct size to 8-byte boundary
}
```

```go
// Optimized Layout (Size: 16 bytes)
type GoodLayout struct {
    B int64 // 8 bytes
    A bool  // 1 byte
    C bool  // 1 byte
    // 6 bytes of padding at the end to round up to the 8-byte alignment size
}
```

> [!tip] Aligning Structs for Performance
> For memory-sensitive applications containing millions of structs, arrange fields in descending order of size (largest fields first: pointers/int64, then int32, then booleans/strings). This minimizes padding waste.

---

## Part 8: Advanced Code Examples

### Example 1: Struct Field Alignment Profiler
This example uses the `unsafe` package to demonstrate how field order changes the memory footprint of Go structs.

```go
package main

import (
	"fmt"
	"unsafe"
)

type Inefficient struct {
	IsActive  bool    // 1 byte
	Salary    float64 // 8 bytes (requires 8-byte alignment, forces 7 padding bytes)
	Age       int32   // 4 bytes
	HasCar    bool    // 1 byte  (forces 3 padding bytes to align to struct size limit)
}

type Efficient struct {
	Salary    float64 // 8 bytes
	Age       int32   // 4 bytes
	IsActive  bool    // 1 byte
	HasCar    bool    // 1 byte  (packed next to IsActive, 2 bytes padding at end)
}

func main() {
	i := Inefficient{}
	e := Efficient{}

	fmt.Printf("Inefficient Struct Size: %d bytes\n", unsafe.Sizeof(i)) // Outputs: 24 bytes
	fmt.Printf("Efficient Struct Size:   %d bytes\n", unsafe.Sizeof(e)) // Outputs: 16 bytes

	// Offsets exploration
	fmt.Println("\nField Offsets for Inefficient:")
	fmt.Printf("IsActive:  %d\n", unsafe.Offsetof(i.IsActive))
	fmt.Printf("Salary:    %d\n", unsafe.Offsetof(i.Salary))
	fmt.Printf("Age:       %d\n", unsafe.Offsetof(i.Age))
	fmt.Printf("HasCar:    %d\n", unsafe.Offsetof(i.HasCar))
}
```

### Example 2: Dynamic Validation Tag Parser
A lightweight custom runtime validation engine that checks struct fields using reflection.

```go
package main

import (
	"errors"
	"fmt"
	"reflect"
	"strings"
)

type UserRegistration struct {
	Username string `validate:"required"`
	Email    string `validate:"required,email"`
	Age      int    `validate:"min_18"`
}

func ValidateStruct(s interface{}) error {
	val := reflect.ValueOf(s)
	if val.Kind() == reflect.Ptr {
		val = val.Elem() // Dereference pointer if passed
	}

	if val.Kind() != reflect.Struct {
		return errors.New("only structs can be validated")
	}

	typ := val.Type()

	for i := 0; i < val.NumField(); i++ {
		fieldValue := val.Field(i)
		fieldType := typ.Field(i)
		tag := fieldType.Tag.Get("validate")

		if tag == "" {
			continue
		}

		rules := strings.Split(tag, ",")
		for _, rule := range rules {
			switch rule {
			case "required":
				if fieldValue.Kind() == reflect.String && fieldValue.String() == "" {
					return fmt.Errorf("field %s is required", fieldType.Name)
				}
			case "email":
				if fieldValue.Kind() == reflect.String && !strings.Contains(fieldValue.String(), "@") {
					return fmt.Errorf("field %s must be a valid email", fieldType.Name)
				}
			case "min_18":
				if fieldValue.Kind() == reflect.Int && fieldValue.Int() < 18 {
					return fmt.Errorf("field %s must be at least 18", fieldType.Name)
				}
			}
		}
	}
	return nil
}

func main() {
	user := UserRegistration{
		Username: "gopher",
		Email:    "gopher_example.com", // Invalid email
		Age:      17,                  // Too young
	}

	if err := ValidateStruct(user); err != nil {
		fmt.Println("Validation Error:", err)
	} else {
		fmt.Println("Validation Succeeded!")
	}
}
```

### Example 3: Custom JSON Serialization with Anonymous Embedding
Shows how to dynamically inject virtual fields or modify payloads during JSON marshaling.

```go
package main

import (
	"encoding/json"
	"fmt"
	"time"
)

type Transaction struct {
	ID     string    `json:"id"`
	Amount float64   `json:"amount"`
	Date   time.Time `json:"date"`
}

// MarshalJSON customizes JSON serialization by embedding and extending
func (t Transaction) MarshalJSON() ([]byte, error) {
	// Define a shadow type to avoid infinite loops during recursive Marshaling
	type Alias Transaction
	
	return json.Marshal(&struct {
		Alias
		FormattedDate string `json:"formatted_date"`
		Status        string `json:"status"`
	}{
		Alias:         Alias(t),
		FormattedDate: t.Date.Format("2006-01-02 15:04:05"),
		Status:        "PROCESSED",
	})
}

func main() {
	tx := Transaction{
		ID:     "tx-9081",
		Amount: 250.75,
		Date:   time.Now(),
	}

	jsonData, err := json.MarshalIndent(tx, "", "  ")
	if err != nil {
		panic(err)
	}

	fmt.Println(string(jsonData))
}
```

---

## Part 9: Interview Questions & Deep Dives

### Q1: What is the memory footprint of an empty struct `struct{}`? How does the compiler optimize it?
**Answer:**
An empty struct occupies `0` bytes of memory (`unsafe.Sizeof(struct{}{}) == 0`). 
To prevent excessive memory allocations, the Go compiler/runtime routes the allocations of all zero-size types (like `struct{}` or `[0]byte`) to a single internal static address named `zerobase`. 
However, when an empty struct is embedded as the **last** field in a parent struct, the compiler adds 1 byte of padding if the struct's size needs to prevent pointer logic from pointing outside the allocated memory block (which might lead to GC tracing issues).

### Q2: Why does copying a struct containing a `sync.Mutex` cause runtime bugs? How do you prevent it?
**Answer:**
A `sync.Mutex` holds internal state tracking lock ownership and waiter queues. Copying a struct that embeds or contains a mutex copies that internal state. If you copy a locked mutex, the copy will start in a locked state, but with no associated goroutine aware of its ownership. This leads to issues like deadlocks and race conditions.
To prevent this:
1. Pass structs containing mutexes exclusively via pointers (`*T`).
2. Define all method receivers for that type as pointer receivers (`func (t *T) Method()`).
3. Run `go vet ./...` as part of your CI pipeline to catch copies.

### Q3: What is the difference between `new(MyStruct)` and `&MyStruct{}`?
**Answer:**
- Both construct and allocate a `MyStruct` in memory, returning a pointer `*MyStruct` to it.
- `new(MyStruct)` only allocates zeroed memory. It cannot take parameters or perform initialization.
- `&MyStruct{}` is a composite literal syntax. It allocates memory and allows you to initialize specific fields inline.
- Structurally and in terms of compilation/execution overhead, they perform identically under escape analysis. `&MyStruct{}` is preferred by the community due to its flexibility.

### Q4: Explain field promotion in Go. What happens if two embedded structs have fields with the same name?
**Answer:**
Field promotion allows fields and methods of an embedded (anonymous) struct to be accessed directly on the parent struct without traversing the child struct's name. For example, `parent.ChildField` instead of `parent.Child.ChildField`.

If two embedded structs contain fields with matching names (e.g., `A` and `B` both contain field `Name`), the compiler does not throw an immediate error. Instead, field promotion is disabled for that name to prevent ambiguity. You can still access the fields explicitly by providing the path: `parent.A.Name` and `parent.B.Name`. If you attempt to access the ambiguous short path `parent.Name`, the compiler will throw a compilation error: `ambiguous selector parent.Name`.

### Q5: How do you achieve inheritance-like polymorphism in Go using structs?
**Answer:**
Go does not support class-based inheritance or polymorphism. Instead, it utilizes **composition via embedding** combined with **interfaces**.
1. Define behavior using an interface:
   ```go
   type Worker interface {
       Work() string
   }
   ```
2. Embed shared fields and methods in a base struct:
   ```go
   type Person struct {
       Name string
   }
   func (p Person) Work() string { return p.Name + " is working" }
   ```
3. Embed `Person` in specialized structs (`Developer`, `Manager`). If specialized behavior is needed, override the method:
   ```go
   type Developer struct {
       Person // Employs promotion
       Skill  string
   }
   // Overrides Person.Work
   func (d Developer) Work() string { return d.Name + " is coding in " + d.Skill }
   ```
4. Assign instances of `Developer` or `Person` to a variable of type `Worker`. Polymorphism is resolved at runtime based on the dynamic type assigned to the interface.
