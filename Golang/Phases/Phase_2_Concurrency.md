---
tags: [golang, roadmap, concurrency, goroutines]
aliases: ["Phase 2: Concurrency"]
---

# Phase 2: Concurrency

> [!info] The Go Concurrency Philosophy
> Concurrency is arguably Go's most famous feature. The Go concurrency model is built around Tony Hoare's Communicating Sequential Processes (CSP) paper. The core motto is: **"Do not communicate by sharing memory; instead, share memory by communicating."**

In this phase, we dive deep into how Go manages concurrent execution under the hood, and how to write robust, non-blocking, and data-race-free code.

---

## 2.1 Goroutines and the Scheduler

> [!tip] Concurrency vs. Parallelism
> **Concurrency** is about *dealing* with a lot of things at once (structure).
> **Parallelism** is about *doing* a lot of things at once (execution).
> Goroutines allow you to structure concurrent code easily, which the runtime can execute in parallel if multiple cores are available.

A goroutine is a lightweight thread managed by the Go runtime. 

### Deep Dive: The M:N Scheduler
Unlike OS threads (which are 1:1 mapped to kernel threads and have a fixed, large stack of ~1-2MB), goroutines use an **M:N scheduling model**:
- **M** OS Threads execute **N** Goroutines.
- Goroutines start with a tiny stack (typically 2KB) that grows and shrinks dynamically.
- The Go runtime includes its own scheduler which multiplexes these Goroutines onto available OS threads.

#### The Work-Stealing Algorithm
The scheduler uses three entities:
1. **G (Goroutine)**: Represents the execution context.
2. **M (Machine)**: An OS thread.
3. **P (Processor)**: A logical processor (context) required to execute Go code. The number of Ps is determined by `GOMAXPROCS` (defaults to the number of CPU cores).

Every **P** has a Local Run Queue of **G**s. If an **M** finishes executing all **G**s in its local queue, it will "steal" half of the runnable goroutines from another **P**'s queue. This ensures all CPU cores remain busy without heavy centralized locking.

```go
package main

import (
	"fmt"
	"runtime"
	"sync"
)

func main() {
	// GOMAXPROCS limits the number of operating system threads that can execute user-level Go code simultaneously.
	fmt.Printf("Logical CPUs: %d\n", runtime.NumCPU())
	
	// Optional: force the runtime to use a specific number of cores
	// runtime.GOMAXPROCS(2)

	var wg sync.WaitGroup

	// Launching 100,000 goroutines is trivial and fast in Go
	for i := 0; i < 100000; i++ {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()
			// Tiny amount of work
		}(i)
	}

	wg.Wait()
	fmt.Println("100,000 Goroutines finished execution.")
}
```

---

## 2.2 Channels: Theory and Practice

Channels are typed conduits through which you can send and receive values. They are the primary means for goroutines to synchronize without using explicit locks.

> [!deep-dive] Under the Hood: `hchan`
> In the Go runtime, a channel is a pointer to an `hchan` struct. It contains:
> 1. A circular queue (for buffered channels).
> 2. A mutex lock to protect all operations.
> 3. Send and receive wait queues (linked lists of waiting Goroutines/`sudog`s).
> When a goroutine tries to read from an empty channel, the scheduler parks the goroutine, puts it in the channel's wait queue, and frees the OS thread to do other work.

### Unbuffered vs Buffered Channels

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	// 1. Unbuffered Channel (Synchronous Handoff)
	// Sender blocks until a receiver is ready. Both must be present at the exact same time.
	unbufChan := make(chan string)

	go func() {
		fmt.Println("Unbuffered sender waiting...")
		unbufChan <- "Data" // Blocks here
		fmt.Println("Unbuffered sender unblocked!")
	}()

	time.Sleep(1 * time.Second)
	fmt.Println("Receiver ready.")
	fmt.Println(<-unbufChan)

	// 2. Buffered Channel (Asynchronous up to capacity)
	// Sender only blocks when the buffer is full. Receiver blocks when buffer is empty.
	bufChan := make(chan int, 3) // Capacity of 3

	bufChan <- 1
	bufChan <- 2
	bufChan <- 3
	// bufChan <- 4 // If we uncomment this, it causes a deadlock panic because the buffer is full!

	fmt.Println("Buffered values:", <-bufChan, <-bufChan, <-bufChan)
}
```

### The `select` Statement and Timeouts
`select` is a powerful construct that lets a goroutine wait on multiple channel operations simultaneously.

> [!warning] Select randomly chooses ready cases
> If multiple channels in a `select` are ready at the same time, Go evaluates them pseudo-randomly to avoid starvation.

```go
package main

