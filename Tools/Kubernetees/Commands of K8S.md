Just like with Docker, the Pareto Principle applies perfectly to `kubectl`. A small set of commands will form the foundation of your daily interaction with any Kubernetes cluster. Mastering these essentials will allow you to deploy, inspect, and debug your applications with confidence.

The table below lists the top 15 `kubectl` commands you'll use 80% of the time. These commands are organized into categories like inspection, deployment, and debugging to help you remember them.

### ⚡ The Vital 15%: Your Daily kubectl Command Kit

| Command Category | Command | Description | Most Useful Flags |
| :--- | :--- | :--- | :--- |
| **Inspect & List** | `kubectl get` | List resources (pods, deployments, nodes, etc.) | `-o wide` (more details), `-n` (namespace), `-A` (all namespaces), `-w` (watch) |
| | `kubectl describe` | Show detailed, human-readable info about a resource | (none specific, use with resource type and name) |
| **Debug & Monitor** | `kubectl logs` | Print logs from a container in a pod | `-f` (follow), `--tail`, `-c` (specific container) |
| | `kubectl exec` | Execute a command in a container | `-it` (interactive terminal), `-c` (specific container) |
| | `kubectl top` | Display real-time resource usage (CPU/memory) for pods/nodes | (none specific, use with `pod` or `node`) |
| **Manage Resources** | `kubectl apply` | Create or update resources from a YAML/JSON file (declarative) | `-f` (filename), `--dry-run` (preview) |
| | `kubectl delete` | Delete resources by filename, stdin, or name/type | `-f` (filename), `-l` (label selector), `-A` |
| | `kubectl create` | Create a resource from a file or via a command (imperative) | `--dry-run`, `-o yaml` (output) |
| | `kubectl edit` | Edit a live resource directly in your default editor | (none specific, use with resource type and name) |
| **Maintain Workloads** | `kubectl rollout` | Manage the rollout of a resource (e.g., Deployment) | `status`, `history`, `undo`, `restart` |
| | `kubectl scale` | Scale a Deployment, ReplicaSet, or StatefulSet | `--replicas` |
| **Cluster & Context** | `kubectl config` | Modify kubeconfig files (to manage contexts, clusters, users) | `use-context`, `set-context`, `get-contexts` |
| | `kubectl cluster-info` | Display addresses of the control plane and services | (none specific) |
| **Advanced/Utility** | `kubectl port-forward` | Forward one or more local ports to a pod | (none specific, specify local:remote ports) |
| | `kubectl cp` | Copy files/directories between a container and the local filesystem | (none specific, use `source:path` and `dest:path`) |
| | `kubectl explain` | Display documentation for a resource or field | `--recursive` |

---

### 🕵️‍♂️ Inspecting and Understanding Your Cluster

These commands are your eyes into the cluster. Use them to see what's running and investigate its state.

#### `kubectl get` – List Resources

This is your primary command for listing any Kubernetes resource. It's the first step in the recommended `get → describe → logs` debugging workflow.

*   **Basic Syntax**: `kubectl get [RESOURCE_TYPE]`
*   **Examples**:
    *   `kubectl get pods` - List all pods in the current namespace.
    *   `kubectl get pods -n kube-system` - List pods in a specific namespace (e.g., `kube-system`).
    *   `kubectl get pods -A` - List pods in **A**ll namespaces.
    *   `kubectl get pods -o wide` - Get more details, like which node the pod is running on and its internal IP.
    *   `kubectl get nodes` - List all nodes in your cluster.
    *   `kubectl get all` - A convenient way to list many common resource types at once in the current namespace.

#### `kubectl describe` – Get Detailed Information

When `get` isn't enough, `describe` provides a wealth of detail about a specific resource, including its configuration, status, and, most importantly, recent events.

*   **Basic Syntax**: `kubectl describe [RESOURCE_TYPE] [RESOURCE_NAME]`
*   **Examples**:
    *   `kubectl describe pod my-nginx-pod` - Get detailed info about a pod.
    *   `kubectl describe node my-worker-node` - Check node-level details like resource pressure and taints.
    *   `kubectl describe service my-service` - Inspect service endpoints and selectors.

---

### 🐛 Debugging and Monitoring

When something goes wrong, these commands help you dive deep into your pods to find the root cause.

#### `kubectl logs` – View Container Logs

Essential for seeing what your application is printing to `stdout` and `stderr`.

*   **Basic Syntax**: `kubectl logs [POD_NAME]`
*   **Examples**:
    *   `kubectl logs my-pod` - View the logs for the pod.
    *   `kubectl logs -f my-pod` - **F**ollow the logs in real-time (like `tail -f`).
    *   `kubectl logs --tail=50 my-pod` - View only the last 50 lines.
    *   `kubectl logs my-pod -c my-container` - If your pod has multiple containers, use `-c` to specify which one.

