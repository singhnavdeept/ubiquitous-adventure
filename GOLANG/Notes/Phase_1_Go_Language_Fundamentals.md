---
tags: [golang, roadmap, fundamentals, basics]
aliases: ["Phase 1: Go Language Fundamentals"]
---
# Phase 1: Go Language Fundamentals

> [!info] Introduction
> This document provides an in-depth dive into the foundational elements of the Go programming language. Go is designed to be simple, efficient, and highly readable. 

---

## 1.1 Core Syntax & Types

Go is a statically typed language with syntax that is clean and concise.

### Variables and Basic Types
> [!note] Zero Values
> In Go, variables declared without an explicit initial value are automatically given their "zero value" (e.g., `0` for ints, `""` for strings, `false` for booleans). This prevents common undefined behavior bugs found in C/C++.

Variables can be declared explicitly using the `var` keyword, or implicitly using the short declaration operator `:=`.

```go
package main

import "fmt"

func main() {
	// Explicit declaration
	var name string = "Alice"
	var age int = 30

	// Short declaration (type is inferred)
	// Can only be used inside functions
	city := "New York"
	isEmployed := true

	// Zero Values: Variables declared without an explicit initial value are given their "zero value".
	var uninitializedInt int       // 0
	var uninitializedString string // ""
	var uninitializedBool bool     // false

	fmt.Printf("%s lives in %s. Age: %d. Employed: %t\n", name, city, age, isEmployed)
	fmt.Printf("Zero values -> Int: %d, String: '%s', Bool: %t\n", uninitializedInt, uninitializedString, uninitializedBool)
}
```

### Constants
Constants are declared using the `const` keyword. `iota` is a powerful tool for creating enumerated constants.

```go
package main

import "fmt"

// Using iota for auto-incrementing constants
const (
	Read = 1 << iota // 1 << 0 = 1
	Write            // 1 << 1 = 2
	Execute          // 1 << 2 = 4
)

func main() {
	const pi = 3.14159 // Untyped constant
	fmt.Println("Pi:", pi)
	fmt.Println("Permissions:", Read, Write, Execute)
}
```

### Type Conversions
Go requires explicit type conversion. There is no implicit casting.

```go
package main

import "fmt"

func main() {
	var i int = 42
	var f float64 = float64(i) // Explicit conversion required
	var u uint = uint(f)

	fmt.Println(i, f, u)
}
```

---

## 1.2 Control Flow

Go simplifies control flow by having fewer looping constructs and straight-forward conditional statements.

### If / Else If / Else
`if` statements can include a short initialization statement before the condition. Unlike Python which has `elif`, Go explicitly uses `else if` for checking multiple conditions.

> [!tip] Best Practice
> When checking multiple conditions, it is idiomatic to use `else if` chains. If you find yourself writing more than three `else if` statements, consider using a `switch` statement instead for better readability.

```go
package main

import "fmt"

func doWork() error {
    return nil // Simulating successful work
}

func getScore() int {
    return 85
}

func main() {
	// Basic If / Else If / Else block
	score := 75
	if score >= 90 {
		fmt.Println("Grade: A")
	} else if score >= 80 {
		fmt.Println("Grade: B")
	} else if score >= 70 {
		fmt.Println("Grade: C")
	} else {
		fmt.Println("Grade: F")
	}

	// Idiomatic Go: Initialize err and check it in the same line
	if err := doWork(); err != nil {
		fmt.Println("Error occurred:", err)
	} else {
		fmt.Println("Work completed successfully.")
	}

	// Initialization statement with else if
	// The variable 's' is scoped to the entire if/else if/else chain
	if s := getScore(); s >= 90 {
		fmt.Println("Excellent! Score:", s)
	} else if s >= 80 {
		fmt.Println("Great job! Score:", s)
	} else {
		fmt.Println("Keep trying. Score:", s)
	}
}
```

### For Loops
Go has only one loop construct: the `for` loop. It can act as a traditional `for` loop, a `while` loop, or an infinite loop.

```go
package main

import "fmt"

func main() {
	// Traditional for loop
	for i := 0; i < 3; i++ {
		fmt.Println("Standard:", i)
	}

	// While loop equivalent
	j := 0
	for j < 3 {
		fmt.Println("While-like:", j)
		j++
	}

	// Range loop (iterating over slices, arrays, maps, etc.)
	colors := []string{"Red", "Green", "Blue"}
	for index, color := range colors {
		fmt.Printf("Color at index %d is %s\n", index, color)
	}
}
```

