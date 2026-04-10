# Docker Commands: The Vital 20% You'll Use 80% of the Time

The Pareto principle applies beautifully to Docker: a small subset of commands handles the vast majority of daily tasks. This guide covers the essential Docker CLI commands that every developer, DevOps engineer, or system administrator should know by heart.

---

## 1. `docker run` – Create and start a container

**Purpose:** The Swiss Army knife of Docker. Creates a new container from an image and starts it. You'll use this constantly.

**Basic syntax:**
```bash
docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

**Common flags (the ones you'll actually use):**
| Flag | Purpose |
|------|---------|
| `-d, --detach` | Run in background (daemon mode) |
| `-it` | Interactive + TTY – for shell access |
| `--name` | Give container a custom name |
| `-p, --publish` | Map host port to container port (`host:container`) |
| `-v, --volume` | Mount a volume or host directory |
| `--rm` | Auto‑remove container when it stops |
| `-e, --env` | Set environment variable |
| `--network` | Attach to a specific network |
| `--restart` | Restart policy (e.g., `always`, `on-failure`) |

**Examples:**
```bash
# Run a simple nginx container, map port 8080 to 80
docker run -d -p 8080:80 --name web nginx

# Run an interactive Ubuntu shell, then delete container on exit
docker run -it --rm ubuntu bash

# Run with environment variables and a volume
docker run -d -e MYSQL_ROOT_PASSWORD=secret -v mysql_data:/var/lib/mysql mysql
```

**Notes:**
- If the image isn't local, Docker automatically pulls it.
- Without `-d`, the container runs in the foreground and blocks the terminal.
- `--rm` is a lifesaver for temporary containers – no manual cleanup.
- The `-it` combination is almost always used together for interactive processes.

---

## 2. `docker ps` – List containers

**Purpose:** Shows running containers. Add `-a` to see all containers (including stopped ones). This is your primary “what’s happening right now?” command.

**Basic syntax:**
```bash
docker ps [OPTIONS]
```

**Useful flags:**
| Flag | Purpose |
|------|---------|
| `-a, --all` | Show all containers (not just running) |
| `-q, --quiet` | Only display container IDs – great for scripting |
| `-s, --size` | Show container size |
| `--filter` | Filter output (e.g., `status=exited`, `name=web`) |
| `--format` | Custom output using Go templates |

**Examples:**
```bash
# See only running containers
docker ps

# See all containers, including stopped ones
docker ps -a

# Get just the IDs of all containers (running + stopped)
docker ps -aq

# Filter: show containers with status "exited"
docker ps -a --filter status=exited

# Pretty format with custom columns
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

**Notes:**
- The `CONTAINER ID` shown is a truncated hash – unique enough for most commands.
- `docker ps -a` is essential for debugging why a container stopped.
- Combine `-q` with other commands: `docker stop $(docker ps -q)` stops all running containers.

---

## 3. `docker images` – List local images

**Purpose:** Shows all Docker images you have downloaded or built locally. Like `docker ps` but for images.

**Basic syntax:**
```bash
docker images [OPTIONS] [REPOSITORY[:TAG]]
```

**Useful flags:**
| Flag | Purpose |
|------|---------|
| `-a, --all` | Show intermediate layers (all images) |
| `-q, --quiet` | Only show image IDs |
| `--filter` | Filter by label or reference |
| `--format` | Custom output |

**Examples:**
```bash
# List all images
docker images

# Show only image IDs
docker images -q

# Filter dangling (untagged) images
docker images --filter "dangling=true"
```

**Notes:**
- Image size is compressed size, not the size when running.
- Use `docker system df` to see disk usage by images, containers, and volumes.
- Remove unused images with `docker image prune`.

---

## 4. `docker pull` – Download an image from a registry

**Purpose:** Fetches an image from Docker Hub (or another registry) without running it. `docker run` does this automatically, but `pull` is useful for pre‑fetching or updating.

**Basic syntax:**
```bash
docker pull [OPTIONS] NAME[:TAG|@DIGEST]
```

**Examples:**
```bash
# Pull latest Ubuntu
docker pull ubuntu

# Pull specific version of Python
docker pull python:3.11-slim

# Pull from a private registry
docker pull myregistry.com/myapp:v2
```

**Notes:**
- If no tag is given, `:latest` is assumed – but `latest` is a moving target, so specify versions for reproducibility.
- Use `--platform` to pull for a different architecture (e.g., `linux/arm64`).
- Pulling does not create a container – it only caches the image layers.