import (
	"fmt"
	"time"
)

func fetchAPI(url string, out chan<- string) {
	time.Sleep(2 * time.Second) // Simulate network delay
	out <- "Response from " + url
}

func main() {
	apiChan := make(chan string)
	
	go fetchAPI("https://slow-api.com", apiChan)

	// A common pattern: Wait for data OR timeout
	select {
	case res := <-apiChan:
		fmt.Println("Success:", res)
	case <-time.After(1 * time.Second): // Returns a channel that sends the time after the duration
		fmt.Println("Error: API request timed out!")
	}
}
```

---

## 2.3 The Sync Package

While channels handle communication, the `sync` package provides low-level synchronization primitives.

### WaitGroup and Mutex

```go
package main

import (
	"fmt"
	"sync"
)

// SafeCounter is safe to use concurrently.
type SafeCounter struct {
	mu sync.RWMutex // RWMutex allows multiple readers, but only one writer
	v  map[string]int
}

// Inc increments the counter safely.
func (c *SafeCounter) Inc(key string) {
	c.mu.Lock() // Exclusive lock
	defer c.mu.Unlock()
	c.v[key]++
}

// Value returns the current value safely.
func (c *SafeCounter) Value(key string) int {
	c.mu.RLock() // Read lock - multiple goroutines can hold an RLock simultaneously
	defer c.mu.RUnlock()
	return c.v[key]
}

func main() {
	c := SafeCounter{v: make(map[string]int)}
	var wg sync.WaitGroup

	for i := 0; i < 1000; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			c.Inc("somekey")
		}()
	}

	wg.Wait()
	fmt.Println("Final Count:", c.Value("somekey"))
}
```

### `sync.Once` and `sync.Pool`
- **`sync.Once`**: Ensures a function is executed exactly once, regardless of how many goroutines call it. Perfect for lazy initialization (e.g., singleton database connection).
- **`sync.Pool`**: A temporary object pool that caches allocated objects for reuse, drastically reducing Garbage Collection pressure in high-throughput applications.

---

## 2.4 The Context Package: Cancellation and Propagation

The `context` package is vital for backend systems. It handles cancellation, timeouts, and request-scoped values down the call graph.

> [!tip] The Golden Rules of Context
> 1. Never store Contexts inside a struct type; pass them explicitly as the first parameter (named `ctx`).
> 2. Never pass a `nil` Context. Use `context.TODO()` if unsure.
> 3. Always defer the `cancel()` function returned by `WithCancel`, `WithTimeout`, or `WithDeadline` to avoid memory leaks.

```go
package main

import (
	"context"
	"fmt"
	"time"
)

func databaseQuery(ctx context.Context) (string, error) {
	// Simulate long-running query
	queryChan := make(chan string)
	go func() {
		time.Sleep(3 * time.Second)
		queryChan <- "Data Retrieved"
	}()

	select {
	case <-ctx.Done(): // Triggered if the context times out or is explicitly canceled
		return "", fmt.Errorf("query aborted: %w", ctx.Err())
	case res := <-queryChan:
		return res, nil
	}
}

func main() {
	// Create a context with a strict 2-second timeout
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()

	fmt.Println("Starting query...")
	res, err := databaseQuery(ctx)
	if err != nil {
		fmt.Println("Error:", err) // Will print "query aborted: context deadline exceeded"
	} else {
		fmt.Println("Result:", res)
	}
}
```

---

## 2.5 Advanced Concurrency Patterns

### 1. Fan-Out, Fan-In (Pipeline)
A common pattern for data processing. You have a generator creating tasks, multiple workers processing them (Fan-Out), and a multiplexer combining the results (Fan-In).

```go
package main

import (
	"fmt"
	"sync"
)

// Generator: converts variadic integers into a channel
func generate(nums ...int) <-chan int {
	out := make(chan int)
	go func() {
		for _, n := range nums {
			out <- n
		}
		close(out) // Important: close generator channel when done
	}()
	return out
}

// Worker: reads from input channel, processes, sends to output channel
func squareWorker(in <-chan int) <-chan int {
	out := make(chan int)
	go func() {
		for n := range in {
			out <- n * n
		}
		close(out)
	}()
	return out
}

