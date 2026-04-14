# 📘 In-Depth Notes: Kubernetes Architecture (Student-Friendly & Memorable)

## 🧠 The Big Picture: A City Analogy

Think of a Kubernetes cluster as a **modern city** with a **central government** and many **residential buildings**.

| Kubernetes Component | City Analogy |
|----------------------|---------------|
| **Control Plane** | The **City Hall** (government, planning, decision-making) |
| **Worker Node** | A **Residential Building** (where actual people/apps live) |
| **etcd** | The **City Records Office** (blueprints, laws, current census) |
| **API Server** | The **City Reception Desk** (only way to talk to the government) |
| **Scheduler** | The **City Planner** (decides which building gets which resident) |
| **Controller Manager** | The **Inspectors & Maintenance Crew** (ensure city matches plans) |
| **Kubelet** | The **Building Manager** (ensures each apartment is occupied as told) |
| **Kube-proxy** | The **Mailroom & Traffic Police** (routes visitors to correct apartment) |
| **Container Runtime** | The **Apartment Construction Crew** (actually builds the rooms) |
| **Pod** | An **Apartment** (one or more rooms/containers sharing same space) |

Keep this analogy in your back pocket – it will make every component click.

---

## 🏛️ Part 1: Control Plane (The Brain / City Hall)

The Control Plane runs on **master nodes** (usually 3 or 5 for high availability). It makes global decisions and detects/responds to cluster events.

### 1. API Server (`kube-apiserver`)
- **What it is**: The front door, the only component that talks to etcd. All internal and external communication goes through it (REST API).
- **Memorable phrase**: *"Nobody gets in or out without going through the reception desk."*
- **Key facts**:
  - It's stateless (doesn't store data itself – just passes to etcd).
  - All `kubectl` commands hit the API server.
  - Other components (scheduler, controllers, kubelet) constantly watch it for changes.
  - Authentication, authorization, admission control happen here.

### 2. etcd
- **What it is**: A distributed, consistent key-value store – the **source of truth** for the entire cluster.
- **Memorable phrase**: *"The cluster's memory – lose it, and you lose everything."*
- **Key facts**:
  - Stores entire cluster state: nodes, pods, configs, secrets, deployments, etc.
  - Only the API server can read/write to etcd (for security).
  - Uses **Raft consensus algorithm** – requires majority (quorum) to write.
  - **Back it up!** Without etcd, you cannot recover your cluster.

### 3. Scheduler (`kube-scheduler`)
- **What it is**: Assigns newly created Pods to a suitable Worker Node.
- **Memorable phrase**: *"The cosmic matchmaker for Pods and Nodes."*
- **How it decides**:
  - **Filtering**: Excludes nodes that don't meet requirements (e.g., insufficient CPU, taints, port conflicts).
  - **Scoring**: Ranks remaining nodes (e.g., prefer least loaded, affinity rules).
  - **Binding**: Picks the highest score and tells API server to bind Pod to that node.
- **Note**: It only decides **where** the Pod should run – it doesn't actually start it (that's the kubelet's job).

### 4. Controller Manager (`kube-controller-manager`)
- **What it is**: A collection of **controllers** – each is a control loop that watches the cluster and makes adjustments.
- **Memorable phrase**: *"The army of tiny bots that keep the world in order."*
- **Important controllers**:
  - **Node Controller**: Detects when a node dies and evicts its Pods.
  - **Deployment Controller**: Manages rolling updates and rollbacks.
  - **ReplicaSet Controller**: Ensures the right number of Pod replicas are running.
  - **Service Account & Token Controllers**: Manage API tokens for Pods.
  - **EndpointSlice Controller**: Keeps Service endpoints updated.
- **How they work** (the **Reconciliation Loop** – you must memorize this):
  ```
  desired state (from etcd)  vs  actual state (from observers)
  if different → take action to make actual = desired
  then repeat forever
  ```

---

## 🏗️ Part 2: Worker Nodes (The Muscle / Residential Buildings)

Worker nodes are where your application containers actually run. They can be VMs or bare metal.

### 1. Kubelet
- **What it is**: The **primary node agent** that runs on every worker node.
- **Memorable phrase**: *"The building manager who takes orders from City Hall and makes sure every apartment is occupied."*
- **Responsibilities**:
  - Registers the node with the API server.
  - Watches the API server for Pods assigned to its node.
  - Talks to the container runtime to start/stop containers.
  - Periodically reports node and Pod status back to the control plane.
  - Runs **liveness**, **readiness**, and **startup probes** (health checks).