### Switch Statements
Switch statements do not fall through by default (unlike C or Java).

```go
package main

import "fmt"

func main() {
	day := "Tuesday"

	switch day {
	case "Saturday", "Sunday":
		fmt.Println("It's the weekend!")
	case "Monday":
		fmt.Println("Start of the work week.")
	default:
		fmt.Println("Midweek day.")
	}
}
```

### Defer
`defer` delays the execution of a function until the surrounding function returns. Defers are executed in Last-In-First-Out (LIFO) order.

```go
package main

import "fmt"

func main() {
	defer fmt.Println("1. This runs last.")
	defer fmt.Println("2. This runs second to last.")
	
	fmt.Println("3. This runs first.")
}
```

---

## 1.3 Functions

Functions are first-class citizens in Go. They can return multiple values and be passed as arguments.

```go
package main

import (
	"errors"
	"fmt"
)

// Multiple return values (common idiom for returning result + error)
func divide(a, b float64) (float64, error) {
	if b == 0 {
		return 0, errors.New("cannot divide by zero")
	}
	return a / b, nil
}

// Named return values (variables are initialized to zero values)
func split(sum int) (x, y int) {
	x = sum * 4 / 9
	y = sum - x
	return // Implicitly returns x and y
}

// Variadic functions (accepts a variable number of arguments)
func sum(nums ...int) int {
	total := 0
	for _, n := range nums {
		total += n
	}
	return total
}

func main() {
	res, err := divide(10, 2)
	fmt.Println("Divide:", res, err)

	x, y := split(17)
	fmt.Println("Split:", x, y)

	fmt.Println("Sum:", sum(1, 2, 3, 4, 5))
}
```

---

## 1.4 Data Structures

### Arrays and Slices
Arrays have fixed sizes. Slices are dynamic wrappers around arrays and are used pervasively.

```go
package main

import "fmt"

func main() {
	// Array: Fixed size
	var arr [3]int = [3]int{1, 2, 3}
	
	// Slice: Dynamic size
	slice := []int{1, 2, 3}
	
	// Appending to a slice
	slice = append(slice, 4, 5)
	
	// Slices have length (len) and capacity (cap)
	// Under the hood, append allocates a new, larger array if capacity is exceeded.
	fmt.Printf("Slice: %v, Length: %d, Capacity: %d\n", slice, len(slice), cap(slice))

	// Creating slices with make
	dynamicSlice := make([]int, 0, 5) // length 0, capacity 5
	fmt.Println(dynamicSlice)
}
```

### Maps
Maps are unordered collections of key-value pairs.

```go
package main

import "fmt"

func main() {
	// Initialize a map using make
	balances := make(map[string]int)
	balances["Alice"] = 100
	balances["Bob"] = 200

	// The "comma-ok" idiom checks if a key exists
	val, ok := balances["Charlie"]
	if !ok {
		fmt.Println("Charlie is not in the map.")
	} else {
		fmt.Println("Charlie's balance:", val)
	}
}
```

### Structs and Pointers
Structs group related data together. Pointers allow you to reference the memory address of a value to mutate it directly or avoid copying large amounts of data.

```go
package main

import "fmt"

type User struct {
	Name  string
	Email string
	Age   int
}

// Function modifying a struct using a pointer
func updateEmail(u *User, newEmail string) {
	u.Email = newEmail // Note: Go automatically dereferences the pointer
}

func main() {
	// Initialize struct
	user := User{Name: "Alice", Email: "alice@example.com", Age: 30}
	
	// Pass by reference using the address-of operator '&'
	updateEmail(&user, "alice.new@example.com")
	
	fmt.Println(user.Email) // Prints updated email
}
```

---

## 1.5 Methods & Interfaces

### Methods
Methods are functions attached to a specific type (a struct or alias).

```go
package main

import "fmt"

type Rectangle struct {
	Width, Height float64
}

// Value receiver: Operates on a copy. Used when we don't need to modify the struct.
func (r Rectangle) Area() float64 {
	return r.Width * r.Height
}

// Pointer receiver: Operates on the actual instance. Used when modification is required or struct is large.
func (r *Rectangle) Scale(factor float64) {
	r.Width *= factor
	r.Height *= factor
}

func main() {
	rect := Rectangle{Width: 10, Height: 5}
	fmt.Println("Area:", rect.Area())
	rect.Scale(2)
	fmt.Println("New Area:", rect.Area())
}
```

