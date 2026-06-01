---
title: "DevOps & Cloud Practical Exam Cheat Sheet"
tags:
  - devops
  - cloud
  - docker
  - git
  - jenkins
  - kubernetes
  - minikube
  - practical-exam
created: 2026-05-31
type: study-note
---

# DevOps & Cloud Practical Exam Cheat Sheet

This guide contains copy-pasteable templates, CLI command references, and step-by-step procedures for the 4 core areas of your DevOps practical exam: **Docker**, **Git (Merging/Rebasing)**, **Jenkins Pipelines**, and **Kubernetes/Minikube**.

---

## 🐋 1. Docker: Dockerfile & Docker Compose

### A. Production Multi-Stage `Dockerfile`
Multi-stage builds reduce image size by compiling code in a heavy build environment and copying only the compiled artifacts into a lightweight production runtime image.

Below is a template for a **Node.js** application. (Easily adaptable to Python/Java).

```dockerfile
# ==========================================
# Stage 1: Build & Compile Environment
# ==========================================
FROM node:18-alpine AS builder

# Set working directory inside container
WORKDIR /usr/src/app

# Copy package descriptors first (exploits Docker layer caching)
COPY package*.json ./

# Install dependencies (including devDependencies for testing/compiling)
RUN npm install

# Copy the rest of the application source code
COPY . .

# Run build scripts (e.g. compiling TypeScript to JS, minifying)
RUN npm run build

# Prune node_modules to keep only production dependencies
RUN npm prune --production


# ==========================================
# Stage 2: Production Execution Environment
# ==========================================
FROM node:18-alpine AS runner

# Set metadata environment variables
ENV NODE_ENV=production
WORKDIR /usr/src/app

# Copy compiled build directory and production node_modules from Stage 1
COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/package*.json ./

# Create a non-root system user for security (containers should not run as root)
RUN addgroup -g 1001 -S nodejs && \
    adduser -u 1001 -S nodeuser -G nodejs
USER nodeuser

# Document the port the container listens on at runtime
EXPOSE 3000

# Set health check to verify container status
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => { if(r.statusCode === 200) process.exit(0); else process.exit(1); })"

# Run the application
CMD ["node", "dist/index.js"]
```

---

### B. Multi-Container `docker-compose.yml`
Coordinates an application server (`app`) and a database (`db`) with environment files, persistent volumes, custom networks, and health-based startup order.

```yaml
version: "3.8"

services:
  db:
    image: postgres:15-alpine
    container_name: production-db
    restart: unless-stopped
    # Environment credentials (kept in separate .env file in production)
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: supersecretpassword
      POSTGRES_DB: app_database
    ports:
      - "5432:5432"
    # Mount persistent named volume
    volumes:
      - pgdata:/var/lib/postgresql/data
    # Custom bridge network for isolation
    networks:
      - app-network
    # Health check to block dependent containers until DB is ready to accept connections
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U admin -d app_database"]
      interval: 10s
      timeout: 5s
      retries: 5

  app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: production-app
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgres://admin:supersecretpassword@db:5432/app_database
      PORT: 3000
    # Mount host directory into container (bind mount) for live-reloads during development
    volumes:
      - .:/usr/src/app
      - /usr/src/app/node_modules
    networks:
      - app-network
    # Ensure database is healthy before booting the application
    depends_on:
      db:
        condition: service_healthy

volumes:
  pgdata: # Named persistent volume declared

networks:
  app-network:
    driver: bridge # Custom isolated network bridge
```

---

## 🐙 2. Git: Comprehensive Version Control Reference

Git tracks files in three main areas: the **Working Directory** (unsaved edits), the **Staging Area/Index** (prepared edits), and the **Local Repository** (committed history). Below are the essential commands and workflows required for both practical exams and day-to-day operations.

---

### A. Repository Setup & Branching

#### 1. Repository Initialization & Cloning
* Initialize a new Git repository in the current directory:
  ```bash
  git init
  ```
* Clone a remote repository over HTTPS or SSH:
  ```bash
  git clone https://github.com/username/repository.git
  ```
