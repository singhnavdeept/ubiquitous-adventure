# Project Showcase Study Guide & Technical Notes

Use this guide to study the code and architecture decisions before your project showcase. It explains every configuration file in detail, why they are structured this way, and covers the typical questions you might be asked by examiners.

---

## 1. Docker Compose File (`docker-compose.yml`)

The `docker-compose.yml` file orchestrates our multi-container architecture. It defines three core services: the database (`db`), the application server (`app`), and the automation controller (`jenkins`).

```yaml
version: "3.9"

services:
  db:
    image: postgres:15-alpine
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
      interval: 10s
      timeout: 5s
      retries: 5
```

### Key Highlights — `db` Service:
* **`postgres:15-alpine`**: Uses an Alpine-based image, reducing the size of the database image from ~400MB to ~150MB to save disk space.
* **`${POSTGRES_USER}` etc.**: Pulls environment variables from the `.env` file at runtime, keeping credentials secure and out of source control.
* **`volumes: pgdata:/...`**: Mounts a named Docker volume (`pgdata`) to persist database files. If the container is destroyed or updated, your articles and database schemas remain safe.
* **`healthcheck` / `pg_isready -d ${POSTGRES_DB}`**: Checks if the database is ready to accept connections. Specifying `-d ${POSTGRES_DB}` is critical; otherwise, PostgreSQL checks for a default database matching the username (`mdadmin`), which doesn't exist, flooding the server logs with connection errors.

---

```yaml
  app:
    build: .
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: production
      PORT: 3000
      DATABASE_URL: postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
      RAW_ARTICLES_PATH: /app/raw_articles
    volumes:
      - ./raw_articles:/app/raw_articles
    depends_on:
      db:
        condition: service_healthy
```

### Key Highlights — `app` Service:
* **`build: .`**: Directs Docker to build the image locally using the `Dockerfile` in the root directory.
* **`ports: "3000:3000"`**: Maps port 3000 of the host to port 3000 of the container. Nginx on the host forwards public port 80 traffic here.
* **`DATABASE_URL`**: Connects to the database. Notice the host name is `db` (which matches the database service name). Docker's internal DNS automatically resolves `db` to the database container's private IP.
* **`volumes: ./raw_articles:/app/raw_articles`**: A bind-mount mapping the server's `./raw_articles` folder into the container. This allows the Chokidar file-watcher inside the container to see raw `.md` files dropped on the host system instantly.
* **`depends_on`**: Prevents the application container from starting until the database container's `healthcheck` reports that it is `healthy`.

---

```yaml
  jenkins:
    build:
      context: .
      dockerfile: Dockerfile.jenkins
    container_name: mdmaker-jenkins
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    restart: unless-stopped
```

### Key Highlights — `jenkins` Service:
* **`Dockerfile.jenkins`**: Builds a customized Jenkins image pre-loaded with Docker CLI, Docker Compose, and Node.js v22 so it can run linting, building, and deployment scripts.
* **`ports`**: Exposes 8080 for the Web UI dashboard and 50000 for distributed Jenkins agent nodes.
* **`/var/run/docker.sock:/var/run/docker.sock`**: Mounts the host machine's Docker socket inside the Jenkins container. This is a critical design pattern (known as **Docker-outside-of-Docker** or DooD). It allows the Jenkins container to command the host's Docker engine to compile images and restart other containers.

---

## 2. CI/CD Pipeline Configuration (`Jenkinsfile`)

The `Jenkinsfile` defines a Declarative Pipeline that automates the building, testing, and deployment of our application.

```groovy
pipeline {
    agent any
    
    stages {
        stage('Install & Verify') {
            steps {
                sh 'npm ci'
                sh 'npm run lint'
            }
        }
```
* **`npm ci`**: Short for *Clean Install*. It installs dependencies directly from `package-lock.json`, guaranteeing that the exact same package versions are used for every build, eliminating "works on my machine" issues.
* **`npm run lint` / `tsc --noEmit`**: Compiles TypeScript files without outputting JS files. It acts as a static analysis checker, verifying that there are no syntax or type errors in the code before deployment.

---

```groovy
        stage('Build & Deploy Application') {
            when {
                anyOf {
                    changeset "src/**"
                    changeset "server/**"
                    changeset "Dockerfile"
                    changeset "docker-compose.yml"
                    expression {
                        // Check if the application container is stopped/missing
                        return sh(script: "docker ps -q -f name=md-to-html--app-1", returnStdout: true).trim() == ""
                    }
                }
            }
            steps {
                sh 'docker compose down'
                sh 'docker compose up -d --build'
            }
        }
```
* **`when { anyOf { changeset ... } }`**: This is a performance optimization. The build and container redeployment stage is skipped if there are only changes to articles (like adding a `.md` file to `raw_articles/`). Jenkins only rebuilds the Docker images if the core source code files (`src/`, `server/`, or configuration files) are modified.
* **`expression { ... }`**: Ensures that if the application container is down or not yet created, Jenkins will deploy it even if no code changes are detected.

---