- **Note**: If the kubelet dies, the node becomes `NotReady` and Pods will be rescheduled elsewhere after a timeout.

### 2. Container Runtime
- **What it is**: The software that actually **runs containers** (pulls images, starts/stops containers).
- **Memorable phrase**: *"The construction crew that builds the apartments according to blueprints."*
- **Examples**: containerd (most common), CRI-O, Docker (deprecated as runtime but still works via cri-dockerd).
- **CRI** (Container Runtime Interface): Standardized API so Kubernetes can swap runtimes without changing kubelet.

### 3. Kube-proxy
- **What it is**: A network proxy that runs on each node. Implements the **Service** concept.
- **Memorable phrase**: *"The traffic cop and mailroom – knows how to deliver packets to the right Pod."*
- **How it works**:
  - Watches the API server for Services and EndpointSlices.
  - On each node, sets up iptables/IPVS rules to redirect traffic destined for a Service's virtual IP to an actual Pod IP.
  - Provides **load balancing** across all Pods belonging to a Service.
- **Modes**: `iptables` (default, random), `ipvs` (more efficient, supports session affinity), `userspace` (legacy).

---

## 🧩 Part 3: Fundamental Objects (The "What")

These are the resources you define in YAML and submit to the API server.

### Pod (The Atomic Unit)
- **Definition**: The smallest deployable object – a group of one or more containers that share:
  - Network namespace (same IP, localhost)
  - Storage volumes
  - Lifecycle (started/stopped together)
- **Memorable phrase**: *"An apartment with one or more rooms that share a front door and a closet."*
- **Why multiple containers in a Pod?** Sidecar pattern (e.g., a main container + a logging agent + a proxy). They communicate via localhost.
- **Pods are ephemeral** – they can die and be replaced at any time. Never "fix" a Pod – just replace it.

### Service (Stable Network Endpoint)
- **Problem it solves**: Pods come and go (new IP each time). Services provide a fixed IP and DNS name that lives independently of Pods.
- **Memorable phrase**: *"A permanent telephone number for a rotating group of employees."*
- **Types**:
  - `ClusterIP`: Internal only (default).
  - `NodePort`: Exposes on a static port on each node (30000-32767).
  - `LoadBalancer`: Provisions a cloud load balancer (AWS ELB, GCP L7).
  - `ExternalName`: Returns a CNAME record.
- **Selector**: Labels that decide which Pods receive the traffic.

### Deployment (Stateless App Manager)
- **Definition**: A declarative way to manage rolling updates, rollbacks, and scaling of Pods.
- **Memorable phrase**: *"A robot that says: 'I want 3 identical waiters, and if one falls, replace it. Also, upgrade them one by one without closing the restaurant.'"*
- **Under the hood**: Creates a **ReplicaSet**, which manages the Pods.

### ConfigMap & Secret
- **ConfigMap**: Non-confidential configuration (e.g., `app.properties`, environment variables).
- **Secret**: Base64-encoded sensitive data (passwords, tokens, keys). Actually stored encrypted if etcd encryption is enabled.
- **Memorable phrase**: *"The post-it note on the fridge vs. the locked safe."*

---

## 🔁 Part 4: The Reconciliation Loop – The Heart of Kubernetes

This is the single most important concept to understand. Once you get this, everything else makes sense.

```text
      ┌─────────────────────────────────────────────────┐
      │            DESIRED STATE (in etcd)              │
      │   "I want 3 replicas of nginx:1.20 running"    │
      └───────────────────┬─────────────────────────────┘
                          │
                          ▼
      ┌─────────────────────────────────────────────────┐
      │               CONTROLLER LOOP                    │
      │  (Deployment Controller watches & compares)     │
      └───────────────────┬─────────────────────────────┘
                          │
            ┌─────────────┴─────────────┐
            │                           │
            ▼                           ▼
   ┌────────────────┐          ┌────────────────┐
   │  ACTUAL STATE  │          │  ACTUAL STATE  │
   │  (observed)    │  vs       │  (desired)     │
   │  "2 replicas"  │          │  "3 replicas"  │
   └────────────────┘          └────────────────┘
                          │
                          │ difference = 1 missing replica
                          ▼
      ┌─────────────────────────────────────────────────┐
      │      ACTION: Tell Scheduler to create 1 new Pod │
      └─────────────────────────────────────────────────┘
                          │
                          ▼
      ┌─────────────────────────────────────────────────┐
      │            NEW ACTUAL STATE = DESIRED           │
      │              Loop repeats forever               │
      └─────────────────────────────────────────────────┘
```