* Perform a **Shallow Clone** (downloads only the latest $N$ commits to save bandwidth and speed up build pipelines):
  ```bash
  git clone --depth 1 https://github.com/username/repository.git
  ```

#### 2. Branch Management (`git branch`)
Branches are lightweight pointers to specific commits.
* List all local branches (active branch is marked with `*`):
  ```bash
  git branch
  ```
* List all local and remote-tracking branches:
  ```bash
  git branch -a
  ```
* Create a new branch (without switching to it):
  ```bash
  git branch feature-name
  ```
* Delete a branch locally (fails if the branch contains unmerged changes):
  ```bash
  git branch -d branch-name
  ```
* Force delete a branch locally (discarding all unmerged changes):
  ```bash
  git branch -D branch-name
  ```
* Rename the current branch:
  ```bash
  git branch -m new-branch-name
  ```
* Delete a remote branch on the GitHub origin server:
  ```bash
  git push origin --delete branch-name
  ```

#### 3. Switching Branches (`git checkout` vs. `git switch`)
In Git 2.23+, `git switch` was introduced to separate branch switching logic from file recovery (which is handled by `git restore`).
* Switch to an existing branch:
  ```bash
  git switch branch-name
  # Or legacy: git checkout branch-name
  ```
* Create a new branch and switch to it immediately:
  ```bash
  git switch -c new-branch-name
  # Or legacy: git checkout -b new-branch-name
  ```
* Switch back to the previous branch you were on:
  ```bash
  git switch -
  # Or legacy: git checkout -
  ```

---

### B. Staging, Committing & Undoing Changes

#### 1. Checking Status & Visualizing Changes
* Check status of files (untracked, modified, staged):
  ```bash
  git status
  ```
* Short status view (useful for scripting):
  ```bash
  git status -s
  ```
* Show differences between working directory and staging area:
  ```bash
  git diff
  ```
* Show differences between staged changes and the last commit:
  ```bash
  git diff --staged
  # Or: git diff --cached
  ```

#### 2. Staging Changes (`git add`)
* Stage a specific file:
  ```bash
  git add filename.txt
  ```
* Stage all changes (new, modified, and deleted files):
  ```bash
  git add .
  # Or: git add -A
  ```
* **Interactive Patching** (opens an interactive prompt to stage specific chunks/lines of a file rather than the whole file):
  ```bash
  git add -p filename.txt
  # Key options: 'y' (stage hunk), 'n' (skip hunk), 's' (split hunk into smaller pieces)
  ```

#### 3. Committing Changes (`git commit`)
* Commit staged changes with a commit message:
  ```bash
  git commit -m "feat: implement database connector"
  ```
* Stage and commit all modified files in a single step (does not stage new untracked files):
  ```bash
  git commit -am "fix: correct authentication routing typo"
  ```
* **Amend the last commit** (adds newly staged changes to the last commit and/or lets you rewrite the last commit message):
  ```bash
  git commit --amend -m "feat: implement DB connector with connection pooling"
  # WARNING: Only use this if the commit hasn't been pushed to a remote branch.
  ```

#### 4. Restoring & Cleaning Files
* Discard changes in a modified file (reverts it back to the state in the index or HEAD):
  ```bash
  git restore filename.txt
  # Or legacy: git checkout -- filename.txt
  ```
* Unstage a staged file (moves it back from staging area to working directory modifications):
  ```bash
  git restore --staged filename.txt
  # Or legacy: git reset HEAD filename.txt
  ```
* Remove untracked files and directories from the working directory:
  ```bash
  # Dry-run (lists what would be deleted without actually deleting)
  git clean -fdn
  # Execute clean (f = force, d = directories)
  git clean -fd
  ```

---

### C. Stashing (Temporary Work Preservation)
Stashing takes your modified working directory files and staged changes, saves them on a local stack, and resets your working directory to clean HEAD state.

