---
tags: [golang, roadmap, grpc, protobuf]
aliases: ["Phase 7: gRPC & Protocol Buffers"]
---
# Phase 7: gRPC & Protocol Buffers

gRPC is a high-performance, open-source universal RPC framework developed by Google. While REST relies on HTTP/1.1 and JSON, gRPC relies on HTTP/2 and Protocol Buffers (protobufs). It is the dominant choice for internal microservice-to-microservice communication in Go.

---

## 7.1 Protocol Buffers

Protocol Buffers are a language-neutral, platform-neutral extensible mechanism for serializing structured data. You define how you want your data to be structured once, and then you can use special generated source code to easily write and read your structured data to and from a variety of data streams and using a variety of languages.

### Writing a `.proto` file

```protobuf
// user.proto
syntax = "proto3";

// Option used by the Go compiler to determine the package name
option go_package = "example.com/project/pb";

package user;

// Message definition (similar to a Go struct)
message User {
  string id = 1;      // '1' is the unique field number used in binary serialization
  string name = 2;
  string email = 3;
  int32 age = 4;
}

message GetUserRequest {
  string user_id = 1;
}

message GetUserResponse {
  User user = 1;
}

// Service definition (defines the RPC methods)
service UserService {
  // A standard Unary RPC (1 request, 1 response)
  rpc GetUser(GetUserRequest) returns (GetUserResponse);
}
```

### Compiling Protobufs to Go
You use the `protoc` compiler with the Go plugins to generate `.pb.go` (message structs) and `_grpc.pb.go` (client/server interfaces) files.

```bash
protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    user.proto
```
*(Note: Modern teams often use the tool `Buf` to manage protobuf compilation instead of raw `protoc`)*

---

## 7.2 gRPC Basics

There are four types of gRPC service methods:
1. **Unary:** Client sends a single request and gets a single response (like standard REST).
2. **Server Streaming:** Client sends a single request and gets a stream to read a sequence of messages back.
3. **Client Streaming:** Client writes a sequence of messages and sends them to the server. Once finished, it waits for the server to return a single response.
4. **Bidirectional Streaming:** Both sides send a sequence of messages using a read-write stream.

### Implementing the gRPC Server (Unary)

```go
package main

import (
	"context"
	"log"
	"net"

	"google.golang.org/grpc"
	
	// Import the generated protobuf code
	// pb "example.com/project/pb"
)

// 1. Define a struct that implements the generated server interface
type server struct {
	// Embed the Unimplemented server to ensure forward compatibility
	pb.UnimplementedUserServiceServer 
}

// 2. Implement the RPC method
func (s *server) GetUser(ctx context.Context, req *pb.GetUserRequest) (*pb.GetUserResponse, error) {
	log.Printf("Received request for user ID: %v", req.GetUserId())
	
	// Simulate fetching from DB
	user := &pb.User{
		Id:    req.GetUserId(),
		Name:  "Alice",
		Email: "alice@example.com",
		Age:   30,
	}
	
	return &pb.GetUserResponse{User: user}, nil
}

func main() {
	// 3. Listen on a TCP port
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	// 4. Create a new gRPC server instance
	s := grpc.NewServer()
	
	// 5. Register our service implementation with the gRPC server
	pb.RegisterUserServiceServer(s, &server{})

	log.Printf("server listening at %v", lis.Addr())
	
	// 6. Serve traffic
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
```

### Implementing the gRPC Client

```go
package main

import (
	"context"
	"log"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	
	// pb "example.com/project/pb"
)

func main() {
	// 1. Establish a connection to the server
	// insecure.NewCredentials() is used here for simplicity (no TLS)
	conn, err := grpc.Dial("localhost:50051", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()

	// 2. Create the client stub using the generated code
	c := pb.NewUserServiceClient(conn)

	// 3. Always pass a context with a timeout for RPC calls!
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()

	// 4. Call the method
	r, err := c.GetUser(ctx, &pb.GetUserRequest{UserId: "123"})
	if err != nil {
		log.Fatalf("could not get user: %v", err)
	}
	
	log.Printf("User Details: %s (%s)", r.GetUser().GetName(), r.GetUser().GetEmail())
}
```

---

## 7.3 gRPC in Production

### Interceptors
Interceptors are the gRPC equivalent of HTTP Middleware. They intercept execution of RPCs on both the client and the server.
- **Unary Interceptor**: For single request/response.
- **Stream Interceptor**: For streaming RPCs.

Use cases include: Logging, Authentication, Metrics, and Tracing.

### gRPC-Gateway
Often, you need to expose your internal gRPC service to external clients (like web browsers) that only understand REST/JSON. `grpc-gateway` is a plugin that reads annotations in your `.proto` file and automatically generates a reverse-proxy server that translates incoming RESTful JSON HTTP requests into gRPC calls.

---

## Interview Questions - Phase 7

1. **What are the primary differences between gRPC and REST?**
   *Answer:* 
   - **Protocol**: gRPC uses HTTP/2 exclusively, enabling multiplexing and bidirectional streaming. REST typically uses HTTP/1.1 (though it can use HTTP/2, it rarely leverages its advanced features).
   - **Payload**: gRPC uses Protocol Buffers (binary payload) which is much smaller and faster to serialize/deserialize. REST usually uses JSON (text payload).
   - **Contract**: gRPC is strongly typed by design via the `.proto` file. REST relies on OpenAPI/Swagger specs which are often out-of-sync or optional.

2. **Why do we define field numbers (e.g., `string name = 2;`) in Protocol Buffers?**
   *Answer:* Protocol Buffers use these numbers to identify your fields in the serialized binary data format. Unlike JSON, the field names ("name") are NOT sent over the wire, which saves bandwidth. Field numbers must never change once deployed, as doing so breaks backwards compatibility.

3. **What is an Interceptor in gRPC?**
   *Answer:* An Interceptor is gRPC's concept of middleware. It allows you to intercept the execution of an RPC call before it hits the handler (on the server) or before it goes over the network (on the client). They are heavily used for centralized logging, authentication, adding context metadata, and panic recovery.

4. **Why is it critical to pass a Context to every gRPC client call?**
   *Answer:* A Context allows you to set explicit deadlines/timeouts for the RPC call. If service A calls service B, and B hangs, service A will be stuck waiting forever if no timeout is provided, potentially leading to resource exhaustion and cascading failures across the microservice architecture. Contexts also allow you to cancel the call if the user aborts the request.