---

## 5. `docker build` – Build an image from a Dockerfile

**Purpose:** The command that turns your `Dockerfile` into a runnable image. Central to any CI/CD pipeline.

**Basic syntax:**
```bash
docker build [OPTIONS] PATH | URL | -
```

**Common flags:**
| Flag | Purpose |
|------|---------|
| `-t, --tag` | Name and tag the image (e.g., `myapp:1.0`) |
| `-f, --file` | Specify a Dockerfile name (default is `./Dockerfile`) |
| `--no-cache` | Build without using cache |
| `--pull` | Always try to pull newer base images |
| `--build-arg` | Pass build‑time variables |
| `--target` | Build a specific stage in multi‑stage builds |
| `--progress` | Output style (`auto`, `plain`, `tty`) |

**Examples:**
```bash
# Build with tag from current directory's Dockerfile
docker build -t myapp:latest .

# Build using a custom Dockerfile name
docker build -f Dockerfile.prod -t myapp:prod .

# Build without cache and pass a build argument
docker build --no-cache --build-arg VERSION=1.2 -t myapp .

# Build a specific stage from a multi-stage Dockerfile
docker build --target builder -t myapp-builder .
```

**Notes:**
- The final `.` (context) is the directory sent to the Docker daemon. Keep it small (use `.dockerignore`).
- Each instruction in the Dockerfile creates a layer – order matters for caching.
- Use multi‑stage builds to keep final images small.

---

## 6. `docker exec` – Run a command in a running container

**Purpose:** Execute a process inside an already running container. Indispensable for debugging, inspecting logs, or running administrative tasks.

**Basic syntax:**
```bash
docker exec [OPTIONS] CONTAINER COMMAND [ARG...]
```

**Common flags:**
| Flag | Purpose |
|------|---------|
| `-it` | Interactive + TTY – needed for a shell |
| `-d, --detach` | Run command in background |
| `-e, --env` | Set environment variable |
| `-w, --workdir` | Working directory inside container |

**Examples:**
```bash
# Open a bash shell in a running container
docker exec -it my_container bash

# Run a one‑off command
docker exec my_container ls -la /app

# As root (if container runs as non‑root)
docker exec -it -u root my_container cat /etc/shadow

# Set working directory and run a script
docker exec -w /var/www my_container php artisan migrate
```

**Notes:**
- The container must be running (not paused or stopped).
- For Alpine‑based images, use `sh` instead of `bash`.
- `docker exec` is more efficient than `docker run` for interacting with existing containers.

---

## 7. `docker logs` – Fetch container logs

**Purpose:** Retrieves logs from a container (STDOUT + STDERR). Essential for monitoring and troubleshooting.

**Basic syntax:**
```bash
docker logs [OPTIONS] CONTAINER
```

**Useful flags:**
| Flag | Purpose |
|------|---------|
| `-f, --follow` | Follow log output (like `tail -f`) |
| `--tail` | Number of lines from the end (e.g., `--tail 100`) |
| `-t, --timestamps` | Show timestamps |
| `--since` | Show logs since a time (e.g., `2023-01-01T00:00:00`) |

**Examples:**
```bash
# See all logs
docker logs my_container

# Follow new logs in real time
docker logs -f my_container

# Last 50 lines with timestamps
docker logs --tail 50 -t my_container

# Logs from the last 10 minutes
docker logs --since 10m my_container
```

**Notes:**
- Logs are stored by the Docker daemon – they can consume disk space. Use `docker system prune` or configure log rotation in `/etc/docker/daemon.json`.
- For production, consider a dedicated logging driver (e.g., `json-file`, `fluentd`, `awslogs`).

---

## 8. `docker stop` / `docker start` – Control container lifecycle

**Purpose:** Stop a running container (sends SIGTERM, then SIGKILL after grace period) or start a stopped container.

**Basic syntax:**
```bash
docker stop [OPTIONS] CONTAINER [CONTAINER...]
docker start [OPTIONS] CONTAINER [CONTAINER...]
```

**Common options:**
- `-t, --time` for `stop` – seconds to wait before killing (default 10).

**Examples:**
```bash
# Stop a single container
docker stop web

# Stop all running containers
docker stop $(docker ps -q)

# Start a stopped container
docker start my_old_container

# Stop with a custom timeout of 20 seconds
docker stop -t 20 db
```