#### 1. Push to Stash
* Stash modifications (untracked files are ignored by default):
  ```bash
  git stash
  # Or with a descriptive message:
  git stash push -m "work-in-progress: checkout schema logic"
  ```
* Include untracked files in the stash:
  ```bash
  git stash -u
  # Or: git stash --include-untracked
  ```
* Stash all files including ignored files:
  ```bash
  git stash -a
  # Or: git stash --all
  ```

#### 2. Inspecting the Stash Stack
* List all stashed states:
  ```bash
  git stash list
  # Format output: stash@{0}: WIP on main: a17a326 feat: base setup
  ```
* Show the diff changes inside a specific stash:
  ```bash
  git stash show -p stash@{0}
  ```

#### 3. Applying Stashed Work
* Apply the latest stash (`stash@{0}`) and **remove it** from the stack:
  ```bash
  git stash pop
  ```
* Apply a specific stash and **keep it** on the stack for safety:
  ```bash
  git stash apply stash@{1}
  ```

#### 4. Dropping & Cleaning Stash
* Delete a specific stash from the stack:
  ```bash
  git stash drop stash@{0}
  ```
* Clear the entire stash stack:
  ```bash
  git stash clear
  ```

---

### D. Merging, Rebasing & Cherry-Picking

#### 1. Merging Branches (`git merge`)
Combines work from two branches.
* **Fast-Forward Merge**: If the target branch has no new commits since the source branch split off, Git simply moves the target pointer forward to the source branch's last commit. No new commit is created.
  ```bash
  git checkout main
  git merge feature-branch
  ```
* **Recursive 3-way Merge (Merge Commit)**: If both branches have diverged, Git combines the histories and creates a new **Merge Commit** tying them together.
  * Force a merge commit even if a fast-forward is possible (useful to maintain clear historical branch boundaries):
    ```bash
    git merge --no-ff feature-branch
    ```
* **Aborting a Merge**: If a merge conflict occurs and you want to cancel the merge and return your working directory to its pre-merge state:
  ```bash
  git merge --abort
  ```

#### 2. Rebasing (`git rebase`)
Rebasing reapplies commits from your current branch on top of another base branch. It rewrites commit hashes to create a clean, linear history.

```
Diverged History:
      A---B---C (main)
           \
            D---E (feature)

After "git rebase main" on feature branch:
      A---B---C (main)
               \
                D'---E' (feature)
```

* Rebase the active branch on top of `main`:
  ```bash
  git switch feature-branch
  git rebase main
  ```
* **Handling Conflicts During Rebase**:
  1. Git will pause on the first conflicting commit.
  2. Resolve the conflicts manually in the files.
  3. Stage the files: `git add <file>`.
  4. Continue rebase: `git rebase --continue`.
  5. (Repeat until done).
  * If you get stuck and want to cancel the rebase completely:
    ```bash
    git rebase --abort
    ```
* **Interactive Rebasing (`git rebase -i`)**:
  Allows restructuring, squashing, reordering, or deleting commits.
  ```bash
  # Rebase the last 4 commits interactively
  git rebase -i HEAD~4
  ```
  In the editor list, change the action keyword before each commit:
  * `pick` (or `p`): Use the commit as is.
  * `reword` (or `r`): Use the commit, but edit the commit message.
  * `squash` (or `s`): Meld this commit's changes into the *previous* commit above it.
  * `drop` (or `d`): Remove the commit entirely.

#### 3. Cherry-Picking (`git cherry-pick`)
Applies the changes introduced by a specific commit from another branch onto your active branch as a new commit.
* Cherry-pick a specific commit:
  ```bash
  git cherry-pick <commit-hash>
  ```
* Abort cherry-pick if conflicts occur:
  ```bash
  git cherry-pick --abort
  ```

---

### E. Undoing Commits & History Rewriting

#### 1. Resetting History (`git reset`)
Resets the current HEAD branch pointer to a specified commit. It is used to undo commits locally.

> [!CAUTION]
> `git reset` alters history. Never use it on shared/public remote branches, as it will cause synchronization issues for others.

