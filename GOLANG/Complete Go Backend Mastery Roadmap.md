
> From "Hello World" to Production-Grade Systems

---

## Table of Contents

1. [Why Go for Backend?](https://claude.ai/chat/b2c5d838-3597-4947-b2e7-e2e702789d7b#why-go-for-backend)
2. [How Go Is Used in Industry](https://claude.ai/chat/b2c5d838-3597-4947-b2e7-e2e702789d7b#how-go-is-used-in-industry)
3. [The Learning Roadmap (Phase by Phase)](https://claude.ai/chat/b2c5d838-3597-4947-b2e7-e2e702789d7b#the-learning-roadmap)
4. [Incremental Projects](https://claude.ai/chat/b2c5d838-3597-4947-b2e7-e2e702789d7b#incremental-projects)
5. [Resources](https://claude.ai/chat/b2c5d838-3597-4947-b2e7-e2e702789d7b#resources)
6. [Interview & Job Readiness](https://claude.ai/chat/b2c5d838-3597-4947-b2e7-e2e702789d7b#interview--job-readiness)

---

## Why Go for Backend?

Go (Golang) was created at Google in 2009 to solve real-world engineering problems at scale. It has become one of the most sought-after languages in backend engineering because:

- **Compiled & Fast** — Go compiles to native machine code. Execution speed approaches C/C++.
- **Concurrency is a first-class citizen** — Goroutines and channels make concurrent programming approachable and safe.
- **Statically typed with a simple syntax** — The entire language spec fits in a single web page.
- **Single binary deployment** — Your whole application compiles into one executable. No runtime dependencies.
- **Excellent standard library** — HTTP servers, JSON encoding, file I/O, crypto — all built in.
- **Fast build times** — Even large codebases compile in seconds.
- **Strong ecosystem** — Docker, Kubernetes, Terraform, Prometheus, CockroachDB, and Caddy are all written in Go.

---

## How Go Is Used in Industry

Understanding where Go lives in real systems will give you purpose while learning.

### Primary Use Cases

|Domain|What Gets Built|Real-World Examples|
|---|---|---|
|**Microservices**|Small, independent services talking over HTTP/gRPC|Netflix, Uber, Dropbox|
|**API Backends**|RESTful APIs, GraphQL servers|Twitch, SoundCloud|
|**DevOps & Platform Tools**|CLIs, deployment agents, infra automation|Docker, Kubernetes, Terraform|
|**Distributed Systems**|Message queues, consensus protocols, coordination|etcd (used inside K8s), CockroachDB|
|**Networking & Proxies**|Reverse proxies, load balancers, service meshes|Caddy, Envoy (partial), Linkerd|
|**Data Pipelines**|Stream processors, ingestion agents|InfluxDB, Prometheus|
|**Cloud Infrastructure**|Cloud provider SDKs, serverless runtimes|AWS Lambda Go runtime|

### How a Typical Go Backend Looks at a Startup/Mid-size Company

```
Client (Mobile/Web)
      │
      ▼
  API Gateway  ──── Rate Limiter / Auth (Go Service)
      │
  ┌───┴────────────────────────────────┐
  │            Go Microservices        │
  │  ┌──────────┐  ┌────────────────┐  │
  │  │ User Svc │  │  Orders Svc    │  │
  │  │  (REST)  │  │  (gRPC)        │  │
  │  └────┬─────┘  └──────┬─────────┘  │
  └───────┼───────────────┼────────────┘
          │               │
    ┌─────▼──────┐  ┌─────▼──────┐
    │ PostgreSQL │  │   Redis     │
    │ (primary)  │  │  (cache)    │
    └────────────┘  └────────────┘
          │
    ┌─────▼──────┐
    │   Kafka    │  ← Event streaming between services
    └────────────┘
```

### What a Go Backend Engineer Does Day-to-Day

- Writes and maintains REST or gRPC API endpoints
- Designs database schemas and writes SQL queries / ORM models
- Builds background workers and job queues
- Writes unit, integration, and benchmark tests
- Deploys services using Docker + Kubernetes
- Monitors services with Prometheus + Grafana dashboards
- Participates in on-call rotations, analyzes incidents

---

## The Learning Roadmap

> **Estimated total time:** 6–9 months with 2–3 hours/day of deliberate practice.

---

### 🟢 Phase 1 — Go Language Fundamentals (Weeks 1–4)

**Goal:** Become fluent in Go's core syntax and understand how it differs from other languages.

#### 1.1 Core Syntax & Types

- [ ] Variables: `var`, `:=`, zero values
- [ ] Basic types: `int`, `float64`, `string`, `bool`, `byte`, `rune`
- [ ] Constants with `const` and `iota`
- [ ] Type conversions (explicit, no implicit casting)
- [ ] Formatted output: `fmt.Println`, `fmt.Printf`, `fmt.Sprintf`

#### 1.2 Control Flow

- [ ] `if`, `else`, `else if` (with init statement: `if err := foo(); err != nil`)
- [ ] `for` loops (Go's only loop — used as while, for, range)
- [ ] `switch` statements (no fallthrough by default)
- [ ] `defer` — how it stacks and when it executes
- [ ] `break`, `continue`, labeled loops

#### 1.3 Functions

- [ ] Multiple return values
- [ ] Named return values
- [ ] Variadic functions (`...args`)
- [ ] First-class functions (functions as values)
- [ ] Closures
- [ ] Recursion

#### 1.4 Data Structures

- [ ] Arrays (fixed size) vs Slices (dynamic)
- [ ] Slice internals: length, capacity, `append`, `copy`
- [ ] Maps: creation, CRUD, zero value, comma-ok idiom
- [ ] Structs: definition, initialization, embedding
- [ ] Pointers: `*`, `&`, nil pointers, pointer receivers

#### 1.5 Methods & Interfaces

- [ ] Value receivers vs pointer receivers (when to use which)
- [ ] Interfaces: defining, satisfying implicitly
- [ ] The empty interface `interface{}` / `any`
- [ ] Type assertions and type switches
- [ ] Common interfaces: `fmt.Stringer`, `io.Reader`, `io.Writer`, `error`

#### 1.6 Error Handling (Critical — Go's Philosophy)

- [ ] `error` type and `errors.New`
- [ ] `fmt.Errorf` with `%w` for wrapping
- [ ] `errors.Is` and `errors.As` for unwrapping
- [ ] Custom error types
- [ ] When to use `panic` and `recover` (rarely)
- [ ] The "errors as values" philosophy

#### 1.7 Packages & Modules

- [ ] Go modules: `go mod init`, `go.mod`, `go.sum`
- [ ] `go get`, `go tidy`
- [ ] Package visibility: exported (Capital) vs unexported (lowercase)
- [ ] Internal packages
- [ ] `init()` function

**Key Exercise:** Rewrite a simple Python/JS utility you've written before — a CLI tool, a calculator, a text parser — entirely in Go from scratch.

---

### 🟡 Phase 2 — Concurrency (Weeks 5–7)

**Goal:** Understand Go's concurrency model deeply. This is where Go shines and where most interviewers probe.

> 💡 Go's concurrency motto: _"Do not communicate by sharing memory; instead, share memory by communicating."_

#### 2.1 Goroutines

- [ ] Launching goroutines with `go`
- [ ] Goroutines are not OS threads — they are multiplexed by the Go scheduler
- [ ] The `GOMAXPROCS` setting
- [ ] Why goroutines are cheap (2KB initial stack vs 1–2MB for threads)

#### 2.2 Channels

- [ ] Unbuffered channels (synchronous)
- [ ] Buffered channels (async up to capacity)
- [ ] Directional channels (`chan<-`, `<-chan`)
- [ ] Closing channels and ranging over them
- [ ] `select` statement for multiplexing channels

#### 2.3 Sync Package

- [ ] `sync.WaitGroup` — wait for a group of goroutines
- [ ] `sync.Mutex` and `sync.RWMutex` — mutual exclusion
- [ ] `sync.Once` — run something exactly once (e.g., lazy initialization)
- [ ] `sync.Map` — concurrent-safe map
- [ ] `sync.Pool` — object reuse to reduce GC pressure

#### 2.4 Context Package

- [ ] `context.Background()` and `context.TODO()`
- [ ] `context.WithCancel` — cancellation propagation
- [ ] `context.WithTimeout` and `context.WithDeadline`
- [ ] `context.WithValue` — passing request-scoped data
- [ ] Propagating context through the call stack (standard practice)

#### 2.5 Common Concurrency Patterns

- [ ] Worker pools (fan-out)
- [ ] Pipeline pattern (chain of goroutines)
- [ ] Fan-in (merge multiple channels)
- [ ] Semaphore pattern (limit concurrency)
- [ ] `errgroup` from `golang.org/x/sync` — concurrent tasks with error handling

#### 2.6 Race Conditions & The Race Detector

- [ ] What a data race is (two goroutines accessing same memory, one writes)
- [ ] Running `go test -race` and `go run -race`
- [ ] `go vet` for static analysis

**Key Exercise:** Build a concurrent web scraper that fetches 50 URLs simultaneously, limits concurrency to 10 workers, and times out each request at 3 seconds.

---

### 🟠 Phase 3 — HTTP Servers & REST APIs (Weeks 8–11)

**Goal:** Build production-quality REST APIs. This is the bread and butter of backend Go work.

#### 3.1 net/http Standard Library

- [ ] `http.ListenAndServe`
- [ ] `http.Handler` interface and `http.HandlerFunc`
- [ ] `http.ServeMux` for routing
- [ ] Request: reading headers, body, query params, path params
- [ ] Response: status codes, headers, JSON/text body
- [ ] Middleware pattern (chaining handlers)
- [ ] Serving static files

#### 3.2 JSON Handling

- [ ] `encoding/json`: `Marshal`, `Unmarshal`
- [ ] Struct tags: `json:"name"`, `json:"name,omitempty"`, `json:"-"`
- [ ] `json.Decoder` for streaming (don't use `ioutil.ReadAll` on large bodies)
- [ ] Custom `MarshalJSON` / `UnmarshalJSON` for special types
- [ ] Handling `null` vs missing fields

#### 3.3 Popular HTTP Routers

> The standard library is powerful but lacks path parameters. These solve that:

- [ ] **Chi** (`go-chi/chi`) — lightweight, idiomatic, standard-library compatible
- [ ] **Gin** — high performance, batteries included, very popular
- [ ] **Echo** — similar to Gin, clean API
- [ ] **Fiber** — Express-like API, built on fasthttp (not net/http compatible)

> **Recommendation for learners:** Start with `net/http` + `chi`. Once comfortable, learn Gin as it dominates job listings.

#### 3.4 REST API Best Practices in Go

- [ ] Resource-oriented URL design
- [ ] Proper HTTP status codes (201, 400, 404, 409, 422, 500)
- [ ] Request validation (manually or with `go-playground/validator`)
- [ ] Response envelope pattern (`{"data": ..., "error": ...}`)
- [ ] Pagination (cursor-based vs offset)
- [ ] Versioning (`/v1/users`)

#### 3.5 Middleware

- [ ] Logging middleware (request ID, latency, status)
- [ ] Authentication middleware (JWT verification)
- [ ] CORS middleware
- [ ] Rate limiting middleware
- [ ] Panic recovery middleware

#### 3.6 Configuration Management

- [ ] Environment variables with `os.Getenv`
- [ ] `godotenv` for `.env` files
- [ ] `viper` for structured config (YAML/TOML/ENV)
- [ ] Config structs with validation at startup

**Key Exercise:** Build a RESTful Todo API with full CRUD, request validation, structured logging, and a custom error response format.

---

### 🔵 Phase 4 — Databases (Weeks 12–15)

**Goal:** Connect your Go services to real databases with proper patterns.

#### 4.1 PostgreSQL with `database/sql`

- [ ] `sql.Open`, `sql.DB` connection pool
- [ ] Connection pool settings: `MaxOpenConns`, `MaxIdleConns`, `ConnMaxLifetime`
- [ ] `QueryRow`, `Query`, `Exec`
- [ ] Scanning results into structs
- [ ] Prepared statements
- [ ] Transactions: `Begin`, `Commit`, `Rollback`, defer pattern

#### 4.2 SQL Drivers & Query Builders

- [ ] `lib/pq` (pure Go PostgreSQL driver)
- [ ] `jackc/pgx` (faster, feature-rich — preferred for new projects)
- [ ] `jmoiron/sqlx` — extends `database/sql` with struct scanning
- [ ] `squirrel` — SQL query builder (not ORM)

#### 4.3 ORM: GORM

- [ ] Models, AutoMigrate
- [ ] CRUD: `Create`, `First`, `Find`, `Save`, `Delete`
- [ ] Associations: `HasMany`, `BelongsTo`, `ManyToMany`
- [ ] Preloading related records
- [ ] Hooks: `BeforeCreate`, `AfterUpdate`
- [ ] Scopes for reusable query conditions
- [ ] Raw SQL when needed: `db.Raw`, `db.Exec`
- [ ] When NOT to use ORM (complex aggregations, reporting queries)

#### 4.4 Database Migrations

- [ ] `golang-migrate/migrate` — up/down migration files
- [ ] `pressly/goose` — alternative with Go-based migrations
- [ ] Migration strategy: never edit existing migrations, always add new ones
- [ ] Running migrations at startup vs as a separate step

#### 4.5 Redis

- [ ] `go-redis/redis` client
- [ ] String, Hash, List, Set, Sorted Set operations
- [ ] Key expiration (TTL)
- [ ] Caching pattern: cache-aside
- [ ] Distributed locks with SETNX
- [ ] Pub/Sub

#### 4.6 MongoDB (Optional but Useful)

- [ ] Official `mongo-driver`
- [ ] BSON documents
- [ ] CRUD with filters
- [ ] Aggregation pipelines

**Key Exercise:** Build a URL shortener with PostgreSQL (storing URLs + analytics), Redis (caching hot redirects), and database migrations.

---

### 🟣 Phase 5 — Authentication & Security (Weeks 16–17)

#### 5.1 JWT Authentication

- [ ] JWT structure: header, payload, signature
- [ ] `golang-jwt/jwt` library
- [ ] Generating tokens (access + refresh)
- [ ] Verifying tokens in middleware
- [ ] Token expiration and refresh flows
- [ ] Storing refresh tokens securely (database, not just cookie)

#### 5.2 Password Handling

- [ ] Never store plain text or MD5/SHA passwords
- [ ] `bcrypt` via `golang.org/x/crypto/bcrypt`
- [ ] Cost factor tuning
- [ ] Argon2 as a stronger alternative

#### 5.3 OAuth 2.0 / OIDC

- [ ] OAuth flow types (Authorization Code, Client Credentials)
- [ ] Using `golang.org/x/oauth2`
- [ ] "Login with Google/GitHub" integration

#### 5.4 Security Best Practices

- [ ] SQL injection prevention (parameterized queries, never string concat)
- [ ] XSS prevention (sanitize HTML output)
- [ ] CORS configuration
- [ ] Rate limiting (token bucket / leaky bucket)
- [ ] Secrets management: never hardcode, use env or Vault
- [ ] HTTPS/TLS: `tls.Config`, Let's Encrypt via `acme/autocert`
- [ ] Helmet-style security headers

---

### 🔴 Phase 6 — Testing (Weeks 18–19)

**Goal:** Write tests that give you confidence in your code.

#### 6.1 Standard Library Testing

- [ ] `testing.T`, `t.Run`, `t.Error`, `t.Fatal`, `t.Log`
- [ ] Table-driven tests (idiomatic Go)
- [ ] `testing.B` for benchmarks
- [ ] `go test ./...`, `-v`, `-run`, `-bench`, `-cover`
- [ ] `testify/assert` and `testify/require` for better assertions

#### 6.2 HTTP Handler Testing

- [ ] `net/http/httptest`: `NewRecorder`, `NewRequest`
- [ ] Testing middleware
- [ ] Testing with real router

#### 6.3 Database Testing

- [ ] Test databases: Docker-based ephemeral DBs
- [ ] `testcontainers-go` — spin up real PostgreSQL/Redis in tests
- [ ] Database cleanup between tests
- [ ] Fixtures and seeds

#### 6.4 Mocking

- [ ] Interface-based mocking (define interfaces, swap implementations)
- [ ] `mockery` — auto-generate mocks from interfaces
- [ ] `gomock` — Google's mocking framework

#### 6.5 Integration & End-to-End Tests

- [ ] Testing full HTTP → handler → DB flow
- [ ] Test coverage reporting with `go tool cover`
- [ ] CI integration (GitHub Actions)

---

### ⚫ Phase 7 — gRPC & Protocol Buffers (Weeks 20–22)

**Goal:** gRPC is the dominant inter-service communication protocol in Go microservices.

#### 7.1 Protocol Buffers

- [ ] Installing `protoc` and `protoc-gen-go`
- [ ] `.proto` file syntax: messages, fields, types
- [ ] Scalar types, enums, nested messages, repeated fields
- [ ] `Any`, `oneof`, `map` types
- [ ] Generating Go code: `protoc --go_out --go-grpc_out`

#### 7.2 gRPC Basics

- [ ] Four service types: Unary, Server Streaming, Client Streaming, Bidirectional Streaming
- [ ] Implementing a gRPC server in Go
- [ ] Implementing a gRPC client
- [ ] gRPC status codes and error handling
- [ ] Deadlines and cancellation (always pass context)

#### 7.3 gRPC in Production

- [ ] Interceptors (gRPC's middleware): UnaryInterceptor, StreamInterceptor
- [ ] Authentication via metadata (headers)
- [ ] TLS for gRPC
- [ ] Reflection (for tools like `grpcurl`)
- [ ] gRPC-Gateway: expose gRPC as REST simultaneously

#### 7.4 Tools

- [ ] `grpcurl` — curl for gRPC
- [ ] `evans` — interactive gRPC client
- [ ] Buf — modern protobuf toolchain (recommended over raw protoc)

---

### 🌐 Phase 8 — Microservices Patterns (Weeks 23–26)

#### 8.1 Service Communication

- [ ] Synchronous: REST + gRPC
- [ ] Asynchronous: Message queues (Kafka, RabbitMQ, NATS)
- [ ] Event-driven architecture
- [ ] Request/reply vs fire-and-forget

#### 8.2 Message Queues

- [ ] **Kafka** with `segmentio/kafka-go` or `confluentinc/confluent-kafka-go`
    - Topics, partitions, consumer groups
    - Producer with acknowledgments
    - Consumer with offset management
- [ ] **NATS** with `nats-go` (simpler, lighter than Kafka)
- [ ] **RabbitMQ** with `amqp091-go`

#### 8.3 Resilience Patterns

- [ ] Circuit breaker: `sony/gobreaker`
- [ ] Retry with exponential backoff: `avast/retry-go`
- [ ] Timeout propagation via context
- [ ] Bulkhead pattern (limit concurrent calls to a dependency)
- [ ] Health checks: `/healthz`, `/readyz` endpoints

#### 8.4 Service Discovery & Configuration

- [ ] Consul for service discovery
- [ ] etcd for distributed configuration
- [ ] Kubernetes DNS-based discovery (most common in practice)

#### 8.5 API Gateway Patterns

- [ ] Authentication at the gateway
- [ ] Rate limiting
- [ ] Request transformation
- [ ] gRPC transcoding to REST

---

### 🐳 Phase 9 — Deployment & DevOps (Weeks 27–30)

#### 9.1 Docker

- [ ] Writing an efficient Go `Dockerfile`
- [ ] Multi-stage builds (build stage + minimal runtime stage)
- [ ] Distroless / Alpine base images for tiny containers
- [ ] Docker Compose for local dev (app + PostgreSQL + Redis)
- [ ] `.dockerignore`

```dockerfile
# Example multi-stage Go Dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o server ./cmd/server

FROM gcr.io/distroless/static-debian11
COPY --from=builder /app/server /server
EXPOSE 8080
ENTRYPOINT ["/server"]
```

#### 9.2 Kubernetes Basics

- [ ] Pods, Deployments, Services, Ingress
- [ ] ConfigMaps and Secrets
- [ ] Horizontal Pod Autoscaler
- [ ] Rolling updates and rollbacks
- [ ] Readiness and liveness probes
- [ ] Resource requests and limits

#### 9.3 Observability (Critical for Production)

- [ ] **Structured Logging**: `uber-go/zap` or `rs/zerolog` (JSON logs, log levels, context fields)
- [ ] **Metrics**: Prometheus with `prometheus/client_golang`, expose `/metrics`
    - Counter, Gauge, Histogram, Summary
    - Custom business metrics
- [ ] **Tracing**: OpenTelemetry with `go.opentelemetry.io/otel`
    - Distributed traces across services
    - Jaeger or Tempo as trace backend
- [ ] **Dashboards**: Grafana connected to Prometheus

#### 9.4 CI/CD

- [ ] GitHub Actions: lint → test → build → push Docker image → deploy
- [ ] `golangci-lint` for comprehensive linting
- [ ] Automated vulnerability scanning
- [ ] Semantic versioning and tagging

---

### 🏗️ Phase 10 — Advanced Go & Performance (Weeks 31–36)

#### 10.1 Go Runtime Internals

- [ ] Garbage collector: tri-color mark-and-sweep, GC pauses
- [ ] Memory allocation: stack vs heap, escape analysis (`go build -gcflags="-m"`)
- [ ] Goroutine scheduler: M:N threading model, work-stealing
- [ ] `GODEBUG` for runtime diagnostics

#### 10.2 Profiling & Performance

- [ ] `pprof`: CPU profile, memory profile, goroutine dump, block profile
- [ ] `go tool pprof` interactive analysis
- [ ] `go tool trace` for execution traces
- [ ] Benchmark writing and comparison with `benchstat`
- [ ] `sync.Pool` for allocation reduction
- [ ] Avoiding common performance pitfalls (string concatenation in loops, interface boxing)

#### 10.3 Generics (Go 1.18+)

- [ ] Type parameters syntax
- [ ] Type constraints and `comparable`
- [ ] Generic data structures (stacks, queues, sets)
- [ ] When generics help vs when they add complexity
- [ ] `golang.org/x/exp/slices` and `maps` packages

#### 10.4 Advanced Patterns

- [ ] Functional options pattern (for flexible struct constructors)
- [ ] Repository pattern (clean separation of data access)
- [ ] Dependency injection (manual vs `google/wire`)
- [ ] Clean Architecture / Hexagonal Architecture in Go
- [ ] Event sourcing basics

#### 10.5 Code Generation

- [ ] `go generate`
- [ ] `stringer` for enum string methods
- [ ] `mockery` for mocks
- [ ] `oapi-codegen` for OpenAPI → Go server stubs

---

## Incremental Projects

Build these in order. Each one extends the previous.

### Project 1 — CLI Task Manager (Phase 1 completion)

**What you'll use:** Core syntax, structs, file I/O, JSON, `os`, `flag`/`cobra`

- Add, list, complete, delete tasks stored in a JSON file
- Filtering by status, due date
- Pretty terminal output with colors (`fatih/color`)
- **Stretch:** SQLite storage using `mattn/go-sqlite3`

---

### Project 2 — REST API: Blog Backend (Phase 3 + 4 completion)

**What you'll use:** Gin or Chi, PostgreSQL, GORM or sqlx, JWT auth, migrations

- Users (register/login with JWT)
- Posts (create, read, update, delete) — only author can modify
- Comments on posts
- Pagination, search
- Request validation
- **Stretch:** Image upload to S3/MinIO

---

### Project 3 — Real-Time Chat Server (Phase 2 + 3 completion)

**What you'll use:** WebSockets (`gorilla/websocket`), goroutines, channels, Redis Pub/Sub

- Multiple chat rooms
- Broadcast messages to all room members
- User presence (online/offline)
- Message history stored in PostgreSQL
- Redis Pub/Sub for scaling across multiple server instances
- **Stretch:** Typing indicators, read receipts

---

### Project 4 — URL Shortener with Analytics (Phase 4 + 5 completion)

**What you'll use:** PostgreSQL, Redis, background workers, goroutines

- Shorten URLs with custom aliases
- Redirect with 301/302
- Analytics: click counts, unique visitors, referrer, geo (using MaxMind GeoIP)
- Redis caching for hot URLs (avoid DB hit on every redirect)
- Background worker to aggregate analytics asynchronously
- **Stretch:** Rate limiting per IP, QR code generation

---

### Project 5 — E-commerce Order Service (Phase 5 + 6 + 7 completion)

**What you'll use:** gRPC, PostgreSQL transactions, Kafka, distributed patterns

- Product catalog service (gRPC)
- Order service (REST + gRPC internally)
- Inventory service — checks and reserves stock
- Event: `OrderPlaced` published to Kafka
- Payment service subscribes to Kafka and processes payment
- Saga pattern for distributed transactions (compensating transactions on failure)
- Full test suite with testcontainers
- **Stretch:** gRPC-Gateway to expose as REST

---

### Project 6 — Production-Grade API Platform (Phase 8 + 9 completion)

**What you'll use:** Docker, Kubernetes, Prometheus, Grafana, structured logging, CI/CD

- Take Project 2 or 5 and make it production-ready
- Dockerfile with multi-stage build
- Docker Compose for local dev with hot reload (`air`)
- Kubernetes manifests: Deployment, Service, Ingress, HPA
- Prometheus metrics on all endpoints (latency histogram, request counter)
- Grafana dashboard
- Structured JSON logging with request ID tracing
- GitHub Actions: test → lint → build → push → deploy
- Health check endpoints
- **Stretch:** OpenTelemetry distributed tracing with Jaeger

---

### Project 7 — Distributed Key-Value Store (Phase 10 — Advanced)

**What you'll use:** Raft consensus, networking, advanced Go runtime knowledge

- Implement a simple distributed in-memory KV store
- Raft consensus for leader election and log replication (use `hashicorp/raft`)
- HTTP API: GET, SET, DELETE
- Multi-node cluster that tolerates node failures
- Snapshotting for log compaction
- This is a system design interview dream project

---

## Resources

### Official & Core

|Resource|Type|Notes|
|---|---|---|
|[tour.golang.org](https://tour.golang.org/)|Interactive|Best starting point, covers all basics|
|[go.dev/doc/effective_go](https://go.dev/doc/effective_go)|Official doc|How to write idiomatic Go|
|[pkg.go.dev](https://pkg.go.dev/)|Reference|Official package documentation|
|[Go Specification](https://go.dev/ref/spec)|Reference|The full language spec — surprisingly readable|

### Books

|Book|Level|Notes|
|---|---|---|
|**The Go Programming Language** — Donovan & Kernighan|Beginner–Intermediate|The definitive Go book. Read carefully.|
|**Concurrency in Go** — Katherine Cox-Buday|Intermediate|The best resource on goroutines, channels, and patterns|
|**100 Go Mistakes and How to Avoid Them** — Teiva Harsanyi|Intermediate–Advanced|Essential for writing production-grade Go|
|**Let's Go** — Alex Edwards|Intermediate|Best book for learning web apps with Go, practical|
|**Let's Go Further** — Alex Edwards|Intermediate|REST APIs, JWT, PostgreSQL — highly recommended|
|**Cloud Native Go** — Matthew Titmus|Advanced|Building distributed systems in Go|

### Video Courses

|Course|Platform|Level|
|---|---|---|
|Go: The Complete Developer's Guide|Udemy (Stephen Grider)|Beginner|
|Backend Master Class (Go + Postgres + Kubernetes)|YouTube (TECH SCHOOL)|Intermediate|
|gRPC in Go|YouTube (TECH SCHOOL)|Intermediate|
|Ardan Labs — Ultimate Go|Ardan Labs|Advanced|
|Boot.dev Go courses|boot.dev|Beginner–Intermediate|

### YouTube Channels & Playlists

- **TECH SCHOOL** — Excellent series on Go + PostgreSQL + gRPC + Kubernetes (`youtube.com/@TECHSCHOOLGURU`)
- **Dreams of Code** — Real-world Go projects
- **Anthony GG** — Go projects with good depth
- **TutorialEdge** — Concurrency tutorials
- **Go Time Podcast** — Community podcast, great for keeping up

### GitHub Repositories to Study

|Repo|What to Learn|
|---|---|
|`moby/moby` (Docker)|Large-scale Go project structure|
|`kubernetes/kubernetes`|Distributed systems patterns|
|`hashicorp/vault`|Security, plugin architecture|
|`gin-gonic/gin`|HTTP framework internals|
|`go-chi/chi`|Idiomatic middleware chaining|
|`go-playground/validator`|Reflection-based validation|

### Practice

- **LeetCode** — Solve problems in Go (strengthens syntax muscle memory)
- **Exercism.io** — Go track, community mentorship
- **gophercises.com** — Real projects with video walkthroughs
- **gobyexample.com** — Quick reference with runnable examples

---

## Interview & Job Readiness

### What Interviewers Test

1. **Concurrency** — Goroutine lifecycle, channel directions, select, deadlock avoidance, data races
2. **Error handling** — Wrapping, unwrapping, custom types
3. **Interface design** — How to write testable, decoupled code
4. **Memory model** — When does Go allocate on heap vs stack? What causes GC pressure?
5. **System design** — How would you build X with Go? (rate limiter, task queue, distributed cache)
6. **Testing** — Writing table-driven tests, mocking interfaces, benchmarking

### Common Interview Questions in Go

- What is the difference between a goroutine and a thread?
- When would you use a buffered vs unbuffered channel?
- What is the `select` statement and when do you use it?
- What happens if you close a channel that has no receivers?
- How do you prevent data races without using a mutex? (channels)
- Explain the `defer` evaluation order with multiple defers in a function
- What is an interface in Go? How is it different from Java/C#?
- How does Go handle nil interfaces? What is the nil interface trap?
- What is escape analysis? How can you check if a variable escapes to the heap?
- How would you implement a worker pool in Go?

### Portfolio Checklist

Before applying for Go backend roles, ensure you have:

- [ ] 2–3 projects on GitHub with clean READMEs
- [ ] At least one project using PostgreSQL with proper migrations
- [ ] At least one project with real authentication (JWT)
- [ ] At least one project with tests (aim for >70% coverage)
- [ ] A Dockerized project with docker-compose
- [ ] A project using goroutines/channels meaningfully
- [ ] Deployed something (Railway, Fly.io, Render, or AWS/GCP free tier)

---

## Go Ecosystem Quick Reference

```
HTTP Routing:        chi, gin, echo, fiber
ORM:                 gorm, ent
SQL:                 sqlx, pgx, squirrel
Migrations:          golang-migrate, goose
Redis:               go-redis
Kafka:               kafka-go, confluent-kafka-go
gRPC:                google.golang.org/grpc + buf
Config:              viper, envconfig
Logging:             zap, zerolog, slog (stdlib, Go 1.21+)
Metrics:             prometheus/client_golang
Tracing:             go.opentelemetry.io/otel
JWT:                 golang-jwt/jwt
Auth:                golang.org/x/oauth2
Validation:          go-playground/validator
Testing:             testify, mockery, testcontainers-go
DI:                  google/wire, uber-go/fx
CLI:                 cobra, urfave/cli
HTTP Client:         resty, retryablehttp
Scheduler:           robfig/cron
Background Jobs:     riverqueue/river, hibiken/asynq
Build:               goreleaser
Dev tools:           air (hot reload), golangci-lint
```

---

## Go Proverbs (Keep These in Mind Always)

> _"Don't communicate by sharing memory, share memory by communicating."_ _"Concurrency is not parallelism."_ _"Clear is better than clever."_ _"A little copying is better than a little dependency."_ _"The bigger the interface, the weaker the abstraction."_ _"Make the zero value useful."_ _"Errors are values."_ _"Don't just check errors, handle them gracefully."_

— Rob Pike, Go Co-creator

---

_Last updated: 2026 | Covers Go 1.21+_