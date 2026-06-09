---
tags: [golang, roadmap, devops, docker, kubernetes]
aliases: ["Phase 9: Deployment & DevOps"]
---
# Phase 9: Deployment & DevOps

Because Go compiles to a single, statically-linked binary, it is incredibly easy to deploy. It is the language of the cloud-native ecosystem (Docker, Kubernetes, Terraform are all written in Go).

---

## 9.1 Docker (Multi-stage Builds)

A multi-stage Dockerfile is essential for Go. 
- Stage 1: Uses the heavy Go SDK image to download dependencies and compile the code.
- Stage 2: Uses a tiny base image (like Alpine or Distroless), copies *only* the compiled binary from Stage 1, and runs it.

This results in Docker images that are often less than 20MB!

```dockerfile
# ---------------------------------------------------
# Stage 1: Build the binary
# ---------------------------------------------------
FROM golang:1.22-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum first to leverage Docker layer caching
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Compile the Go application
# CGO_ENABLED=0 ensures a completely static binary
# GOOS=linux sets the target OS
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main ./cmd/server

# ---------------------------------------------------
# Stage 2: Build the minimal runtime image
# ---------------------------------------------------
FROM gcr.io/distroless/static-debian11

WORKDIR /root/

# Copy only the compiled binary from the 'builder' stage
COPY --from=builder /app/main .

# Expose port
EXPOSE 8080

# Run the binary
CMD ["./main"]
```

---

## 9.2 Kubernetes Basics

Go services are typically deployed as stateless Pods managed by Deployments in Kubernetes.

*Example `deployment.yaml`:*
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: user-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: user-service
  template:
    metadata:
      labels:
        app: user-service
    spec:
      containers:
      - name: user-service
        image: myregistry.com/user-service:v1.0.0
        ports:
        - containerPort: 8080
        # Readiness Probe ensures traffic isn't routed until the app is ready
        readinessProbe:
          httpGet:
            path: /healthz
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
        # Resource constraints
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "250m"
```

---

## 9.3 Observability

In production, you cannot SSH into servers and read text files to debug. You need Observability: Logging, Metrics, and Tracing.

### 1. Structured Logging
Never use standard `fmt.Println` or the default `log` package in production. You need JSON-structured logs so they can be queried in tools like Elasticsearch or Datadog.

Use packages like `uber-go/zap` or the built-in `log/slog` (Go 1.21+).

```go
package main

import "log/slog"

func main() {
	// Initialize a JSON logger
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	
	logger.Info("User logged in", 
		slog.String("user_id", "12345"), 
		slog.String("ip", "192.168.1.1"),
	)
	// Output: {"time":"...","level":"INFO","msg":"User logged in","user_id":"12345","ip":"192.168.1.1"}
}
```

### 2. Metrics (Prometheus)
Metrics track quantitative data (e.g., Request rate, Error rate, Latency). Use the `prometheus/client_golang` package to expose a `/metrics` endpoint.

- **Counter**: Goes up only (e.g., Total HTTP Requests).
- **Gauge**: Goes up and down (e.g., Current Active Goroutines).
- **Histogram**: Samples observations into buckets (e.g., HTTP Request Latency).

### 3. Distributed Tracing (OpenTelemetry)
If a request hits the API Gateway -> User Service -> DB -> Event Bus -> Email Service... how do you find out where the bottleneck was?
Tracing attaches a unique `trace_id` to a request at the gateway, which is passed along to every downstream service via the Go `context`.

---

## Interview Questions - Phase 9

1. **Why do we use Multi-stage Dockerfiles for Go applications?**
   *Answer:* Go is a compiled language. You only need the Go compiler and source code to *build* the application, but you don't need them to *run* the application. A multi-stage build allows us to use a heavy image to build the binary, and then copy only that final, statically-linked binary into an ultra-minimal base image (like Alpine or Distroless). This reduces the image size from ~800MB to ~15MB, making deployments vastly faster and significantly reducing the attack surface.

2. **What does `CGO_ENABLED=0` do?**
   *Answer:* It disables CGO. By default, Go programs can link against C libraries (like glibc). If you compile a Go program with CGO enabled on Ubuntu, it might not run on Alpine Linux because Alpine uses `musl libc` instead of `glibc`. Disabling CGO forces the Go compiler to build a 100% statically-linked binary that contains absolutely everything it needs to run, making it perfectly portable across any Linux distribution.

3. **What is the difference between a Liveness Probe and a Readiness Probe in Kubernetes?**
   *Answer:* 
   - **Readiness Probe**: Checks if the application is ready to accept incoming HTTP traffic. If it fails (e.g., because it's still establishing a database connection), Kubernetes will remove the pod from the Service load balancer, but it won't kill the container.
   - **Liveness Probe**: Checks if the application is fundamentally dead or deadlocked. If it fails, Kubernetes will actively restart (kill and recreate) the container.

4. **Why is Structured Logging important?**
   *Answer:* Plain text logs are meant for humans to read, but in distributed systems, logs are aggregated centrally and parsed by machines. If you output logs in a structured format (like JSON), log aggregation systems can instantly index fields (like `user_id`, `latency`, `level`). This allows you to write complex queries like "Show me all ERROR logs where user_id=123 and latency > 500ms" which is nearly impossible with unstructured text logs.