* **Soft Reset (`--soft`)**:
  * **Behavior**: Moves the HEAD branch pointer back, but **preserves all changes** in your Staging Area (index) and Working Directory. No code changes are lost.
  * *Use case*: You committed too early, want to undo the commit, and restructure/re-stage the changes.
  ```bash
  git reset --soft HEAD~1
  ```
* **Mixed Reset (`--mixed` - Default)**:
  * **Behavior**: Moves the HEAD branch pointer back and **unstages changes** (clears index), but keeps changes in your working directory.
  * *Use case*: Undo the commit and unstage everything, but keep your edits to work on them.
  ```bash
  git reset HEAD~1
  # Equivalent to: git reset --mixed HEAD~1
  ```
* **Hard Reset (`--hard`)**:
  * **Behavior**: Moves HEAD, clears the staging index, and **permanently deletes all changes** in the working directory. Any unsaved edits and commits are lost forever.
  * *Use case*: Completely discard the last commit and all associated file changes.
  ```bash
  git reset --hard HEAD~1
  ```

#### 2. Reverting Commits (`git revert`)
* **Behavior**: Creates a **new commit** that introduces the exact opposite changes of a past commit. It does not rewrite history; it appends to it.
* **Use Case**: Safe to use on public/shared remote branches. If a bug goes to production, you run `git revert <bad-commit-hash>` to commit a fix that undoes the changes.
  ```bash
  git revert <bad-commit-hash>
  ```

---

### F. Remote Repository Synchronization

#### 1. Managing Remotes
* Show remote repository names and URLs:
  ```bash
  git remote -v
  ```
* Add a new remote connection reference:
  ```bash
  git remote add origin https://github.com/username/repo.git
  ```

#### 2. Remote Updates (`git fetch` vs. `git pull`)
* **Fetch**: Downloads new branches, tags, and commits from the remote repository to your local tracking database (e.g. into `origin/main`), but does not modify your working directory files.
  ```bash
  git fetch origin
  ```
* **Pull**: Executes a `git fetch` followed by a `git merge` to integrate remote changes directly into your active branch.
  ```bash
  git pull origin main
  ```
* **Pull with Rebase** (Recommended to avoid merge commits when pulling team updates):
  ```bash
  git pull --rebase origin main
  ```

#### 3. Uploading Changes (`git push`)
* Push your branch to the remote origin server (setting upstream tracking):
  ```bash
  git push -u origin feature-branch
  ```
* **Force Pushing**: Required after rebasing or resetting commits that were already pushed.
  * **DANGEROUS FORCE** (overwrites remote history blindly, even if others pushed in the meantime):
    ```bash
    git push --force
    # Or: git push -f
    ```
  * **SAFE FORCE** (only pushes if no one else has pushed updates to the remote branch since your last fetch):
    ```bash
    git push --force-with-lease
    ```

#### 4. Formatting Logs
* Print a beautiful, compact commit graph:
  ```bash
  git log --graph --oneline --decorate --all
  ```

---

## 👷 3. Jenkins: Declarative Pipelines

Below is a complete, production-ready Declarative `Jenkinsfile` pipeline executing stages sequentially inside a Docker agent.