**Notes:**
- `docker restart` is a shortcut for `stop` then `start`.
- Stopped containers retain their file system and configuration – they are not deleted.
- Use `docker kill` (sends SIGKILL immediately) if a container ignores `stop`.

---

## 9. `docker rm` – Remove containers

**Purpose:** Deletes stopped containers (and their filesystem layers). You cannot remove a running container without `-f`.

**Basic syntax:**
```bash
docker rm [OPTIONS] CONTAINER [CONTAINER...]
```

**Flags:**
| Flag | Purpose |
|------|---------|
| `-f, --force` | Force remove a running container (kills it first) |
| `-v, --volumes` | Remove anonymous volumes associated with the container |
| `-l, --link` | Remove a container link (deprecated) |

**Examples:**
```bash
# Remove a single stopped container
docker rm my_container

# Force remove a running container
docker rm -f web

# Remove all stopped containers
docker container prune   # interactive version
# or non‑interactive:
docker rm $(docker ps -a -q)

# Remove all containers (running + stopped) – dangerous!
docker rm -f $(docker ps -aq)
```

**Notes:**
- `docker container prune` is safer – it only removes stopped containers.
- Volumes are not removed by default unless you use `-v`.
- Use `docker system prune -a` to clean everything (images, containers, networks, build cache).

---

## 10. `docker rmi` – Remove images

**Purpose:** Deletes one or more Docker images from your local storage.

**Basic syntax:**
```bash
docker rmi [OPTIONS] IMAGE [IMAGE...]
```

**Flags:**
| Flag | Purpose |
|------|---------|
| `-f, --force` | Force removal even if containers reference the image |
| `--no-prune` | Don't delete untagged parents |

**Examples:**
```bash
# Remove an image by ID or tag
docker rmi ubuntu:latest

# Remove all dangling (untagged) images
docker image prune

# Force remove an image used by a stopped container
docker rmi -f myapp:old

# Remove all unused images (interactive)
docker image prune -a
```

**Notes:**
- You cannot remove an image if a running container is using it (unless you use `-f`).
- Dangling images (`<none>:<none>`) are old, untagged layers – prune them regularly.
- Combine `docker rmi` with `docker images -q` for bulk removal.

---

## 11. `docker tag` – Add a tag to an image

**Purpose:** Creates an alias (name:tag) for an existing image. Crucial for pushing to registries like Docker Hub.

**Basic syntax:**
```bash
docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
```

**Example:**
```bash
# Tag local image for Docker Hub
docker tag myapp:latest myusername/myapp:v1.0

# Tag an image with a registry URL
docker tag myapp:latest myregistry.com/prod/myapp:1.2.3

# Re‑tag an existing tag
docker tag ubuntu:latest myubuntu:custom
```

**Notes:**
- Tagging does not copy the image; it just adds a new reference (like a symlink).
- The format for a full registry path is: `[registry-host[:port]/]repository[:tag]`
- Without a tag, `:latest` is implied.

---

## 12. `docker push` – Upload an image to a registry

**Purpose:** Uploads a locally tagged image to a remote registry (Docker Hub, private registry, etc.). Essential for sharing or deploying images.

**Basic syntax:**
```bash
docker push [OPTIONS] NAME[:TAG]
```

**Examples:**
```bash
# Push to Docker Hub (requires docker login first)
docker push myusername/myapp:v1.0

# Push all tags of an image
docker push myusername/myapp --all-tags

# Push to a private registry
docker push myregistry.com:5000/myapp:latest
```

**Notes:**
- You must `docker login` before pushing to a private registry.
- Only the layers missing on the remote registry are uploaded (incremental).
- Use `--disable-content-trust` for insecure registries (not recommended).

---

## 13. `docker cp` – Copy files between container and host

**Purpose:** Transfers files or directories to/from a container. A lifesaver for extracting logs, configs, or injecting temporary files.

**Basic syntax:**
```bash
docker cp [OPTIONS] CONTAINER:SRC_PATH DEST_PATH
docker cp [OPTIONS] SRC_PATH CONTAINER:DEST_PATH
```

**Example:**
```bash
# Copy from container to host
docker cp my_container:/app/logs/error.log ./error.log

# Copy from host to container
docker cp ./config.json my_container:/app/config.json

# Copy directory recursively (default behaviour)
docker cp my_container:/var/log ./container_logs
```

