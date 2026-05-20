Here's a concise yet comprehensive overview of Java's essential concepts—what each one means, its key nuance, and practical guidance on *when* to use it in real projects.

---

### 1. Classes and Objects
- **What it is:** A **class** is a blueprint that defines state (fields) and behavior (methods). An **object** is an instance of that class created with `new`.
- **When to use:** Almost everything in Java is a class. Use classes to model real‑world entities, services, data transfer objects, etc. Favour small, focused classes (Single Responsibility Principle).

### 2. Constructors
- **What it is:** A special method invoked during object creation to initialise state. Can be overloaded. `this()` chains to another constructor.
- **When to use:** Always provide an explicit constructor when you need mandatory initialisation. Use constructor injection for dependencies to enforce immutability and testability.

### 3. Inheritance (`extends`)
- **What it is:** A class inherits fields and methods from a **single** superclass. Java has **single inheritance** (one parent class only).
- **When to use:** Only when a true **"is‑a"** relationship exists. For example, `Dog` is an `Animal`. Avoid deep inheritance hierarchies; prefer **composition** over inheritance as a general rule.

### 4. Abstract Classes and Abstract Methods
- **Abstract class:** A class declared with `abstract` that cannot be instantiated. It may contain both abstract methods (no body) and concrete methods.
- **Abstract method:** A method declared without implementation; subclasses must override it (or become abstract themselves).
- **When to use:** Use an abstract class when you want to **share common state (fields) and behavior** across closely related classes. For example, a `Shape` abstract class with a `color` field and abstract `area()` method.

### 5. Interfaces
- **What it is:** A contract (reference type) with abstract methods, `default` methods, `static` methods, and constants. A class can implement **multiple** interfaces.
- **Nuance:** Java 8+ allows default implementations; this solved the “add new methods without breaking all implementors” problem.
- **When to use:** Use an interface to define a **capability** ("can‑do") that unrelated classes can adopt—e.g., `Comparable`, `Runnable`, `Serializable`. It is the backbone of **loose coupling**, allowing you to swap implementations easily (Dependency Injection).

### 6. The `final` Keyword
- **Final variable:** Cannot be reassigned (constant for primitives; reference cannot change for objects, but object state may be mutable).
- **Final method:** Cannot be overridden by subclasses.
- **Final class:** Cannot be subclassed (e.g., `String`, `Integer`).
- **When to use:** `final` variables for constants and to guarantee immutability. `final` methods/classes to prevent unwanted overriding/inheritance (security, design integrity).

### 7. The `static` Keyword
- **Static variable/method:** Belongs to the class itself, not to any instance. Accessed via `ClassName.method()`.
- **Static block:** Executed once when the class is loaded; used for static initialization.
- **When to use:** Factory methods, utility functions (e.g., `Math.max()`), constants (`public static final`). Avoid mutable static fields (global state) as they harm testability and thread safety.

### 8. Access Modifiers
- `public` – accessible everywhere.
- `protected` – same package + subclasses.
- *package‑private* (no modifier) – same package only.
- `private` – same class only.
- **When to use:** Stick to the principle of least privilege. Make fields `private`, expose via getters/setters if needed. Use package‑private for internal collaboration within a package.

### 9. Polymorphism
- **Method Overloading:** Same method name, different parameter lists; resolved at **compile time**. Increases readability.
- **Method Overriding:** Subclass redefines a superclass’s method; resolved at **runtime** via dynamic dispatch. Enables flexible, interchangeable behavior.
- **When to use:** Override methods to provide specific implementations (`toString()`, `equals()`). Overload constructors and methods for convenience.

### 10. Enums
- **What it is:** A special type of class with a fixed set of named constants (e.g., `enum Day { MON, TUE, … }`). Can have fields, methods, and constructors.
- **When to use:** Whenever a variable should take one of a predefined list of values (status, category, command). More type‑safe than integer constants.

### 11. Nested Classes
- **Static nested class:** Logically grouped with outer class, but independent of its instance. Use for helper classes.
- **Inner class (non‑static):** Has implicit reference to an outer instance. Use when the class tightly depends on the outer object (e.g., `Iterator` implementation).
- **Local class:** Defined inside a method. Rarely used; mostly replaced by lambdas.
- **Anonymous class:** One‑time instantiation of a class, typically implementing an interface. Largely superseded by lambdas.
- **When to use:** Static nested classes are great for grouping small, related utilities (e.g., `Builder` pattern). Avoid complex inner classes—they can create memory leaks if the outer class is otherwise unreachable.

### 12. Multiple Classes in a File
- **Nuance:** A `.java` file can contain **only one public class**, and the filename must match that class. It can contain any number of package‑private classes.
- **When to use:** Use only for small helper/package‑private classes tightly coupled to the public class. For clarity, prefer one top‑level class per file.

### 13. Generics
- **What it is:** Parameterized types (e.g., `List<String>`) that provide compile‑time type safety.
- **When to use:** Anytime you write a class or method that can work with multiple types while ensuring type integrity (collections, repositories, data wrappers). Avoid raw types.

### 14. Annotations
- **What it is:** Metadata added to code that can be processed by the compiler or at runtime (`@Override`, `@Deprecated`, `@Test`).
- **When to use:** Use built‑in annotations to catch errors (`@Override`, `@FunctionalInterface`). Use framework annotations (Spring, JPA) for configuration. Create custom annotations sparingly for cross‑cutting concerns (logging, validation).

### 15. Exception Handling
- **Checked exceptions:** Must be caught or declared. Used for recoverable conditions (e.g., `IOException`).
- **Unchecked exceptions:** Runtime exceptions; programming errors (e.g., `NullPointerException`). Not forced to handle.
- **try‑with‑resources:** Automatically closes resources that implement `AutoCloseable`.
- **When to use:** Handle exceptions only where you can meaningfully recover. Use unchecked exceptions for programming bugs. Always use try‑with‑resources for streams, DB connections, etc.

### 16. Lambda Expressions & Functional Interfaces
- **What it is:** A concise way to instantiate a **functional interface** (exactly one abstract method) with a method‑body‑like expression.
- **When to use:** Whenever you need a short, throwaway implementation of a single‑method interface (e.g., `Comparator`, `ActionListener`, `Runnable`). Enables clean pipeline operations with the Streams API.

### 17. Streams API (Recap)
- **What it is:** A declarative, lazy pipeline for processing collections (filter‑map‑reduce).
- **When to use:** For transforming, filtering, and aggregating data without manual loops. Not for complex stateful logic or where a traditional loop is clearer.

### 18. Concurrency (Brief)
- **`synchronized` / `volatile`:** Ensure visibility and atomicity of shared mutable state.
- **`Executor` framework:** Use thread pools instead of new `Thread()`.
- **`CompletableFuture`:** For asynchronous, composable tasks.
- **When to use:** Reach for concurrency tools when you truly need parallel execution. Always prefer higher‑level abstractions (`ExecutorService`, `Future`, `Locks`) over raw threads.

---

A solid project mindset: **program to interfaces**, **classes for state+behavior**, **abstract classes for shared skeleton code**, **final for constants and immutability**, **generics for type safety**, and **only introduce complexity (nested classes, advanced concurrency) when the problem demands it**.

If you'd like a deeper dive into any specific concept—such as a comparison of abstract class vs interface with real project scenarios, or a guide to when to use composition over inheritance—just ask.