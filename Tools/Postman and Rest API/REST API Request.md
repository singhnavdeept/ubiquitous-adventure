---
title: "REST API Request/Response Structure, Headers, and Webhook Design"
date: "2026-06-24"
excerpt: "How to structure API contracts, what every critical header does, and why webhook callback design—especially for payments—is the hardest reliability problem in integrations."
tags: ["rest-api", "http-headers", "webhooks", "payment-callbacks", "api-design", "idempotency", "backend"]
---

# REST API Request/Response Structure, Headers, and Webhook Design

In 2021, a payment processor we integrated with changed the casing of a JSON field from `transactionId` to `transaction_id` in a minor API update. Our parser broke silently. For six hours, every payment appeared successful in our system but was stuck in `pending` at the processor. We found it when a customer called to ask why their subscription had expired despite three "successful" charges.

That day I learned: an API contract is not just endpoints and status codes. It is the **shape of every byte exchanged**, the **headers that govern behavior**, and—in the case of webhooks—the **asynchronous reliability guarantees** that your business depends on.

---

## Part 1: Request Structure

### The Anatomy of an HTTP Request

Every REST API request is composed of four parts:

```text
[Method] [Path] [HTTP Version]
[Headers]
[Empty Line]
[Body]
```

Concrete example:

```http
POST /v1/payments HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer sk_live_abc123xyz
Idempotency-Key: 5f8d9c3b-2a1e-4f6d-bc9a-7e8f2d1c0b3a
Accept: application/json

{
  "amount": 2500,
  "currency": "usd",
  "source": "tok_visa_4242"
}
```

### Method Selection

| Method | Semantics | Idempotent? | Body? | Caching |
| :--- | :--- | :--- | :--- | :--- |
| **GET** | Retrieve a resource | Yes | No | Yes (by default) |
| **POST** | Create a resource or trigger an action | No | Yes | Rarely |
| **PUT** | Replace a resource entirely | Yes | Yes | No |
| **PATCH** | Partially update a resource | Not guaranteed | Yes | No |
| **DELETE** | Remove a resource | Yes | Usually no | No |

**The critical distinction:** PUT replaces. PATCH modifies. A PUT to `/users/42` with only `{"email": "new@example.com"}` should nullify all other fields—or reject the request as incomplete. PATCH is the safer choice for partial updates.

### Path Design: Nouns, Not Verbs

```
✅ GET    /v1/orders              ← Collection
✅ GET    /v1/orders/12345        ← Single resource
✅ POST   /v1/orders              ← Create in collection
✅ GET    /v1/orders/12345/items  ← Sub-collection

❌ GET    /v1/getOrders           ← Verb in URL
❌ POST   /v1/createOrder         ← Verb in URL
❌ GET    /v1/orders?id=12345     ← ID in query string (not RESTful for primary resource)
```

The URL identifies the resource. The HTTP method identifies the action. Mixing them creates ambiguity.

### Query Parameters: Filtering, Sorting, Pagination

Query parameters are for **modifying the collection response**, not for identifying a specific resource:

```
GET /v1/orders?status=shipped&sort=-created_at&page=2&limit=50
```

| Convention | Example | Meaning |
| :--- | :--- | :--- |
| Filtering | `?status=shipped` | Only orders with this status |
| Sorting | `?sort=-created_at` | Descending by created_at (prefix `-` for DESC) |
| Pagination | `?page=2&limit=50` | Second page, 50 items per page |
| Cursor-based | `?cursor=eyJpZCI6IjQyIn0=` | More reliable for large, dynamic datasets |

---

## Part 2: Response Structure

### The Anatomy of an HTTP Response

```text
[HTTP Version] [Status Code] [Reason Phrase]
[Headers]
[Empty Line]
[Body]
```

```http
HTTP/1.1 201 Created
Content-Type: application/json
Location: /v1/payments/pay_8f3a2b1c
X-Request-Id: req_a1b2c3d4
Retry-After: 0

{
  "id": "pay_8f3a2b1c",
  "amount": 2500,
  "currency": "usd",
  "status": "succeeded",
  "created_at": "2026-06-24T14:30:00Z"
}
```

### Consistent Response Envelope

Every response should follow the same structure. The choice of envelope is less important than its consistency:

**Success envelope:**
```json
{
  "data": {
    "id": "pay_8f3a2b1c",
    "amount": 2500,
    "status": "succeeded"
  }
}
```

**Collection envelope:**
```json
{
  "data": [
    { "id": "pay_8f3a2b1c", "amount": 2500 },
    { "id": "pay_9g4b3c2d", "amount": 1500 }
  ],
  "pagination": {
    "cursor": "eyJpZCI6IjQyIn0=",
    "has_more": true,
    "total": 843
  }
}
```

**Error envelope:**
```json
{
  "error": {
    "code": "validation_failed",
    "message": "The request parameters failed validation",
    "fields": {
      "email": ["Must be a valid email address"],
      "amount": ["Must be greater than 0"]
    }
  },
  "request_id": "req_a1b2c3d4"
}
```

