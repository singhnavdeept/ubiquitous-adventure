

## 1. Using `constexpr` (C++11 and later) – Recommended

A `constexpr` function can be evaluated at compile time if all its arguments are compile‑time constants. The Euclidean algorithm works perfectly.

```cpp
#include <iostream>

// constexpr GCD function (C++14 makes it easier, but C++11 works too)
constexpr int gcd(int a, int b) {
    while (b != 0) {          // C++11 requires a single return statement?
        int t = a % b;        // Actually C++11 allows loops in constexpr since C++14.
        a = b;                // For C++11 you'd write recursively. We'll assume C++14+.
        b = t;
    }
    return a < 0 ? -a : a;    // handle negative numbers
}

// Alternative recursive version (C++11 compatible)
constexpr int gcd_rec(int a, int b) {
    return b == 0 ? (a < 0 ? -a : a) : gcd_rec(b, a % b);
}

int main() {
    // These are forced to be computed at compile time
    constexpr int result1 = gcd(48, 18);          // 6
    constexpr int result2 = gcd_rec(48, 18);      // 6

    // Verify at compile time (if the computation fails, compilation stops)
    static_assert(gcd(48, 18) == 6, "gcd(48,18) should be 6");
    static_assert(gcd(17, 13) == 1, "gcd(17,13) should be 1");

    // Also works at runtime if needed
    std::cout << "GCD(48,18) = " << result1 << '\n';
    return 0;
}
```

**Key points:**
- Mark the function `constexpr`.
- Use `static_assert` to force compile‑time evaluation.
- Store the result in a `constexpr` variable.
- Compile with `-std=c++14` or later (most compilers default to C++14/17 now).

## 2. Using Template Metaprogramming (C++98 / pre‑C++11)

If you need to support older compilers or want a pure compile‑time computation without `constexpr`, you can use recursive templates.

```cpp
#include <iostream>

// Primary template
template<int A, int B>
struct GCD {
    static const int value = GCD<B, A % B>::value;
};

// Specialization when B == 0
template<int A>
struct GCD<A, 0> {
    static const int value = (A < 0 ? -A : A);
};

int main() {
    // The value is computed entirely at compile time
    std::cout << GCD<48, 18>::value << '\n';   // prints 6
    static_assert(GCD<48, 18>::value == 6, "compile‑time check");
    return 0;
}
```

**How it works:** The compiler instantiates templates recursively until the second argument becomes zero, then evaluates the static constant.

## 3. Compile‑Time with C++17 `if constexpr`

You can also write a single `constexpr` function using `if constexpr` for clarity:

```cpp
constexpr int gcd(int a, int b) {
    if constexpr (b != 0) {
        return gcd(b, a % b);
    } else {
        return a < 0 ? -a : a;
    }
}
```

## Verify Compile‑Time Evaluation

To be certain the GCD is computed at compile time (and not at runtime), compile with **optimizations enabled** and check the generated assembly:

```bash
g++ -std=c++17 -O2 -S gcd.cpp
```

Look for the `main` function – you should see the constant `6` directly loaded, not a call to a `gcd` function.

## Complete Example (Modern C++)

```cpp
#include <iostream>

constexpr int gcd(int a, int b) {
    while (b != 0) {
        int t = a % b;
        a = b;
        b = t;
    }
    return (a < 0) ? -a : a;
}

int main() {
    constexpr int g = gcd(1071, 462); // = 21
    static_assert(g == 21);

    std::cout << "GCD(1071, 462) = " << g << '\n';
    return 0;
}
```

## Summary

- **Use `constexpr`** – it’s simple, readable, and works in any C++11 (with recursion) or C++14 (with loops) compiler.
- **Static assertions** (`static_assert`) are your best proof that the computation happens at compile time.
- For legacy code, **template metaprogramming** provides a pure compile‑time mechanism without `constexpr`.

This approach ensures zero runtime overhead – the answer is embedded directly into your executable.

To find the **size (number of elements)** of a statically‑sized C‑style array at **compile time** in C++, you can use a template function that deduces the array’s type and length. The result is a compile‑time constant (e.g., can be used in `static_assert` or as a template argument). This works because the array bound is known at compile time.

## Best practice: template + `constexpr`

```cpp
#include <iostream>

template<typename T, std::size_t N>
constexpr std::size_t array_size(T (&)[N]) noexcept {
    return N;
}

int main() {
    int arr[42];
    constexpr std::size_t sz = array_size(arr);  // 42, computed at compile time
    static_assert(sz == 42);

    double darr[100];
    std::cout << array_size(darr) << '\n';       // prints 100

    return 0;
}
```

**How it works:**  
- The function template accepts a reference to an array of type `T` and size `N`.  
- The compiler deduces `N` as the number of elements.  
- The function is `constexpr`, so it can be evaluated at compile time.

## Using `std::size` (C++17 and later)

C++17 introduced `std::size` (in `<iterator>`) which works for both built‑in arrays and standard containers. It is also `constexpr`.

```cpp
#include <iterator>   // for std::size

int main() {
    int arr[123];
    constexpr std::size_t sz = std::size(arr);
    static_assert(sz == 123);
}
```

## Getting the number of dimensions (rank) of a multidimensional array

If you meant “dimension” as in **rank** (e.g., `int arr[5][6]` has rank 2), you can use `std::rank` from `<type_traits>` (C++11).

```cpp
#include <type_traits>

int main() {
    int arr[5][6];
    constexpr std::size_t rank = std::rank<decltype(arr)>::value; // 2
    static_assert(rank == 2);
}
```

Or using the helper `std::rank_v` (C++17):

```cpp
constexpr std::size_t rank = std::rank_v<decltype(arr)>;
```

## Getting sizes of individual dimensions

For a multidimensional array, you might want each dimension’s size (e.g., `5` and `6`). This can be done with a recursive template or simply using `std::extent`:

```cpp
#include <type_traits>

int main() {
    int arr[5][6];

    constexpr std::size_t dim1 = std::extent<decltype(arr), 0>::value; // 5
    constexpr std::size_t dim2 = std::extent<decltype(arr), 1>::value; // 6

    static_assert(dim1 == 5);
    static_assert(dim2 == 6);
}
```

C++17 style:

```cpp
constexpr auto dim1 = std::extent_v<decltype(arr), 0>;
constexpr auto dim2 = std::extent_v<decltype(arr), 1>;
```

## Important note: What does NOT work at compile time

The classic macro `#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))` is evaluated at compile time as well because `sizeof` is a constant expression. However, it is **dangerous** because it silently accepts pointers (decayed arrays), returning the wrong size. The template approach above rejects pointers, giving a compile‑time error. Always prefer the template or `std::size`.

```cpp
void func(int* ptr) {
    // int sz = sizeof(ptr) / sizeof(ptr[0]);  // Wrong: sizeof(ptr) = 8 (on 64‑bit), not array size
}
```

## Summary

| Goal                                   | Best C++ method (compile‑time safe)        |
|----------------------------------------|---------------------------------------------|
| Number of elements (1D array)          | `std::size(arr)` (C++17) or custom template |
| Rank (number of dimensions)            | `std::rank_v<decltype(arr)>`               |
| Size of a specific dimension           | `std::extent_v<decltype(arr), K>`          |

All these produce **compile‑time constants**, so you can use them in template arguments, `static_assert`, and `constexpr` contexts.