**Memory trick**: Think of a thermostat. You set desired temperature (72°F). The thermostat reads actual temperature. If it's 70°F, it turns on the heater. Once 72°F, it stops. Then continues monitoring. Kubernetes does this for everything: Pods, replicas, nodes, endpoints.

---

## 🕹️ Part 5: How Components Talk to Each Other

Only the **API server** talks to etcd. All other components watch/listen to the API server.

```text
                    ┌─────────────┐
                    │   etcd      │
                    └──────▲──────┘
                           │ (read/write)
                    ┌──────┴──────┐
                    │ API Server  │◄─────── kubectl, dashboard
                    └──────▲──────┘
                           │ (watch)
         ┌─────────────────┼─────────────────┐
         │                 │                 │
    ┌────┴────┐       ┌────┴────┐       ┌────┴────┐
    │Scheduler│       │Controller│       │ Kubelet │
    └─────────┘       │ Manager │       └─────────┘
                      └─────────┘
```

- **All communication** is secured via TLS (certificates).
- **Watch mechanism**: Instead of polling, components open a long-lived connection to API server and get notified of changes instantly (efficient).

---

## 🧪 Part 6: A Concrete Example – Deploying Nginx

Let's trace what happens when you run:

```bash
kubectl create deployment nginx --image=nginx --replicas=3
```

| Step | Component | Action |
|------|-----------|--------|
| 1 | `kubectl` | Sends REST POST to API Server with Deployment spec. |
| 2 | API Server | Authenticates, authorizes, validates, stores Deployment in etcd. |
| 3 | Deployment Controller (inside Controller Manager) | Watches for new Deployments. Sees the new one, notices `replicas=3`, and creates a ReplicaSet object (stored in etcd). |
| 4 | ReplicaSet Controller | Watches for new ReplicaSets. Sees the RS, notices `replicas=3` but 0 Pods exist → creates 3 Pod objects (stored in etcd). |
| 5 | Scheduler | Watches for unscheduled Pods (no `nodeName`). For each Pod, picks a suitable node and writes the node name to the Pod object. |
| 6 | Kubelet (on each node) | Watches for Pods assigned to its node. Finds a Pod, tells container runtime to pull image and start containers. |
| 7 | Kubelet | Reports Pod status back to API server. |
| 8 | ReplicaSet Controller | Sees Pods are Running → happy. Deployment Controller sees RS is satisfied → happy. |

All of this happens automatically – no human intervention.

---

## 📝 Part 7: Quick Reference Card (Memorize These)

| Component | One‑line Job | Analogy |
|-----------|--------------|----------|
| **API Server** | "The only way in/out" | Reception desk |
| **etcd** | "Cluster memory" | Records office |
| **Scheduler** | "Assigns Pods to Nodes" | City planner |
| **Controller Manager** | "Runs control loops" | Inspectors |
| **Kubelet** | "Runs Pods on a node" | Building manager |
| **Container Runtime** | "Starts/stops containers" | Construction crew |
| **Kube-proxy** | "Routes network traffic to Pods" | Mailroom + traffic cop |
| **Pod** | "One or more containers" | Apartment |
| **Service** | "Stable IP for Pods" | Permanent phone number |
| **Deployment** | "Manages replicas & updates" | Robot manager |

---

## 🎓 Final Exam for Yourself

Ask these questions and see if you can answer without looking:

1.  What happens to a Pod if the kubelet on its node dies?
2.  Which component talks directly to etcd?
3.  How does a Service know which Pods to send traffic to?
4.  What's the difference between a Pod and a Deployment?
5.  If you want a container to run a diagnostic tool alongside your app container, should you put them in the same Pod or different Pods? Why?
6.  The scheduler assigns a Pod to a node – does it also start the container?
7.  True or false: The controller manager and scheduler both need to run on every worker node.
8.  What protocol does etcd use to maintain consistency across multiple master nodes?

**Answers** (cover then check):
1. The control plane (Node Controller) will mark the node `NotReady` after ~40 seconds, then evict Pods and reschedule them on healthy nodes.
2. Only the API server.
3. Via label selectors defined in the Service spec.
4. A Deployment manages a ReplicaSet of identical Pods and provides rolling updates. A Pod is a single instance.
5. Same Pod – they share network namespace (can talk via localhost) and storage, and have coordinated lifecycle.
6. No – scheduler only assigns; kubelet starts the container.
7. False – they run only on control plane nodes (masters).
8. Raft consensus algorithm.

---