### The Date/Time Standard

All timestamps must be ISO 8601 in UTC. No exceptions.

```
✅ "2026-06-24T14:30:00Z"
✅ "2026-06-24T14:30:00.123Z"    ← Milliseconds okay
❌ "2026-06-24 14:30:00"          ← Missing T separator, no timezone
❌ "24/06/2026 2:30 PM EST"      ← Ambiguous format, ambiguous timezone
```

---

## Part 3: Headers That Matter

Headers are metadata that change how the server processes the request or how the client interprets the response. Some are standard HTTP. Some are custom conventions. All of them are part of your API contract.

### Request Headers

| Header | Purpose | Example | Required? |
| :--- | :--- | :--- | :--- |
| **Authorization** | Authentication credentials | `Bearer sk_live_abc123` | For authenticated endpoints |
| **Content-Type** | Format of the request body | `application/json` | For POST/PUT/PATCH with body |
| **Accept** | Format the client wants in response | `application/json` | Recommended |
| **Idempotency-Key** | Unique key for safe retries | `5f8d9c3b-...` | For non-idempotent operations |
| **User-Agent** | Identifies the client | `MyApp/2.4.3` | Recommended for debugging |
| **X-Request-Id** | Client-generated tracing ID | `req_a1b2c3d4` | Recommended |

### Response Headers

| Header | Purpose | Example | When |
| :--- | :--- | :--- | :--- |
| **Content-Type** | Format of the response body | `application/json` | Always |
| **Location** | URL of newly created resource | `/v1/payments/pay_8f3a` | 201 Created |
| **Retry-After** | Seconds until client can retry | `30` or `Wed, 21 Oct 2026 07:28:00 GMT` | 429 Too Many Requests, 503 Service Unavailable |
| **X-Request-Id** | Server-generated tracing ID | `req_z9y8x7w6` | Every response |
| **X-RateLimit-Limit** | Total requests allowed in window | `1000` | Rate-limited APIs |
| **X-RateLimit-Remaining** | Requests remaining in window | `847` | Rate-limited APIs |
| **X-RateLimit-Reset** | When the window resets (Unix epoch) | `1719234567` | Rate-limited APIs |

### Idempotency-Key: The Header That Saves Money

For any operation that creates or modifies state and is not inherently idempotent (every POST, most PATCH), the client should send an `Idempotency-Key` header.

**How the server implements it:**
1. On first receipt, process the request and store the key → response mapping.
2. On subsequent receipts with the same key, return the stored response without re-processing.
3. Keys should be unique per operation, not per request. Retrying a failed payment uses the same key.

**Stripe's implementation (the gold standard):**
- Keys are stored for 24 hours.
- Keys are scoped to the API key, not global.
- The response includes an `Idempotency-Key: received` header to acknowledge safe receipt.

---

## Part 4: Webhooks and Payment Callbacks

### The Problem Webhooks Solve

Your system initiates a payment. The payment processor returns `200 OK` with `status: "processing"`. The actual confirmation—funds settled, fraud review passed, 3D Secure completed—may arrive seconds, minutes, or hours later.

You could poll. But polling is wasteful and introduces latency. The processor instead **calls you back** when the state changes. This is a webhook.

### Webhook vs. API Call: Directionality

| Feature | REST API Call | Webhook |
| :--- | :--- | :--- |
| **Initiator** | Your server | Their server |
| **Direction** | You → Them | Them → You |
| **Purpose** | Request or mutate data | Notify of an event |
| **Timing** | Immediate | Asynchronous |
| **Retry responsibility** | Yours (as client) | Theirs (as sender) |

### The Webhook Delivery Contract

A well-designed webhook system guarantees **at-least-once delivery**. The sender will keep trying until it receives an acknowledgment.

```text
[Payment Processor]                    [Your Server]
       |                                      |
       |  POST /webhooks/stripe HTTP/1.1      |
       |  Content-Type: application/json      |
       |  Stripe-Signature: t=12345,v1=abc... |
       |  {                                   |
       |    "type": "payment_intent.succeeded",|
       |    "data": { ... }                   |
       |  }                                   |
       |------------------------------------->|
       |                                      |
       |  HTTP/1.1 200 OK                     |
       |<-------------------------------------|
       |                                      |
       |  (If no 200, retry with backoff)     |
       |  Retry 1: 5 seconds                  |
       |  Retry 2: 25 seconds                 |
       |  Retry 3: 125 seconds                |
       |  ...                                 |
```

### The Critical Rule: Acknowledge Immediately, Process Later

Your webhook endpoint must return a 2xx status code **as fast as possible**—ideally within a few hundred milliseconds. The acknowledgment means: "I received the event and take responsibility for it."

Processing—updating your database, sending emails, fulfilling orders—happens **after** the acknowledgment.