**Notes:**
- The container does not need to be running, but it must exist.
- For large files, consider using volumes or bind mounts instead.
- `cp` cannot copy special files (devices, FIFOs). Use `docker exec` with `tar` for advanced cases.

---

## 14. `docker commit` – Create an image from a container’s changes

**Purpose:** Saves a container’s current state (file system + metadata) as a new image. Useful for quick snapshots, but not recommended for production – use `Dockerfile` instead.

**Basic syntax:**
```bash
docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]
```

**Flags:**
| Flag | Purpose |
|------|---------|
| `-a, --author` | Author metadata |
| `-c, --change` | Apply Dockerfile instructions (e.g., `CMD`, `EXPOSE`) |
| `-m, --message` | Commit message |

**Example:**
```bash
# Commit a container after making changes
docker commit -m "Added python libs" my_container myapp:experimental

# Commit with custom author and command
docker commit -a "Jane Doe" -c 'CMD ["python", "app.py"]' my_container myapp:fixed
```

**Notes:**
- `docker commit` creates opaque, unreproducible images – avoid in CI/CD.
- Prefer writing a `Dockerfile` and using `docker build` for version control.
- It can be handy for one‑off forensic debugging.

---

## 15. `docker inspect` – View detailed low‑level information

**Purpose:** Returns JSON metadata about a container, image, volume, network, or other object. Indispensable for debugging, scripting, and understanding Docker internals.

**Basic syntax:**
```bash
docker inspect [OPTIONS] NAME|ID [NAME|ID...]
```

**Useful options:**
| Flag | Purpose |
|------|---------|
| `-f, --format` | Format output using Go templates (e.g., extract a single field) |
| `-s, --size` | Display total file size (for containers) |

**Examples:**
```bash
# Full JSON for a container
docker inspect my_container

# Get just the IP address of a container
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my_container

# Get the mount paths of a volume
docker inspect -f '{{.Mounts}}' my_container

# Inspect an image
docker inspect ubuntu:latest
```

**Notes:**
- The output is huge – pipe to `jq` for pretty JSON parsing: `docker inspect my_container | jq .`
- Common templates: `{{.State.Status}}`, `{{.Config.Image}}`, `{{.NetworkSettings.Ports}}`.
- Use `docker inspect --type` to disambiguate if names collide.

---

## 16. `docker system prune` – Clean up unused resources

**Purpose:** Removes all stopped containers, dangling images, unused networks, and build cache. Frees up disk space in one command.

**Basic syntax:**
```bash
docker system prune [OPTIONS]
```

**Flags:**
| Flag | Purpose |
|------|---------|
| `-a, --all` | Also remove unused images (not just dangling) |
| `-f, --force` | Do not prompt for confirmation |
| `--volumes` | Also prune unused volumes |

**Examples:**
```bash
# Standard cleanup (stops only dangling images, stopped containers, unused networks)
docker system prune

# Aggressive cleanup – remove all unused images, containers, networks, and build cache
docker system prune -a -f

# Also prune volumes (careful – data loss!)
docker system prune --volumes
```

**Notes:**
- `docker system df` shows disk usage before pruning.
- Volumes are not pruned by default because they often contain persistent data.
- Add to a weekly cron job to keep Docker from eating your disk.

---

## 17. `docker network` – Manage container networks

**Purpose:** Creates, inspects, and removes Docker networks. Containers on the same user‑defined network can communicate via names.

**Common subcommands:**
- `docker network ls` – list networks
- `docker network create` – create a new network
- `docker network connect` / `disconnect` – attach/detach a container to a network
- `docker network inspect` – detailed info
- `docker network rm` – delete a network

**Examples:**
```bash
# List networks
docker network ls

# Create a bridge network
docker network create --driver bridge mynet

# Run a container attached to that network
docker run -d --name app --network mynet nginx

# Connect an existing container to the network
docker network connect mynet another_container

# Inspect the network to see connected containers
docker network inspect mynet
```

**Notes:**
- The default `bridge` network does not provide automatic DNS resolution between containers.
- User‑defined bridge networks do provide automatic DNS – use them for multi‑container apps.
- For host networking (Linux only), use `--network host` – but be aware of port conflicts.

---

## 18. `docker volume` – Manage persistent data