#### `kubectl exec` – Execute Commands in a Container

This allows you to run commands inside a running container, which is invaluable for interactive debugging or running one-off scripts.

*   **Basic Syntax**: `kubectl exec [POD_NAME] -- [COMMAND]`
*   **Examples**:
    *   `kubectl exec -it my-pod -- /bin/sh` - Open an interactive shell inside the pod (use `/bin/bash` if available).
    *   `kubectl exec my-pod -- ls /app` - Run a one-off command to list the contents of the `/app` directory.

#### `kubectl top` – Monitor Resource Usage

Shows real-time CPU and memory usage for pods and nodes, provided your cluster has a metrics server deployed.

*   **Basic Syntax**: `kubectl top [RESOURCE_TYPE]`
*   **Examples**:
    *   `kubectl top pods` - See CPU and memory usage per pod in the current namespace.
    *   `kubectl top nodes` - View overall resource usage across all nodes.

---

### 🚀 Deploying and Managing Applications

These commands are how you bring your applications to life and keep them running smoothly.

#### `kubectl apply` – Declarative Resource Management

This is the preferred, cloud-native way to manage resources. You define the desired state in YAML files, and `kubectl apply` makes it happen. This is the "declarative" approach.

*   **Basic Syntax**: `kubectl apply -f [FILE_NAME]`
*   **Examples**:
    *   `kubectl apply -f deployment.yaml` - Create or update the resources defined in the file.
    *   `kubectl apply -f ./my-configs/` - Apply all YAML files in a directory.

#### `kubectl rollout` – Manage Application Updates

This family of commands lets you manage the lifecycle of a deployment, from performing updates to rolling back to a stable version.

*   **Basic Syntax**: `kubectl rollout [SUBCOMMAND] [RESOURCE_TYPE] [RESOURCE_NAME]`
*   **Examples**:
    *   `kubectl rollout status deployment/my-app` - Check if the deployment's update is successful.
    *   `kubectl rollout history deployment/my-app` - See the revision history of the deployment.
    *   `kubectl rollout undo deployment/my-app` - Revert to the previous deployment.
    *   `kubectl rollout restart deployment/my-app` - Perform a rolling restart of all pods in a deployment.

#### `kubectl scale` – Adjust Application Capacity

Easily change the number of replicas for your application to handle varying loads.

*   **Basic Syntax**: `kubectl scale [RESOURCE_TYPE] [RESOURCE_NAME] --replicas=[COUNT]`
*   **Examples**:
    *   `kubectl scale deployment my-app --replicas=5` - Scale the application to 5 running pods.
    *   `kubectl scale --replicas=0 deployment/my-app` - Scale an application down to zero, stopping all pods.

#### `kubectl edit` – Make Live Changes

Sometimes, you need to make a quick, one-off change to a running resource without modifying your original YAML file.

*   **Basic Syntax**: `kubectl edit [RESOURCE_TYPE] [RESOURCE_NAME]`
*   **Examples**:
    *   `kubectl edit deployment my-app` - Opens the deployment's manifest in your default text editor ($EDITOR). Make your changes, save, and exit—Kubernetes will apply them immediately.

---

### 🔧 Cluster and Context Management

Use these commands to manage your connection to one or more Kubernetes clusters.

#### `kubectl config` – Manage kubeconfig

Kubernetes uses a configuration file, known as kubeconfig, to store cluster, user, and namespace information. This command helps you manage it.

*   **Examples**:
    *   `kubectl config get-contexts` - List all available contexts in your kubeconfig.
    *   `kubectl config use-context my-prod-cluster` - Switch your default context to the `my-prod-cluster`.
    *   `kubectl config set-context --current --namespace=my-namespace` - Change the default namespace for your current context.

#### `kubectl cluster-info` – View Cluster Details

A simple command to see the endpoints for your Kubernetes control plane and other core services.

*   **Examples**:
    *   `kubectl cluster-info` - Get the addresses for the Kubernetes master and KubeDNS.

---

### ⚙️ Advanced / Utility Commands

These commands are invaluable for specific tasks like local testing and debugging.

#### `kubectl port-forward` – Access Pods Locally

Forwards a port from your local machine to a port on a specific pod. This is a fantastic way to test or debug a service without exposing it with a load balancer or node port.

*   **Basic Syntax**: `kubectl port-forward [POD_NAME] [LOCAL_PORT]:[POD_PORT]`
*   **Examples**:
    *   `kubectl port-forward my-app-pod 8080:80` - Access your application by opening `http://localhost:8080` in your browser.