```python
# ✅ CORRECT: Acknowledge, then process
@app.post("/webhooks/stripe")
async def stripe_webhook(request):
    payload = await request.body()
    signature = request.headers.get("Stripe-Signature")
    
    # Step 1: Verify signature (fast, no DB)
    try:
        event = stripe.Webhook.construct_event(payload, signature, webhook_secret)
    except ValueError:
        return JSONResponse({"error": "Invalid payload"}, status_code=400)
    except stripe.error.SignatureVerificationError:
        return JSONResponse({"error": "Invalid signature"}, status_code=401)
    
    # Step 2: Acknowledge immediately (200ms)
    # Queue the event for background processing
    await event_queue.enqueue(event)
    
    return JSONResponse({"received": True}, status_code=200)

# ❌ WRONG: Processing during the webhook request
@app.post("/webhooks/stripe")
async def stripe_webhook(request):
    event = parse_event(request)
    update_database(event)          # Takes 3 seconds
    send_confirmation_email(event)  # Takes 2 seconds
    update_analytics(event)         # Takes 1 second
    return JSONResponse({"received": True}, status_code=200)  # 6 seconds later
```

The wrong approach breaks under load: the sender times out waiting for the acknowledgment, assumes failure, and retries—doubling your processing load with every retry cycle.

### Webhook Authentication: Signature Verification

Anyone can POST to your webhook endpoint. Without authentication, an attacker can send fake payment success events and trigger order fulfillment.

Stripe's signature scheme is the reference implementation:

1. Stripe signs the payload with a shared secret using HMAC-SHA256.
2. The signature is sent in the `Stripe-Signature` header.
3. Your server computes the signature using the same secret and payload.
4. If the signatures match, the event is authentic.

```http
POST /webhooks/stripe HTTP/1.1
Stripe-Signature: t=1719234567,v1=8f3a2b1c9d4e5f6a7b8c9d0e1f2a3b4c,v0=9d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a
```

- `t`: Unix timestamp of the event (prevents replay attacks if you reject old timestamps).
- `v1`: HMAC-SHA256 signature of `t.payload`.
- `v0`: Legacy signature for backward compatibility.

### Handling Duplicate Events (Idempotency)

At-least-once delivery means you **will** receive duplicate events. Your webhook handler must be idempotent.

**Strategy: Event ID deduplication.**

```sql
-- On receipt of event with id 'evt_abc123':
-- If the event ID exists in the processed_events table, skip it.
INSERT INTO processed_events (event_id, processed_at)
VALUES ('evt_abc123', NOW())
ON CONFLICT (event_id) DO NOTHING;

-- If the insert succeeded (row was added), this is a new event. Process it.
-- If the insert was ignored (ON CONFLICT), this is a duplicate. Return 200 immediately.
```

### Webhook Ordering and Gaps

Events can arrive **out of order**. A `payment_intent.succeeded` event might arrive before the `payment_intent.created` event.

**Strategy:** Design your state machine to handle out-of-order events. If a `succeeded` event arrives for an unknown payment intent, store the event and process it when the `created` event fills in the missing context.

Events can also **go missing** entirely (a network partition during transmission). For payments, this is unacceptable.

**Strategy: Reconciliation.** Run a daily cron job that queries the processor's API for all payments in your system with status `processing` or `pending` and verifies their true state. Webhooks are the fast path. Reconciliation is the safety net.

### The Payment-Specific Webhook Events You Must Handle

For a typical payment integration, these are the minimum events:

| Event | Meaning | Action |
| :--- | :--- | :--- |
| `payment_intent.created` | Payment initiated | Record in database with status `pending` |
| `payment_intent.succeeded` | Payment confirmed | Fulfill the order; activate subscription |
| `payment_intent.payment_failed` | Payment declined | Notify customer; suggest retry |
| `payment_intent.canceled` | Payment canceled by you or customer | Release held inventory |
| `charge.refunded` | Refund processed | Reverse fulfillment; update accounting |
| `charge.dispute.created` | Chargeback filed | Notify fraud team immediately |
| `charge.dispute.closed` | Chargeback resolved | Update accounting with outcome |

---

## The Engineer's Checklist

### For Every REST Endpoint

- [ ] Request body schema is documented and versioned.
- [ ] All timestamps are ISO 8601 UTC.
- [ ] POST/PATCH endpoints accept `Idempotency-Key` and handle it correctly.
- [ ] Error responses include a consistent envelope with `request_id`.
- [ ] Rate limit headers are returned on all responses.
- [ ] 201 responses include a `Location` header.

### For Every Webhook Endpoint

- [ ] Webhook payloads are verified with HMAC signature.
- [ ] The endpoint returns 200 **before** processing the event.
- [ ] Processing is idempotent (event ID deduplication).
- [ ] Out-of-order events are handled gracefully.
- [ ] A daily reconciliation job verifies no events were missed.
- [ ] The endpoint responds within 500ms under peak load.

---

*An API is a promise. The request structure tells the server what you want. The response structure tells the client what happened. The headers govern the interaction. And the webhook—the callback you wait for at 3 AM while the payment processor decides whether to accept a customer's card—is the ultimate test of whether your system keeps its promises.*