// Fan-In: Merges multiple channels into one
func merge(cs ...<-chan int) <-chan int {
	var wg sync.WaitGroup
	out := make(chan int)

	output := func(c <-chan int) {
		for n := range c {
			out <- n
		}
		wg.Done()
	}

	wg.Add(len(cs))
	for _, c := range cs {
		go output(c)
	}

	// Close the output channel once all workers are done
	go func() {
		wg.Wait()
		close(out)
	}()

	return out
}

func main() {
	in := generate(1, 2, 3, 4, 5, 6)

	// Fan-Out: Distribute work across 2 workers
	w1 := squareWorker(in)
	w2 := squareWorker(in)

	// Fan-In: Consume results from all workers
	for result := range merge(w1, w2) {
		fmt.Println(result)
	}
}
```

### 2. Errgroup (`golang.org/x/sync/errgroup`)
If you have multiple goroutines running sub-tasks for a single HTTP request, and you want to abort *all* of them if *any* of them returns an error, `errgroup` is the standard tool.

```go
// import "golang.org/x/sync/errgroup"
// 
// g, ctx := errgroup.WithContext(context.Background())
// 
// g.Go(func() error {
//     return fetchUser(ctx)
// })
// g.Go(func() error {
//     return fetchPermissions(ctx)
// })
// 
// // Wait blocks until all functions finish or one returns an error
// if err := g.Wait(); err != nil {
//     log.Fatal(err)
// }
```

---

## 2.6 Race Conditions & The Race Detector

> [!warning] The Danger of Data Races
> A **Data Race** occurs when two goroutines access the same memory concurrently, and at least one of them is a write. In Go, data races cause undefined behavior and can corrupt memory, leading to bizarre crashes that are impossible to reproduce predictably.

Always compile and test with the race detector enabled:
```bash
go test -race ./...
go run -race main.go
go build -race -o myapp # Only for debugging, adds overhead!
```

---

## Interview Questions - Phase 2

1. **What is the difference between a goroutine and an OS thread?**
   *Answer:* OS threads are managed by the kernel, have a large initial stack (usually 1-2 MB), and context switching requires a kernel trap which is expensive. Goroutines are managed by the Go runtime scheduler (user space), have a tiny initial stack (2 KB that grows dynamically), and are multiplexed onto OS threads using an M:N model. Context switching between goroutines is incredibly cheap.

2. **Explain the Go Scheduler's "Work Stealing" mechanism.**
   *Answer:* The scheduler relies on `M` (OS Threads), `P` (Logical Processors), and `G` (Goroutines). Every `P` maintains a Local Run Queue of `G`s. If an `M` finishes executing all `G`s in its `P`'s local queue, it will look at the global queue, and if empty, it will "steal" half of the runnable goroutines from another `P`'s queue. This balances the load across cores without requiring a global lock on every goroutine dispatch.

3. **When would you use a buffered vs. unbuffered channel?**
   *Answer:* Use an unbuffered channel for strict synchronization (a handoff). The sender blocks until the receiver is ready, ensuring both are at a known state. Use a buffered channel when you want to decouple the sender and receiver temporarily, allowing the sender to push data and move on (e.g., worker pools or preventing sender blocking in fire-and-forget metrics logging).

4. **What happens if you send data to a closed channel? What if you read from it?**
   *Answer:* Sending data to a closed channel will cause a **panic**. Reading from a closed channel will succeed immediately, returning the remaining buffered values. Once the buffer is empty, it will continuously return the zero value of the channel's type. You use the comma-ok idiom (`val, ok := <-ch`) to check if the channel is closed.

5. **Why is it important to always call `cancel()` on a `context`?**
   *Answer:* Failing to call the cancel function returned by `WithCancel`, `WithTimeout`, or `WithDeadline` results in a context leak. Background goroutines waiting on that context's `Done()` channel will never wake up, and internal timers created by the context are not freed until the parent context is canceled or the timer naturally expires, slowly exhausting system memory.

6. **How does `select` decide which case to run if multiple channels are ready?**
   *Answer:* If multiple cases in a `select` statement are ready simultaneously, the Go runtime picks one at random (pseudo-randomly). This is an intentional design choice to prevent starvation, ensuring that one highly active channel does not dominate and starve the other channels of processing time.