```groovy
pipeline {
    // Specify where the pipeline runs (any available agent/runner)
    agent any

    // Define environment variables accessible in all stages
    environment {
        DOCKER_IMAGE_NAME = "my-web-app"
        DOCKER_REGISTRY   = "dockerhub-username"
        DOCKER_CRED_ID    = "docker-hub-credentials"
    }

    // Configure pipeline parameters (user input before build starts)
    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['staging', 'production'], description: 'Target environment')
        booleanParam(name: 'RUN_TESTS', defaultValue: true, description: 'Skip or execute tests')
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Fetching code from repository..."
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "Installing package modules..."
                // Use clean install to verify package-lock integrity
                sh 'npm ci'
            }
        }

        stage('Run Tests') {
            when {
                expression { return params.RUN_TESTS }
            }
            steps {
                echo "Executing unit tests..."
                sh 'npm test'
            }
        }

        stage('Docker Build & Package') {
            steps {
                echo "Building Docker image: ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ."
                sh "docker tag ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:latest"
            }
        }

        stage('Push to Registry') {
            steps {
                echo "Logging into Docker Hub and pushing image..."
                // Safely handles login credentials without printing them in logs
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CRED_ID}", 
                                                 usernameVariable: 'DOCKER_USER', 
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                    sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                    sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                echo "Deploying to target environment: ${params.DEPLOY_ENV}"
                script {
                    if (params.DEPLOY_ENV == 'production') {
                        echo "Deploying to production server..."
                        // Command to trigger deployment (Ansible, SSH script, or kubectl)
                        sh 'ssh prod-server "docker compose pull && docker compose up -d"'
                    } else {
                        echo "Deploying to staging environment..."
                        sh 'ssh staging-server "docker compose pull && docker compose up -d"'
                    }
                }
            }
        }
    }

    // Run actions based on final build statuses
    post {
        always {
            echo "Cleaning up workspace..."
            cleanWs()
        }
        success {
            echo "Pipeline completed successfully!"
            // Send success email/Slack alert
        }
        failure {
            echo "Pipeline failed on Stage! Notifying development team..."
            // Send failure alerts
        }
    }
}
```

---

## ☸️ 4. Kubernetes: Pods, Deployments & Services in Minikube

### A. Minikube CLI Quickstart Commands
```bash
# Start Minikube cluster
minikube start --driver=docker

# Enable the dashboard (GUI interface)
minikube dashboard

# Direct your local Docker CLI to use Minikube's Docker daemon
# (Allows you to build images inside minikube directly without pushing to Docker Hub)
eval $(minikube docker-env)

# Expose a service directly to your host browser
minikube service my-app-service
```

---

### B. Core YAML Definitions

#### 1. Pod Configuration (`pod.yaml`)
A single, basic container instance.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app-pod
  labels:
    app: my-app
    tier: frontend
spec:
  containers:
    - name: web-container
      image: nginx:alpine
      ports:
        - containerPort: 80
      resources:
        limits:
          memory: "128Mi"
          cpu: "500m"
        requests:
          memory: "64Mi"
          cpu: "250m"
```

#### 2. Deployment Configuration (`deployment.yaml`)
Manages rolling updates, replicas, self-healing, and scaling.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-deployment
  labels:
    app: my-app
spec:
  replicas: 3 # Scale to 3 running pod instances
  selector:
    matchLabels:
      app: my-app # Must match the template labels below
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: web-app
          image: nginx:alpine
          ports:
            - containerPort: 80
          # Define resource allocations
          resources:
            limits:
              memory: "256Mi"
              cpu: "500m"
            requests:
              memory: "128Mi"
              cpu: "250m"
```

#### 3. Service Configuration (`service.yaml`)
Exposes the Pods to network traffic (internally or externally).

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  type: NodePort # Exposes service externally using Minikube IP
  selector:
    app: my-app # Routes traffic to Pods with this label
  ports:
    - protocol: TCP
      port: 80 # Service port inside cluster
      targetPort: 80 # Pod port to target
      nodePort: 30007 # External port on Minikube node (range 30000-32767)
```

---

### C. Kubectl CLI Practical Walkthrough

Use these commands to apply, verify, debug, and expose your configurations:

```bash
# 1. Apply configurations
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# 2. Check cluster status
kubectl get pods
kubectl get deployments
kubectl get services

# 3. Scale deployment manually
kubectl scale deployment my-app-deployment --replicas=5

# 4. Debugging & Logs
# Get logs of a specific pod
kubectl logs my-app-pod
# Run shell inside a running pod container
kubectl exec -it my-app-pod -- /bin/sh
# Get detailed description of a pod (shows events, error status, image pull issues)
kubectl describe pod my-app-pod

# 5. Accessing NodePort Service in Minikube
# Get Minikube IP address
minikube ip
# Access app in browser at: http://<minikube-ip>:30007
# Or run shortcut:
minikube service my-app-service
```
