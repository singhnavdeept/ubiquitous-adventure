---
title: "REST API Status Codes: The Protocol of Trust Between Client and Server"
date: "2026-06-23"
excerpt: "Why 200, 400, 401, 404, 422, and 500 are not just numbers—they are a semantic contract, and violating them breaks the web's most widely deployed API architecture."
tags: ["rest-api", "http", "status-codes", "api-design", "backend", "web-development"]
---

# REST API Status Codes: The Protocol of Trust Between Client and Server

I once debugged a payment integration where the third-party API returned `200 OK` for every response—including errors. The response body contained a `status: "error"` field. Their SDK, however, only checked the HTTP status code for failures. It treated every error response as a successful transaction. We caught it during testing. The production incident that would have followed still wakes me up.

Status codes are not decorative. They are the **primary signaling mechanism** of HTTP. A client should be able to inspect the status code and know, without parsing the body, whether the request succeeded, failed due to client error, or failed due to server error. This is the foundation of reliable API integration.

---

## The Status Code Families

HTTP status codes are grouped into five families. The first digit tells you who is responsible for the outcome.

| Family  | Range   | Meaning       | Responsibility                                                                             |
| :------ | :------ | :------------ | :----------------------------------------------------------------------------------------- |
| **1xx** | 100–199 | Informational | Protocol-level; rarely seen in REST APIs                                                   |
| **2xx** | 200–299 | Success       | The request was valid and processed correctly                                              |
| **3xx** | 300–399 | Redirection   | The resource is elsewhereThe request was valid and processed correctly; client must follow |
| **4xx** | 400–499 | Client Error  | The client sent something wrong; fix the request                                           |
| **5xx** | 500–599 | Server Error  | The server failed; client may retry                                                        |

A well-designed REST API uses status codes from the 2xx, 4xx, and 5xx families almost exclusively. If your API returns a 3xx, you are likely doing something unusual. If it returns a 1xx, you are writing raw HTTP, not a REST API.

---

## 200 OK: The Universal Success Signal

### What It Means

The request succeeded. The server understood what the client wanted, processed it, and is returning a representation of the result.

### When to Use It

- **GET:** The resource exists and is returned in the response body.
- **PUT / PATCH:** The resource was updated successfully; the response body contains the updated representation.
- **DELETE:** The resource was deleted; the response body may contain a confirmation or be empty.

### The Subtle Distinction: 200 vs. 204

If a `DELETE` or `PUT` succeeds and there is **no meaningful response body**, use `204 No Content` instead of `200 OK`. This tells the client: "Do not parse the body; there is none." A `200` with an empty body is ambiguous—the client may attempt to parse and encounter an error.

### The Dangerous Anti-Pattern: 200 for Errors

```json
// NEVER DO THIS
HTTP/1.1 200 OK
{
  "success": false,
  "error": "Invalid email format"
}
```

This breaks every HTTP tool in the ecosystem. Load balancers, monitoring systems, CDNs, and client libraries all inspect the status code. A `200` with an error body will be counted as a success in metrics, cached by intermediaries, and ignored by retry logic.

**The rule:** If the request failed, the status code must be 4xx or 5xx. No exceptions.

---

## 400 Bad Request: The Catch-All Client Error

### What It Means

The server cannot process the request because the client sent something malformed. The problem is with the **syntax** of the request, not the semantics.

### When to Use It

- Malformed JSON: missing closing brace, unescaped characters, incorrect content type.
- Missing required headers (e.g., `Content-Type: application/json`).
- Query parameters that fail type validation (e.g., `?age=abc` when an integer is expected).
- Request body that is structurally invalid, not just semantically wrong.

### When NOT to Use It

Do not use 400 for **semantic** validation errors—those are 422. Do not use 400 for authentication failures—those are 401. Do not use 400 when the resource simply does not exist—that is 404.

### Example: Malformed Request

```
POST /users HTTP/1.1
Content-Type: application/json

{"name": "Alice", "email": "alice@example.com",}  ← Trailing comma is invalid JSON
```

Response:
```
HTTP/1.1 400 Bad Request
{
  "error": "Malformed request body",
  "detail": "Unexpected token at line 1, column 52"
}
```

