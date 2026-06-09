---
tags: [golang, roadmap, security, auth, jwt]
aliases: ["Phase 5: Authentication & Security"]
---
# Phase 5: Authentication & Security

Security is paramount in backend engineering. Go provides robust crypto libraries in the standard library and excellent community packages for authentication.

---

## 5.1 JSON Web Tokens (JWT)

JWTs are the industry standard for stateless authentication in REST APIs. The `golang-jwt/jwt` package is the most widely used.

### Generating a JWT

```go
package main

import (
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

var secretKey = []byte("super-secret-key-change-me")

func generateToken(userID string) (string, error) {
	// Create claims
	claims := jwt.MapClaims{
		"user_id": userID,
		"exp":     time.Now().Add(time.Hour * 24).Unix(), // Token expires in 24 hours
		"iat":     time.Now().Unix(),
	}

	// Create token with claims and signing method
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	// Sign the token with our secret key
	return token.SignedString(secretKey)
}

func main() {
	token, err := generateToken("user_123")
	if err != nil {
		fmt.Println("Error generating token:", err)
		return
	}
	fmt.Println("Generated Token:", token)
}
```

### Validating a JWT

```go
func validateToken(tokenString string) (jwt.MapClaims, error) {
	// Parse the token
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		// Validate the alg is what you expect
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return secretKey, nil
	})

	if err != nil {
		return nil, err
	}

	// Extract claims
	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		return claims, nil
	}

	return nil, fmt.Errorf("invalid token")
}
```

---

## 5.2 Password Hashing

Never store plain text passwords! Use `bcrypt` to hash passwords securely.

```go
package main

import (
	"fmt"
	"log"

	"golang.org/x/crypto/bcrypt"
)

// HashPassword generates a bcrypt hash of the password
func HashPassword(password string) (string, error) {
	// GenerateFromPassword automatically handles salt generation
	// DefaultCost is 10. Higher cost = slower, but more secure.
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	return string(bytes), err
}

// CheckPasswordHash compares a raw password against a hash
func CheckPasswordHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}

func main() {
	password := "my_secure_password_123"

	// 1. User registers: Hash the password
	hash, err := HashPassword(password)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Stored Hash:", hash)

	// 2. User logs in: Verify the password
	match := CheckPasswordHash(password, hash)
	fmt.Println("Password Match:", match) // true

	wrongMatch := CheckPasswordHash("wrong_password", hash)
	fmt.Println("Wrong Password Match:", wrongMatch) // false
}
```

---

## 5.3 OAuth 2.0 / OIDC (OpenID Connect)

For "Login with Google/GitHub", use the `golang.org/x/oauth2` package.

```go
package main

import (
	"fmt"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
)

var (
	googleOauthConfig = &oauth2.Config{
		RedirectURL:  "http://localhost:8080/callback",
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"https://www.googleapis.com/auth/userinfo.email"},
		Endpoint:     google.Endpoint,
	}
)

func main() {
	// Generate the URL to redirect the user to Google's login page
	// In production, generate a random state string to prevent CSRF
	url := googleOauthConfig.AuthCodeURL("random-state-string")
	fmt.Printf("Visit the URL for the auth dialog: %v\n", url)
	
	// Once the user authenticates, Google redirects to your RedirectURL with a 'code'.
	// You exchange that code for an access token:
	// token, err := googleOauthConfig.Exchange(context.Background(), code)
}
```

---

## 5.4 Security Best Practices

Building a secure Go backend goes beyond just hashing passwords.

- **SQL Injection**: Handled automatically if you use parameterized queries or an ORM like GORM. Never concatenate strings into SQL statements.
- **XSS (Cross-Site Scripting)**: Use `html/template` instead of `text/template` when rendering HTML. It automatically escapes data. If building a JSON API, the frontend framework (React, Vue) usually handles escaping.
- **CORS (Cross-Origin Resource Sharing)**: If your frontend and backend are on different domains, you need to configure CORS middleware (e.g., using `github.com/rs/cors`).
- **Rate Limiting**: Prevent abuse by limiting how many requests a user/IP can make. Use libraries like `golang.org/x/time/rate` (Token Bucket algorithm).
- **Secrets Management**: Never hardcode API keys or secrets in your source code. Inject them via Environment Variables (`os.Getenv()`) and manage them using a tool like HashiCorp Vault or AWS Secrets Manager.

---

## Interview Questions - Phase 5

1. **How does a JWT work, and what are its three parts?**
   *Answer:* A JWT is a stateless authentication token. It consists of three parts separated by dots (`.`):
   1. **Header**: Contains the type of token and the signing algorithm used (e.g., HMAC SHA256).
   2. **Payload (Claims)**: Contains the statements about the entity (user ID, expiration time, roles).
   3. **Signature**: Created by encoding the header and payload, and signing it with a secret key known only to the server. This ensures the token hasn't been tampered with.

2. **Why is bcrypt preferred over SHA-256 for hashing passwords?**
   *Answer:* SHA-256 is designed to be fast, which is terrible for passwords because an attacker can compute millions of hashes per second in a brute-force attack. `bcrypt` is designed to be intentionally slow and computationally expensive (by adjusting its "cost factor"). It also automatically generates and embeds a unique salt into every hash, protecting against Rainbow Table attacks.

3. **What is a CSRF attack, and how do you prevent it in an API using JWTs?**
   *Answer:* Cross-Site Request Forgery (CSRF) is an attack where a malicious site tricks a user's browser into executing unwanted actions on a trusted site where they are authenticated. If you store your JWT in an `HttpOnly` Cookie, it is sent automatically by the browser, making you vulnerable to CSRF. You can prevent it by using a `SameSite=Strict` cookie attribute, implementing Anti-CSRF tokens, or by storing the JWT in memory/local storage and passing it explicitly in the `Authorization: Bearer <token>` header (since headers aren't sent automatically cross-origin).

4. **What does the `oauth2.Config.AuthCodeURL(state)` state parameter do?**
   *Answer:* The `state` parameter is a random, unguessable string generated by your backend before redirecting the user to the OAuth provider. When the provider redirects back to your callback URL, it includes this exact state string. You must verify that the returned state matches the one you originally generated. This prevents CSRF attacks during the OAuth flow.