```groovy
        stage('Health Check') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    retry(5) {
                        sleep 5
                        sh 'curl -sf http://host.docker.com.internal:3000/api/articles'
                    }
                }
            }
        }
    }
}
```
* **`host.docker.internal:3000`**: Because Jenkins runs inside a container, querying `localhost:3000` would hit Jenkins itself. The DNS name `host.docker.internal` tells the container to route out to the host system and query port 3000 where our application container is mapped.
* **`curl -sf` / `retry(5)`**: Pings the application API. The `-f` flag makes the curl command return a non-zero exit code if the server responds with an error (e.g. 500 or 404), causing the stage to fail. The pipeline will retry 5 times with sleep intervals to allow Node to boot.

---

## 3. Infrastructure Configuration (Terraform `.tf` files)

Terraform codifies our AWS resources. Because our IAM user account has heavily restricted permissions (e.g., denied `DescribeVpcs`, `DescribeSubnets`, `DescribeImages`), the configuration has been modified to bypass standard query APIs.

### A. Provider configuration (`main.tf`)
```hcl
provider "aws" {
  region = var.aws_region
}
```
* Configures the AWS Provider. It pulls the region dynamically from variables, which we set to `ap-south-1` (Mumbai).

### B. Security Group (`main.tf`)
```hcl
resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-ec2-sg"
  # vpc_id omitted to automatically target Default VPC without querying DescribeVpcs

  ingress {
    description = "SSH from owner IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.your_ip_cidr]
  }

  ingress {
    description = "HTTP Web App"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins Web UI from owner IP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.your_ip_cidr]
  }
}
```
* **`vpc_id` Omission**: Omitting `vpc_id` causes AWS to automatically assign this security group to the account's **Default VPC**. This bypasses the restricted IAM user block on calling `ec2:DescribeVpcs`.
* **Traffic Isolation**: Protects your server. Public traffic is allowed only on Port 80 (HTTP). Administration ports 22 (SSH) and 8080 (Jenkins UI) are locked down strictly to your public IP (`your_ip_cidr`), preventing unauthorized access.

### C. EC2 Instance (`main.tf`)
```hcl
resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  availability_zone      = var.aws_availability_zone
  # subnet_id omitted to automatically target default subnet without querying DescribeSubnets
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = var.key_pair_name
}
```
* **`var.ami_id` / Hardcoding**: Normally, Terraform queries the latest Ubuntu AMI using data filters (`data.aws_ami`). Because `ec2:DescribeImages` is denied, we hardcoded the official Canonical Ubuntu 22.04 LTS AMI ID (`ami-03f4fa076d2981b45`) inside `variables.tf`.
* **`subnet_id` Omission**: Omitting `subnet_id` causes AWS to place the instance inside the default subnet of your default VPC within the requested availability zone (`ap-south-1b`). This bypasses the restricted `ec2:DescribeSubnets` API block.

---

## 4. Showcase Q&A (Ace Your Presentation)

### Q1: Why did you mount `/var/run/docker.sock` to the Jenkins container?
**Answer**: This represents the **Docker-outside-of-Docker (DooD)** pattern. Jenkins needs to build, start, and stop containers on our host machine. By mounting the host's Docker socket `/var/run/docker.sock` into the Jenkins container, the Jenkins runner communicates directly with the host's Docker engine. Any container Jenkins spawns runs directly on the host OS as a sibling, not nested inside Jenkins. This is faster and avoids complex container-in-container storage drivers.

### Q2: Why did you configure a Swap File on the EC2 server?
**Answer**: An AWS `t2.micro` instance has only **1 GB of RAM**. Running a PostgreSQL database, an Express/Node backend, and a Jenkins server simultaneously exceeds this limit, leading to Out-Of-Memory (OOM) crashes. We allocated a **3 GB swap file** on the EBS drive to act as virtual RAM. When physical RAM is exhausted, inactive memory pages are moved to the disk swap space, maintaining server uptime.

### Q3: Why is the `vpc_id` and `subnet_id` omitted in your Terraform file?
**Answer**: Our IAM deployment user (`clouded_noir`) has a highly restrictive security policy that blocks read access commands like `DescribeVpcs` and `DescribeSubnets`. In Terraform, omitting these attributes tells the AWS provider to automatically fall back to the AWS account's **Default VPC** and **Default Subnet** in the specified Availability Zone. This allowed us to successfully deploy our infrastructure without triggering permission access errors.

### Q4: How does the application watch for articles, and why are we bind-mounting `./raw_articles`?
**Answer**: The backend runs a directory watcher library called **Chokidar**. In `docker-compose.yml`, we bind-mount the host folder `./raw_articles` to `/app/raw_articles` inside the container. When a writer drops a Markdown file on the host machine, the file-event is immediately mirrored inside the container. Chokidar triggers an event listener that reads the file, parses the YAML frontmatter and Markdown body to HTML, and updates the PostgreSQL database.

### Q5: What is the benefit of Nginx running on port 80?
**Answer**: Nginx acts as a **Reverse Proxy**. Instead of exposing our Node.js application (port 3000) directly to the public internet, Nginx sits in front on port 80. It handles incoming connections, forwards them to port 3000, and passes responses back. This adds an additional layer of security, allows for future SSL termination, and handles static assets caching efficiently.