### Interfaces
Interfaces in Go are implemented *implicitly*. If a type provides all the methods defined by an interface, it satisfies that interface. No `implements` keyword is needed.

```go
package main

import "fmt"

// Define interface
type Shape interface {
	Area() float64
}

type Circle struct {
	Radius float64
}

func (c Circle) Area() float64 {
	return 3.14 * c.Radius * c.Radius
}

// Accepts any type that satisfies the Shape interface
func printArea(s Shape) {
	fmt.Println("Area is:", s.Area())
}

func main() {
	c := Circle{Radius: 5}
	printArea(c) // Circle implicitly implements Shape
}
```

---

## 1.6 Error Handling

> [!warning] Philosophy
> Go does not have `try/catch` exceptions. Instead, it treats errors as normal values that implement the built-in `error` interface. You must explicitly check and handle errors.

Go's philosophy treats errors as normal return values rather than throwing exceptions.

```go
package main

import (
	"errors"
	"fmt"
)

// Custom error type
type NotFoundError struct {
	ItemID string
}

// Implement the error interface
func (e *NotFoundError) Error() string {
	return fmt.Sprintf("Item %s not found", e.ItemID)
}

func fetchItem(id string) (string, error) {
	if id == "" {
		// Standard simple error
		return "", errors.New("id cannot be empty")
	}
	if id != "123" {
		// Returning a custom error
		return "", &NotFoundError{ItemID: id}
	}
	return "Item Data", nil
}

func main() {
	_, err := fetchItem("999")
	if err != nil {
		// Using errors.As to unwrap and check for a specific custom error type
		var notFound *NotFoundError
		if errors.As(err, &notFound) {
			fmt.Printf("Custom Handling: %s was missing.\n", notFound.ItemID)
		} else {
			fmt.Println("Generic Error:", err)
		}
	}
}
```

---

## 1.7 Packages & Modules

Go projects are structured into modules. A module is a collection of packages. 
- Initialize a module: `go mod init github.com/username/project`
- Add dependencies: `go get github.com/some/pkg`
- Clean up dependencies: `go mod tidy`

### Visibility
In Go, visibility is controlled by capitalization.
- **Capitalized** names (e.g., `FetchData()`, `User{}`) are **exported** (public).
- **Lowercase** names (e.g., `calculateInternal()`, `dbConnection{}`) are **unexported** (private to the package).

---

## Interview Questions - Phase 1

1. **What is the difference between an Array and a Slice in Go?**
   *Answer:* Arrays have a fixed, unchangeable length defined at compile time and are passed by value. Slices are dynamically-sized, flexible wrappers around arrays. Slices consist of a pointer to the underlying array, a length, and a capacity. Slices are passed by reference (the slice header is copied, but it points to the same underlying array).

2. **How does the `defer` keyword work?**
   *Answer:* `defer` pushes a function call onto a list. The list of saved calls is executed after the surrounding function returns, in Last-In-First-Out (LIFO) order. It is commonly used for cleanup operations like closing files, unlocking mutexes, or recovering from panics.

3. **How does Go achieve Object-Oriented polymorphism without inheritance?**
   *Answer:* Go uses **Interfaces** to achieve polymorphism. Interfaces define a behavior (a set of method signatures). Any type that implements those methods implicitly satisfies the interface. This favors composition over inheritance.

4. **When should you use a value receiver vs. a pointer receiver on a method?**
   *Answer:* Use a pointer receiver when:
   - The method needs to mutate the state of the receiver.
   - The receiver is a large struct, and you want to avoid the performance cost of copying it for every method call.
   Use a value receiver when:
   - The type is small (like a primitive type or a small struct).
   - The method does not need to modify the receiver (read-only operations).

5. **Explain Go's approach to Error Handling compared to Exceptions in other languages.**
   *Answer:* Go does not have `try/catch` exceptions. Instead, it treats errors as normal values that implement the built-in `error` interface. Functions typically return the result along with an `error` as the last return value. The caller is expected to explicitly check `if err != nil` and handle it. This encourages developers to think about failure states and handle them deliberately.

6. **What is the zero value in Go?**
   *Answer:* When a variable is declared without being assigned an explicit initial value, Go automatically initializes it to its "zero value". This is `0` for numeric types, `false` for booleans, `""` (empty string) for strings, and `nil` for pointers, slices, maps, channels, and interfaces.