### Engineering Note

A 400 is a **client bug**. It should never occur in production from a properly integrated client. If your server logs show frequent 400s, either your API documentation is wrong, your client SDK has a bug, or someone is probing your endpoints.

---

## 401 Unauthorized: The Authentication Gate

### What It Means

The request lacks valid authentication credentials. The server cannot verify the client's identity.

### The Critical Distinction: 401 vs. 403

This is the most confused pair in HTTP. The distinction is temporal:

| Code | Question It Answers |
| :--- | :--- |
| **401 Unauthorized** | "Do I know who you are?" — No. You are anonymous or your credentials are invalid/expired. |
| **403 Forbidden** | "Do I know who you are?" — Yes. "Are you allowed to do this?" — No. |

A 401 says: "Try again with valid credentials." A 403 says: "Don't bother trying again. Your credentials are fine, but you lack permission."

### When to Use It

- Missing `Authorization` header.
- Expired JWT token.
- Invalid API key.
- Malformed token that cannot be decoded.

### The `WWW-Authenticate` Header

A proper 401 response must include a `WWW-Authenticate` header telling the client *how* to authenticate:

```
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Bearer realm="api", error="invalid_token", error_description="Token has expired"
```

This is not optional. The HTTP specification requires it. Browsers use it to trigger the login dialog. API clients use it to select the correct authentication method. Omit it, and you leave the client guessing.

### Example: Expired Token

```
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Bearer error="invalid_token"
{
  "error": "Authentication required",
  "detail": "Access token expired at 2026-06-23T10:00:00Z"
}
```

---

## 404 Not Found: The Existential Error

### What It Means

The requested resource does not exist. The server has no representation of it, and likely never has.

### When to Use It

- `GET /users/99999` when user 99999 does not exist.
- `DELETE /orders/123` when order 123 does not exist.
- `PUT /products/sku-xyz` when SKU `sku-xyz` is unknown.
- A URL path that maps to no known endpoint (`/userz` instead of `/users`).

### The Security Dimension: 404 vs. 403 for Hidden Resources

If a resource exists but the authenticated user should not know about it—say, another user's private profile—what should you return?

**Option A: 403 Forbidden.** The client learns the resource *exists*. This leaks information.

**Option B: 404 Not Found.** The client learns nothing. The resource might exist, or it might not.

Option B is the secure choice. If a user should not know whether `GET /users/42/private-notes` exists, return 404 regardless of whether it actually exists. This is **information hiding** and prevents enumeration attacks.

### Example

```
GET /products/sku-99999 HTTP/1.1

HTTP/1.1 404 Not Found
{
  "error": "Resource not found",
  "detail": "No product exists with SKU 'sku-99999'"
}
```

---

## 422 Unprocessable Entity: The Validation Failure

### What It Means

The server understands the request (the syntax is correct), and the server understands the content type (JSON is valid), but the **semantics** are wrong. The request body violates business rules.

### 422 vs. 400: The Crucial Distinction

| Code | Problem |
| :--- | :--- |
| **400 Bad Request** | The request is **structurally malformed**. Cannot be parsed. |
| **422 Unprocessable Entity** | The request is **well-formed but semantically invalid**. Parsed successfully; failed business rules. |

A 400 is for missing fields that the schema requires. A 422 is for fields that are present but have invalid values.

### When to Use It

- Email field contains a string that is not a valid email address.
- Password is too short (fails `min_length` validation).
- Creating a user with a username that already exists.
- An order references a product that has been discontinued.

### Example: Validation Failure

```
POST /users HTTP/1.1
Content-Type: application/json

{
  "name": "Alice",
  "email": "not-an-email",
  "password": "ab"
}
```

Response:
```
HTTP/1.1 422 Unprocessable Entity
{
  "error": "Validation failed",
  "fields": {
    "email": ["Must be a valid email address"],
    "password": ["Must be at least 8 characters"]
  }
}
```

### RFC Origin

422 is defined in RFC 4918 (WebDAV), not in the core HTTP specification. It has been widely adopted by REST APIs because the core HTTP spec provides no semantic distinction between "unparseable" and "invalid business logic" in the 4xx range. Rails, Laravel, and many API frameworks now use it as the standard validation failure code.