#### `kubectl cp` – Copy Files

Copy files and directories between your local filesystem and a container.

*   **Basic Syntax**: `kubectl cp [SOURCE_PATH] [DESTINATION_PATH]`
*   **Examples**:
    *   `kubectl cp my-pod:/var/log/app.log ./app.log` - Copy a log file from a pod to your local machine.
    *   `kubectl cp ./my-config.json my-pod:/etc/config/` - Copy a local configuration file into a pod.

#### `kubectl explain` – Get Documentation on the Fly

Never memorize every field in a YAML manifest again. This command pulls the documentation for any resource or field directly into your terminal.

*   **Basic Syntax**: `kubectl explain [RESOURCE_TYPE]`
*   **Examples**:
    *   `kubectl explain pod` - Display documentation for a pod.
    *   `kubectl explain pod.spec.containers` - Dive deep into a specific field of a resource.
    *   `kubectl explain deployment --recursive` - See the entire schema for a deployment.

### 💡 Pro-Tips for Power Users

*   **Aliases for Speed**: Save precious keystrokes by creating shell aliases.
    ```bash
    alias k='kubectl'                         # The most important alias
    alias kg='kubectl get'
    alias kgpo='kubectl get pods'
    alias kd='kubectl describe'
    alias krm='kubectl delete'
    alias kaf='kubectl apply -f'
    alias kex='kubectl exec -it'
    alias klo='kubectl logs'
    alias kctx='kubectl config use-context'
    alias kns='kubectl config set-context --current --namespace'
    ```
*   **Master the Debugging Workflow**: When troubleshooting, use this logical progression:
    1.  `kubectl get pods` to see the state.
    2.  `kubectl describe pod [POD_NAME]` to check for events or errors.
    3.  `kubectl logs [POD_NAME]` to see the application's output.
    4.  `kubectl exec -it [POD_NAME] -- /bin/sh` to investigate the container itself.
*   **Embrace Declarative Management**: As a best practice, prefer `kubectl apply -f` over imperative commands like `kubectl run` or `kubectl create`. This ensures your cluster's state is always version-controlled and repeatable.
*   **Use `--dry-run` for Safety**: Before applying any changes, especially destructive ones, use `--dry-run=client -o yaml` to preview what will happen. This is a great way to generate YAML templates on the fly.
    ```bash
    # Generate a deployment YAML file without actually creating it
    kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > nginx-deploy.yaml
    ```
*   **Get Comfortable with Output Formatting**: Use the `-o` flag to tailor your output.
    *   `-o wide` for more details.
    *   `-o yaml` or `-o json` to get the full object definition.
    *   `-o name` to output only the resource names (useful for scripting).

### 📝 Cheat Sheet for Quick Reference

For a one-page summary you can keep on your desktop, here's a quick-reference of the most essential commands:

| Command | Description | Example |
| :--- | :--- | :--- |
| `kubectl get pods` | List all pods in the current namespace. | `kubectl get pods -o wide` |
| `kubectl get all` | List all common resources in a namespace. | `kubectl get all -n my-namespace` |
| `kubectl describe pod <pod>` | Show detailed information about a pod. | `kubectl describe pod nginx-pod` |
| `kubectl logs <pod>` | View logs from a container in a pod. | `kubectl logs -f my-app-pod` |
| `kubectl exec -it <pod> -- <cmd>` | Execute a command inside a running container. | `kubectl exec -it my-pod -- /bin/sh` |
| `kubectl apply -f <file>` | Create or update resources from a YAML/JSON file. | `kubectl apply -f deployment.yaml` |
| `kubectl delete pod <pod>` | Delete a specific pod. | `kubectl delete pod my-pod` |
| `kubectl scale deployment <name> --replicas=<n>` | Scale a deployment to a specific number of replicas. | `kubectl scale deploy my-app --replicas=5` |
| `kubectl rollout restart deployment/<name>` | Perform a rolling restart of all pods in a deployment. | `kubectl rollout restart deploy/my-app` |
| `kubectl get nodes` | List all nodes in the cluster. | `kubectl get nodes` |
| `kubectl top pods` | Show real-time CPU and memory usage per pod. | `kubectl top pods -A` |
| `kubectl port-forward <pod> <local>:<remote>` | Forward a local port to a port on a pod. | `kubectl port-forward my-pod 8080:80` |
| `kubectl config use-context <context>` | Switch between clusters or environments. | `kubectl config use-context prod-cluster` |
| `kubectl cluster-info` | Display the addresses of the control plane and services. | `kubectl cluster-info` |
| `kubectl explain <resource>` | Display documentation for a resource or field. | `kubectl explain pod.spec.containers` |
