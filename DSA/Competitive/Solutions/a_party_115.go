package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	in := bufio.NewReader(os.Stdin)

	var n int
	fmt.Fscan(in, &n)

	parent := make([]int, n+1)

	for i := 1; i <= n; i++ {
		fmt.Fscan(in, &parent[i])
	}

	maxDepth := 0

	// Calculate depth for every employee
	for i := 1; i <= n; i++ {
		depth := 1
		cur := i

		// Move upward in hierarchy
		for parent[cur] != -1 {
			depth++
			cur = parent[cur]
		}

		if depth > maxDepth {
			maxDepth = depth
		}
	}

	fmt.Println(maxDepth)
}