	# HTTP/HTTPS Deep-Dive for Java Backend Engineers

## Table of Contents
1. [Why This Matters](#why-this-matters)
2. [HTTP Request-Response Cycle](#http-request-response-cycle)
3. [HTTPS Under The Hood](#https-under-the-hood)
4. [Status Codes – The Full Spectrum](#status-codes)
5. [Headers – The Control Plane of HTTP](#headers)
6. [Java Backend Implementation Patterns](#java-backend)
7. [Common Pitfalls and Pro Tips](#pitfalls)
8. [HTTP/2 and HTTP/3 — What Changed](#http2-http3)

---

## 1. Why This Matters 
As a backend engineer, **every API you build speaks HTTP**. Knowing the protocol deeply lets you:
- Choose the right status code to make your API intuitive.
- Control caching, security, and content negotiation via headers.
- Debug production issues (e.g., 502/504, redirect loops, CORS errors).
- Use HTTP/2 multiplexing features transparently.
- Build resilient clients and servers.

---

## 2. HTTP Request-Response Cycle

### 2.1 Classic HTTP/1.1 over TCP
1. **DNS Resolution** – hostname → IP address.
2. **TCP 3-Way Handshake** – SYN, SYN-ACK, ACK. Establishes a byte-stream socket.
3. **TLS Handshake** (for HTTPS) – More on this later.
4. **HTTP Request** – Client sends request.
5. **Server Processing** – Application logic.
6. **HTTP Response** – Server sends back status line, headers, optional body.
7. **Connection Reuse or Closure** – HTTP/1.1 keeps connection alive by default (`Connection: keep-alive`), allowing multiple requests over the same TCP stream (pipelining, though rarely used).

**Request Format (text):**
```http
POST /api/users HTTP/1.1
Host: example.com
Content-Type: application/json
Content-Length: 45
Accept: application/json

{"name": "Alice", "email": "alice@example.com"}
```

**Response Format (text):**
```http
HTTP/1.1 201 Created
Content-Type: application/json
Location: /api/users/42
Content-Length: 0
```

### 2.2 Connection Lifecycle and Keep-Alive
- `Connection: keep-alive` (HTTP/1.1 default) allows multiple requests sequentially on one TCP connection.
- `Connection: close` tells the server to close after the response.
- Java HTTP clients (HttpURLConnection, HttpClient) need proper resource closing; otherwise you can exhaust file descriptors. **Always close `InputStream`/`Response`** or use try-with-resources.

### 2.3 HTTP/2 Multiplexing
- Binary framing layer, streams are multiplexed over single connection.
- Head-of-line blocking at HTTP level solved, but TCP-level HO blocking remains (solved in HTTP/3).
- Server Push (deprecated in practice), header compression (HPACK).
- Java HttpClient (since 11) supports HTTP/2 transparently.

---

## 3. HTTPS Under The Hood

HTTPS = HTTP over TLS. TLS provides encryption, integrity, and authentication.

### 3.1 TLS Handshake (simplified)
1. **ClientHello**: Supported TLS versions, cipher suites, SNI (Server Name Indication).
2. **ServerHello**: Chosen cipher, server certificate (contains public key).
3. **Key Exchange** (e.g., ECDHE): Both sides agree on a session key.
4. **Finished**: Encrypted handshake completion.
5. All subsequent data is encrypted with symmetric ciphers (AES-GCM).

**Why Java Backend Engineers Care:**
- **Termination**: Often a reverse proxy (Nginx, Load Balancer) terminates TLS. Your Java app receives plain HTTP. In cloud-native setups, you may have end-to-end TLS.
- **Certificates**: Server certs and trust material go into `keystore.jks` / `truststore.jks`. Spring Boot:
  ```properties
  server.ssl.key-store=classpath:keystore.p12
  server.ssl.key-store-password=secret
  ```
- **Client Certificates (mTLS)**: Extract client certificate details from `HttpServletRequest`:
  ```java
  X509Certificate[] certs = (X509Certificate[]) request.getAttribute("javax.servlet.request.X509Certificate");
  ```
- **SNI**: Allows multiple virtual hosts on one IP. Your web server (Tomcat, Netty) handles this automatically.

---

## 4. Status Codes – The Full Spectrum

### 4.1 Categories
- **1xx Informational**: Interim responses (rarely used directly by app).
- **2xx Success**:
  - `200 OK` – Standard success.
  - `201 Created` – Resource created. **Always include a `Location` header** with URL of the new resource.
  - `204 No Content` – Success with no body (e.g., after DELETE or a PATCH where you don't return anything).
  - `206 Partial Content` – Used for range requests (e.g., video streaming, file resumable downloads).
- **3xx Redirection**:
  - `301 Moved Permanently` – GET/HEAD can follow automatically; POST may change to GET (dangerous!). Cacheable permanently.
  - `302 Found` – Temporary redirect. Method **may** change from POST to GET (legacy). Often misused.
  - `307 Temporary Redirect` – Preserves HTTP method (POST stays POST).
  - `308 Permanent Redirect` – Permanent and preserves method.
  - `304 Not Modified` – Caching: tell the client to use its local copy. Must include `ETag` or `Last-Modified`.
- **4xx Client Errors**:
  - `400 Bad Request` – Malformed syntax; use when request body is invalid JSON or missing required fields (but see 422).
  - `401 Unauthorized` – **Missing or invalid authentication credentials**. Must include `WWW-Authenticate` header with challenge (e.g., `Bearer realm="..."`).
  - `403 Forbidden` – Authenticated, but not allowed. Server understood the identity but refuses access. Do not re-send authentication.
  - `404 Not Found` – Resource doesn't exist, or hidden for security reasons.
  - `405 Method Not Allowed` – Wrong HTTP verb. Response must include `Allow` header.
  - `409 Conflict` – Request conflicts with current state (e.g., duplicate resource, version mismatch for optimistic locking).
  - `422 Unprocessable Entity` – Semantic error (used by WebDAV, now popular in REST APIs): syntactically correct but semantically invalid (e.g., validation: age must be positive). Prefer over 400 for validation errors.
  - `429 Too Many Requests` – Rate limiting. Include `Retry-After` header (seconds or HTTP-date).
  - `451 Unavailable For Legal Reasons` – Rare; content censored.
- **5xx Server Errors**:
  - `500 Internal Server Error` – Unhandled exception, coding error. **Never expose stack traces in production.**
  - `502 Bad Gateway` – Your server acting as gateway/proxy got invalid response from upstream.
  - `503 Service Unavailable` – Server temporarily overloaded/down for maintenance. Use `Retry-After`.
  - `504 Gateway Timeout` – Upstream server did not respond in time.

### 4.2 Best Practices
- **Don’t return 200 with an error body** – It breaks HTTP retry logic and standard client interpretation.
- **Use 201 with Location** for POST creation.
- **Use 204 for no-content success** instead of 200 with empty body.
- **401 vs 403**: 401 for “I don’t know you”, 403 for “I know you, but you can’t”.
- For redirect, prefer 307/308 unless you want method change for legacy.
- Provide a consistent error body (`{"error": "...", "message": "..."}`) so clients can parse.

---

## 5. Headers – The Control Plane of HTTP

### 5.1 General / Entity Headers
- `Content-Type`: Media type of body (`application/json`, `application/x-www-form-urlencoded`, `multipart/form-data`). **Crucial for server to parse.**
- `Content-Length`: Byte length. If missing, chunked transfer encoding may be used.
- `Transfer-Encoding: chunked` – For streaming responses.
- `Cache-Control`: Directs caching behavior. `no-cache` (revalidate), `no-store` (never cache), `max-age=3600` (cache for 1 hour), `private`/`public`.
- `ETag` / `If-None-Match`: Conditional requests for caching.
- `Last-Modified` / `If-Modified-Since`: Time-based caching.

### 5.2 Request Headers
- `Host` – mandatory in HTTP/1.1; used for virtual hosting.
- `Authorization` – e.g., `Bearer <token>` or `Basic base64`.
- `Cookie` – client sends stored cookies.
- `Accept` / `Accept-Encoding` / `Accept-Language` – content negotiation.
- `User-Agent` – identifies client; often parsed for analytics.
- `Origin` / `Referer` – for CORS and tracking.
- `X-Forwarded-For`, `X-Forwarded-Proto` – added by proxies to pass original client IP and scheme.

### 5.3 Response Headers
- `Set-Cookie` – server sets a cookie (HttpOnly, Secure, SameSite flags).
- `Location` – used with 201/3xx.
- `WWW-Authenticate` – required with 401 to indicate auth scheme.
- `Server` – software identification. **Remove or obscure in production** (`server.server-header=Spring` in Spring Boot to customize).
- `Access-Control-Allow-Origin` – CORS; never use `*` with credentials.
- Security headers:
  - `Strict-Transport-Security` (HSTS) – force HTTPS.
  - `X-Content-Type-Options: nosniff` – prevent MIME sniffing.
  - `X-Frame-Options: DENY` – prevent clickjacking.
  - `Content-Security-Policy` – fine-grained control over resources.
  - `X-XSS-Protection: 0` (old, sometimes removed; CSP is modern).

### 5.4 Headers and Caching Flow
1. Response includes `ETag` or `Last-Modified`.
2. Client stores response along with these values.
3. Subsequent request includes `If-None-Match` (ETag) or `If-Modified-Since`.
4. If unchanged, server replies `304 Not Modified` with no body. **Backend must support this** for performance.

---

## 6. Java Backend Implementation Patterns

### 6.1 Servlet API Basics
```java
@WebServlet("/api/example")
public class ExampleServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        String contentType = req.getHeader("Content-Type");
        String body = req.getReader().lines().collect(Collectors.joining());

        // ... business logic

        resp.setStatus(HttpServletResponse.SC_CREATED); // 201
        resp.setHeader("Location", "/api/example/123");
        resp.setContentType("application/json");
        // No body
    }
}
```

### 6.2 Spring MVC / Boot – Modern Approach
**Returning ResponseEntity**
```java
@PostMapping("/users")
public ResponseEntity<Void> createUser(@RequestBody @Valid UserDto user) {
    Long id = userService.create(user);
    URI location = ServletUriComponentsBuilder
                        .fromCurrentRequest()
                        .path("/{id}")
                        .buildAndExpand(id)
                        .toUri();
    return ResponseEntity.created(location).build(); // 201 + Location
}
```

**Custom Exception Handling**
```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ResourceNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(new ErrorResponse("Resource not found", ex.getMessage()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        String details = ex.getBindingResult().getFieldErrors().stream()
                .map(e -> e.getField() + ": " + e.getDefaultMessage())
                .collect(Collectors.joining(", "));
        return ResponseEntity.unprocessableEntity() // 422
                .body(new ErrorResponse("Validation failed", details));
    }
}
```

### 6.3 Setting Security Headers
In Spring Security or a filter:
```java
response.setHeader("X-Content-Type-Options", "nosniff");
response.setHeader("X-Frame-Options", "DENY");
response.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
```

### 6.4 Handling CORS
```java
@CrossOrigin(origins = "https://frontend.example.com", maxAge = 3600)
@RestController
public class MyController { ... }
```
Or globally:
```java
@Bean
public WebMvcConfigurer corsConfigurer() {
    return new WebMvcConfigurer() {
        @Override
        public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/api/**")
                    .allowedOrigins("https://frontend.example.com")
                    .allowedMethods("GET","POST","PUT","DELETE")
                    .allowCredentials(true);
        }
    };
}
```

### 6.5 Content Negotiation
Spring honors `Accept` header automatically.
```java
@GetMapping(value = "/data", produces = { "application/json", "application/xml" })
public Data getData() { ... }
```
You can also implement `WebMvcConfigurer.configureContentNegotiation`.

### 6.6 HTTP Client in Java 11+
```java
HttpClient client = HttpClient.newBuilder()
        .version(HttpClient.Version.HTTP_2)
        .connectTimeout(Duration.ofSeconds(5))
        .build();

HttpRequest request = HttpRequest.newBuilder()
        .uri(URI.create("https://api.example.com/data"))
        .header("Accept", "application/json")
        .GET()
        .build();

HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
if (response.statusCode() == 200) { ... }
```

---

## 7. Common Pitfalls and Pro Tips

- **Forgetting to set `Content-Type` on responses** – Clients may misinterpret the body; browsers may trigger MIME sniffing warnings.
- **Exposing internal errors**: `500` with full stack trace in API response. Use `@ExceptionHandler` to log and return a clean error.
- **Misusing 301 for API redirects**: 301 is permanently cached; once a client sees it, it will never hit the original URL again — you can't undo it.
- **Redirect loops** – Check your logic for infinite redirects (e.g., forcing HTTPS behind a proxy that already terminates TLS but you look at `X-Forwarded-Proto` and decide to redirect again).
- **Cache control**: APIs returning sensitive data must include `Cache-Control: no-store`. Static assets can have long `max-age` with versioned URLs.
- **Ignoring `If-None-Match`**: For high-traffic APIs, implementing ETag can drastically reduce bandwidth.
- **Rate limiting 429**: Always include `Retry-After` and an informative message so clients can backoff properly.
- **Header injection prevention**: Never blindly echo user input into response headers; encode or validate.
- **Connection leaks**: In old `HttpURLConnection`, always disconnect or use try-with-resources; with new HttpClient, the pool is auto-managed.

---

## 8. HTTP/2 and HTTP/3 – What Changed for Backend

### HTTP/2
- **Multiplexing** – One TCP connection per origin, many streams.
- **Header compression** – reduces bandwidth.
- **Server push** – Deprecated; avoid.
- Impact on Java: HttpClient supports it. Tomcat 9+ and Netty support it out of the box (via ALPN and TLS). No application code changes needed, but you gain performance. However, TCP head-of-line blocking still exists.

### HTTP/3 (QUIC)
- Runs over UDP with built-in TLS 1.3.
- Eliminates TCP head-of-line blocking.
- Connection migration (survives network changes).
- Still emerging; Java support growing (e.g., JDK HttpClient in preview). For now, you’ll mostly interact with HTTP/3 via a reverse proxy (Nginx, Cloudflare) that terminates QUIC and talks HTTP/1.1 or HTTP/2 to your backend.

---

## Summary
- Master the **request/response cycle**, **status code semantics**, and **header usage** to build robust RESTful APIs.
- Use proper status codes: `201` with `Location`, `422` for validation errors, `401` vs `403`, `429` with `Retry-After`.
- Headers control caching, CORS, authentication, and security. Always set the essential security headers.
- In Java, `ResponseEntity` gives you full control; `@ExceptionHandler` centralizes error handling.
- Stay aware of HTTP version differences but let your server/client library handle the low-level details while you design APIs that leverage HTTP’s power.