**Purpose:** Creates, inspects, and removes volumes – Docker’s preferred mechanism for persisting data beyond container lifecycles.

**Common subcommands:**
- `docker volume ls` – list volumes
- `docker volume create` – create a volume
- `docker volume inspect` – show volume details
- `docker volume rm` – delete a volume
- `docker volume prune` – remove unused volumes

**Examples:**
```bash
# Create a named volume
docker volume create mydata

# Run a container using that volume
docker run -d -v mydata:/var/lib/mysql mysql

# List volumes
docker volume ls

# Remove all unused volumes
docker volume prune

# Inspect a volume
docker volume inspect mydata
```

**Notes:**
- Bind mounts (`-v /host/path:/container/path`) are also common but less portable than volumes.
- Volumes are managed by Docker and live under `/var/lib/docker/volumes/`.
- Use `docker run --rm -v mydata:/backup ubuntu tar czf /backup/data.tar.gz /data` for backups.

---

## 19. `docker-compose` – Multi‑container orchestration

**Note:** `docker-compose` is a separate tool (now integrated as `docker compose` plugin). It uses YAML files to define and run multi‑container apps.

**Purpose:** Defines services, networks, and volumes in a single `docker-compose.yml` file. Start everything with one command.

**Basic commands:**
```bash
docker compose up        # Start all services
docker compose down      # Stop and remove containers, networks
docker compose logs      # View logs
docker compose exec      # Run command in a service
docker compose ps        # List containers
docker compose build     # Build or rebuild services
docker compose pull      # Pull service images
```

**Example `docker-compose.yml`:**
```yaml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "8080:80"
    volumes:
      - ./src:/app
  redis:
    image: redis:alpine
```

**Typical workflow:**
```bash
# Start in background
docker compose up -d

# Tail logs
docker compose logs -f

# Run database migration
docker compose exec web python manage.py migrate

# Stop everything and remove volumes
docker compose down -v
```

**Notes:**
- `docker compose` (v2) is a Go plugin; `docker-compose` (v1) is legacy Python.
- Use `--profile` to selectively start services.
- For production, consider Kubernetes or Docker Swarm instead.

---

## 20. `docker login` / `docker logout` – Authenticate to registries

**Purpose:** Log in to Docker Hub or a private registry. Required before `docker push` to a private repository or to pull private images.

**Examples:**
```bash
# Interactive login to Docker Hub
docker login

# Login to a private registry
docker login myregistry.com:5000 -u myuser -p mypass

# Logout
docker logout
```

**Notes:**
- Credentials are stored in `~/.docker/config.json` (base64 encoded – not secure, but convenient).
- For CI/CD, use a personal access token (not your password) and pass it via `--password-stdin`.
- Environment variables `DOCKER_USER` and `DOCKER_PASSWORD` are not used by `docker login` directly – you must pipe them.

---

## Quick Reference Cheat Sheet

| Command | What it does |
|---------|---------------|
| `docker run` | Create + start container |
| `docker ps` | List containers |
| `docker images` | List images |
| `docker pull` | Download image |
| `docker build` | Build image from Dockerfile |
| `docker exec` | Run command in running container |
| `docker logs` | View container logs |
| `docker stop` / `start` | Stop / start container |
| `docker rm` | Delete container(s) |
| `docker rmi` | Delete image(s) |
| `docker tag` | Tag an image |
| `docker push` | Upload image to registry |
| `docker cp` | Copy files to/from container |
| `docker commit` | Snapshot container → image (avoid) |
| `docker inspect` | Get detailed JSON metadata |
| `docker system prune` | Clean up unused resources |
| `docker network` | Manage networks |
| `docker volume` | Manage volumes |
| `docker compose` | Multi‑container app control |
| `docker login` | Log into registry |

---

## Final Tips

- **Alias long commands:** `alias d='docker'`, `alias dcb='docker compose build'`, etc.
- **Use tab completion:** Docker CLI supports bash/zsh completion – install it.
- **Always tag images meaningfully** – never rely on `:latest` in production.
- **Prune regularly** – `docker system prune -a --volumes` once a week (but backup first).
- **Learn `docker inspect` + `jq`** – it unlocks deep debugging.
- **Prefer `docker compose` for local dev** – it saves immense amounts of typing.

	Master these commands, and you’ll handle 80% of daily Docker tasks efficiently. The remaining 20% of commands are for edge cases, advanced networking, or security hardening – you can look them up when needed.