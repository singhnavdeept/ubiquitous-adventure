---
tags: [golang, roadmap, microservices, kafka]
aliases: ["Phase 8: Microservices Patterns"]
---
# Phase 8: Microservices Patterns

Microservices bring the benefit of decoupling and independent deployment, but they introduce extreme complexity in network communication, data consistency, and error handling.

---

## 8.1 Synchronous vs Asynchronous Communication

When designing microservices, how they talk to each other is the most critical decision.

- **Synchronous (REST / gRPC)**: Service A calls Service B and waits for the response. 
  - *Pros*: Simple to understand, immediate consistency. 
  - *Cons*: Temporal coupling (Service B must be up when A calls it), cascading failures.
- **Asynchronous (Message Queues)**: Service A publishes an event to a broker. Service B reads it eventually.
  - *Pros*: Decoupled (A doesn't care if B is down), highly scalable, absorbs traffic spikes.
  - *Cons*: Eventual consistency, complex to debug.

---

## 8.2 Message Queues

### Kafka
Apache Kafka is the industry standard for high-throughput, fault-tolerant event streaming. In Go, you can use `segmentio/kafka-go` or `confluentinc/confluent-kafka-go`.

```go
package main

import (
	"context"
	"fmt"
	"log"

	"github.com/segmentio/kafka-go"
)

// Consumer Example
func consumeMessages() {
	// Initialize a new reader with the brokers and topic
	r := kafka.NewReader(kafka.ReaderConfig{
		Brokers:   []string{"localhost:9092"},
		Topic:     "user-events",
		GroupID:   "email-service-group",
		MinBytes:  10e3, // 10KB
		MaxBytes:  10e6, // 10MB
	})

	for {
		// ReadMessage blocks until a message is available
		m, err := r.ReadMessage(context.Background())
		if err != nil {
			log.Fatalf("could not read message: %v", err)
		}
		fmt.Printf("Received: %s = %s\n", string(m.Key), string(m.Value))
	}
}
```

### NATS
NATS is an incredibly fast, lightweight messaging system often preferred in Go ecosystems over Kafka when persistent event streaming isn't strictly required, or when simplicity is prioritized.

---

## 8.3 Resilience Patterns

In a distributed system, network calls *will* fail. You must design for failure.

### Circuit Breaker
If Service B is failing, Service A should stop calling it to give it time to recover and to prevent Service A from exhausting its own resources waiting for timeouts.

```go
package main

import (
	"fmt"
	"github.com/sony/gobreaker"
	"io/ioutil"
	"net/http"
)

var cb *gobreaker.CircuitBreaker

func init() {
	st := gobreaker.Settings{
		Name:        "HTTPClient",
		MaxRequests: 3, // Requests allowed in half-open state
		Interval:    0, // Cyclic period of closed state
		Timeout:     5, // Time to wait in open state before trying half-open
		ReadyToTrip: func(counts gobreaker.Counts) bool {
			// Trip the breaker if 3 consecutive failures occur
			return counts.ConsecutiveFailures >= 3
		},
	}
	cb = gobreaker.NewCircuitBreaker(st)
}

func fetchExternalData() ([]byte, error) {
	// Wrap the network call in the circuit breaker
	body, err := cb.Execute(func() (interface{}, error) {
		resp, err := http.Get("http://unreliable-service.com/api")
		if err != nil {
			return nil, err
		}
		defer resp.Body.Close()
		return ioutil.ReadAll(resp.Body)
	})

	if err != nil {
		return nil, err
	}
	return body.([]byte), nil
}
```

### Retry with Exponential Backoff
If a call fails due to a transient network glitch, automatically retrying is a good idea. However, retrying immediately can overwhelm the downstream service. Use exponential backoff (wait 1s, then 2s, then 4s, etc.).

Packages like `avast/retry-go` make this trivial.

---

## 8.4 Service Discovery

In Kubernetes, you usually don't need Consul or etcd for service discovery. Kubernetes provides an internal DNS.

If Service A wants to call Service B (named `user-service`), Service A simply makes an HTTP/gRPC call to `http://user-service:8080`. CoreDNS inside Kubernetes automatically resolves `user-service` to the dynamic IP addresses of the running pods.

---

## 8.5 API Gateway

Instead of front-end clients (Mobile apps, Web apps) calling 15 different microservices directly, they call a single API Gateway.
The Gateway is responsible for:
1. Routing requests to the correct internal service.
2. Authenticating requests (verifying JWTs) and stripping headers.
3. Rate Limiting.
4. Translating protocols (e.g., accepting REST from the client, communicating via gRPC internally).

---

## Interview Questions - Phase 8

1. **What is the difference between Orchestration and Choreography in microservices?**
   *Answer:* They are approaches to managing distributed transactions (Sagas).
   - **Orchestration**: A central "brain" (Orchestrator service) tells other services what to do (e.g., "Order Service tells Payment Service to charge, then tells Inventory Service to reserve").
   - **Choreography**: No central brain. Services listen to events and react autonomously (e.g., Order Service publishes "Order Created". Payment Service hears it and charges the card. It then publishes "Payment Successful", which Inventory Service hears and reserves stock).

2. **What is the Circuit Breaker pattern?**
   *Answer:* It's a resilience pattern used to prevent cascading failures. It wraps a fragile network call. If the call fails repeatedly, the circuit breaker "trips" (opens). While open, any further calls instantly return an error without actually making the network request, giving the failing downstream service time to recover. After a timeout, it allows a limited number of test requests through (half-open). If they succeed, the circuit closes again.

3. **Why shouldn't you just retry every failed network request?**
   *Answer:* Blindly retrying can cause a "retry storm". If a downstream service is already struggling under heavy load, having every client retry their failed requests 3 times will effectively quadruple the load, guaranteeing the service crashes. Retries must be limited, and should use "Exponential Backoff and Jitter" to stagger the retry attempts.

4. **In Kafka, what is a Consumer Group?**
   *Answer:* A Consumer Group allows you to scale out processing. If you have a topic with 10 partitions, and you start 5 instances of your Go application all sharing the same `GroupID`, Kafka will balance the load by assigning 2 partitions to each instance. Each message is processed by exactly one consumer within the group.