---

## 500 Internal Server Error: The Server's Confession

### What It Means

Something went wrong on the server, and the server cannot identify a more specific cause. This is the **universal fallback** for unhandled errors.

### When to Use It

- An unhandled exception in application code.
- A database connection failure that is not expected.
- A null pointer dereference, type error, or division by zero.
- Any condition where the server is at fault and the request may succeed if retried later.

### The Golden Rule: Never Leak Internals

A 500 response must **never** include stack traces, SQL queries, file paths, or internal state. This is the most common security vulnerability in production APIs.

```json
// DANGEROUS: Leaks internal implementation
{
  "error": "Internal Server Error",
  "stack": "TypeError: Cannot read property 'id' of null\n    at UserService.getUser (/app/src/services/user.ts:42:15)"
}

// SAFE: Generic with a correlation ID
{
  "error": "Internal Server Error",
  "correlation_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

The correlation ID allows the engineering team to find the error in logs without exposing internals to the client.

### Idempotency and Retries

A 500 is the signal that triggers **automatic retries** in well-designed clients. This means the endpoint that returned 500 should be **idempotent**. If the request actually succeeded but the response was lost, a retry should not create duplicate resources.

Use idempotency keys for non-idempotent operations:

```
POST /payments HTTP/1.1
Idempotency-Key: 5f8d9c3b-2a1e-4f6d-bc9a-7e8f2d1c0b3a
```

If the server receives the same idempotency key twice, it returns the result of the first operation instead of processing it again.

---

## The Status Code Decision Tree

When you are implementing an endpoint and need to choose a status code, follow this sequence:

```text
Did the server receive and parse the request?
├── No → Is the syntax malformed?
│   └── Yes → 400 Bad Request
│
├── Yes → Is the client authenticated?
│   └── No → 401 Unauthorized
│
├── Yes → Is the client authorized for this action?
│   └── No → 403 Forbidden (or 404 if resource must be hidden)
│
├── Yes → Does the requested resource exist?
│   └── No → 404 Not Found
│
├── Yes → Does the request pass business validation?
│   └── No → 422 Unprocessable Entity
│
├── Yes → Did the operation succeed?
│   └── Yes → 200 OK (or 201 Created, 204 No Content)
│
└── Did something unexpected fail?
    └── Yes → 500 Internal Server Error
```

---

## Common Violations in Production APIs

| Violation | Why It Happens | Why It's Harmful |
| :--- | :--- | :--- |
| **200 with error body** | Framework convenience; lazy error handling | Breaks monitoring, caching, retries, SDKs |
| **500 for validation errors** | Uncaught exceptions in business logic | Triggers unnecessary alerts; client cannot fix the request |
| **400 for authentication failures** | Treating "no token" as malformed request | Client cannot distinguish auth failure from bad syntax |
| **401 without `WWW-Authenticate`** | Forgetting the header | Client does not know how to authenticate |
| **200 for creation with no location** | Missing `Location` header on 201 | Client cannot find the created resource without an ID |

---

## The Engineer's Cheat Sheet

| Code | One-Line Meaning | Retry? | Body Required? |
| :--- | :--- | :--- | :--- |
| **200** | Success; here's the result | N/A | Usually |
| **201** | Resource created; see Location header | No (idempotency concern) | Optional |
| **204** | Success; nothing to return | N/A | No |
| **400** | Your request is malformed | No (fix the syntax) | Yes (error detail) |
| **401** | You are not authenticated | Yes (after getting credentials) | Yes |
| **403** | You are authenticated but forbidden | No | Optional |
| **404** | Resource does not exist | No | Optional |
| **422** | Validation failed; fix the data | No (fix the values) | Yes (field-level errors) |
| **500** | Something broke on our end | Yes (with backoff) | No (except correlation ID) |

---

*A status code is a promise. 200 means "I handled it." 400 means "You made a mistake." 401 means "I don't know you." 404 means "That doesn't exist." 422 means "That doesn't make sense." 500 means "I made a mistake." Break these promises, and your API becomes a liar—and a liar is the hardest system to integrate with.*