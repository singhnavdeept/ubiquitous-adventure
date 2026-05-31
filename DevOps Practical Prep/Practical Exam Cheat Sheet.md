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

## 🐙 2. Git: Merging & Interactive Rebasing

### A. Merging (Fast-Forward vs. Recursive Merge Commit)
```bash
# 1. Create and switch to a feature branch
git checkout -b feature-branch

# 2. Make changes and commit
git add .
git commit -m "feat: implement database connection"

# 3. Switch back to main
git checkout main

# 4. Scenario A: Fast-Forward Merge (main had no new commits)
# Directly moves the main branch pointer forward to the last commit of feature-branch
git merge feature-branch

# 5. Scenario B: Force a Merge Commit (prevents fast-forward, creates history bubble)
git merge --no-ff feature-branch
```

#### How to Resolve a Merge Conflict:
If both `main` and `feature-branch` modified the same line:
1. Running `git merge feature-branch` will output: `CONFLICT (content): Merge conflict in file.txt`.
2. Open `file.txt`. Locate the conflict markers:
   ```text
   <<<<<<< HEAD
   This is the text on the main branch.
   =======
   This is the text on the feature branch.
   >>>>>>> feature-branch
   ```
3. Edit the file: remove the markers (`<<<<<<<`, `=======`, `>>>>>>>`) and keep the desired final code state.
4. Stage and commit the resolved files:
   ```bash
   git add file.txt
   git commit -m "merge: resolve conflict between main and feature-branch"
   ```

---

### B. Interactive Rebasing (`git rebase -i`)
Rebasing reapplies commits from your branch on top of another branch, linearizing history. Interactive rebasing (`-i`) allows you to modify, squash, reorder, or delete commits.

```bash
# Start interactive rebase for the last 3 commits on your current branch
git rebase -i HEAD~3
```

This opens a text file in your terminal editor (Vim/Nano) listing your commits chronologically (oldest to newest):

```text
pick a17a326 feat: create user schema
pick 8bc28b5 fix: resolve db typo
pick 30e44e5 docs: update API documentation

# Rebase Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# d, drop = remove commit
```

#### Steps to Squash Commits:
1. Change `pick` to `squash` (or `s`) for the commits you want to merge *up* into the previous one:
   ```text
   pick a17a326 feat: create user schema
   squash 8bc28b5 fix: resolve db typo
   squash 30e44e5 docs: update API documentation
   ```
2. Save and close the editor (In Vim: `:wq` and hit Enter).
3. A second editor window opens prompting you to write a consolidated commit message. Edit the message, save, and exit.
4. Your history is now linearized into a single clean commit.
   > [!WARNING]
   > Never rebase commits that have already been pushed to a public remote repository shared by other developers. It rewrites git hashes and breaks history mapping.

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
