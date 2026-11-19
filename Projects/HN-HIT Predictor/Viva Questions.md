# 🎓 Viva Question Bank — HN Hit Predictor MLOps Project

> **Role:** Teacher's perspective — questions a guide/examiner would likely ask
> **Student:** Navdeep Singh | LPU | Reg: 12308217
> **Guide:** Arshiya | UID-29453

---

## How to Use This

Questions are grouped by topic and marked by difficulty:
- 🟢 **Basic** — definition-level, expected from every student
- 🟡 **Intermediate** — understanding and application
- 🔴 **Advanced** — design decisions, trade-offs, what-if scenarios

**Read the question first. Try to answer it yourself. Then read the answer.**

---

## Topic 1: The Project — Big Picture

---

**🟢 Q1. What is the aim of your project in one sentence?**

> To build an end-to-end MLOps pipeline on AWS that trains a machine learning model to predict whether a Hacker News post will go viral, and serves it as a production-ready REST API with CI/CD, security scanning, and cloud monitoring — entirely on AWS Free Tier.

---

**🟢 Q2. What is MLOps? How is it different from just doing machine learning?**

> Machine Learning is the process of training a model on data. MLOps (ML + Operations) is the discipline of deploying that model reliably, maintaining it, monitoring its health, and automating the entire lifecycle from code commit to production. Plain ML ends at a trained model in a notebook. MLOps ensures that model is versioned, tested, containerised, deployed, monitored, and updated continuously — just like software engineering practices applied to ML systems.

---

**🟢 Q3. What does your project predict? What is the input and output?**

> **Prediction:** Whether a Hacker News post will score ≥ 50 points (reach the front page).
>
> **Input:** Post title (text), URL (optional), submission time (optional).
>
> **Output:** `is_hit` (true/false), `hit_probability` (0.0–1.0), `confidence_level` (High/Medium/Low), `prediction_label`.

---

**🟡 Q4. Why did you choose Hacker News as the subject of your project?**

> Hacker News is a publicly accessible, well-structured dataset via the Algolia API. It has clear success metrics (score/upvotes), diverse post types, and patterns that are learnable from text features. It's a realistic binary classification problem relevant to social media analytics and content recommendation — a common real-world ML use case.

---

**🟡 Q5. Walk me through the full flow — from a developer pushing code to a user getting a prediction.**

> 1. Developer pushes code to GitHub.
> 2. Jenkins (running on EC2) detects the new commit.
> 3. Jenkins runs 7 pipeline stages: Checkout, Checkov IaC scan, Docker build + Pytest, Image tagging, Trivy CVE scan, Smoke test, Production deploy.
> 4. The new Docker container replaces the old one on port 8000.
> 5. User visits `http://EC2_IP:8000`, submits a post title.
> 6. FastAPI receives it, extracts features, calls the trained model, returns a prediction.

---

**🔴 Q6. What would break first if you got 10,000 simultaneous users?**

> The t3.micro EC2 instance would be overwhelmed — it has only 2 vCPUs and 1 GB RAM. The FastAPI server (single Uvicorn worker) would queue requests. To handle this you'd need: (1) Multiple Uvicorn workers (`--workers 4`), (2) A Load Balancer distributing traffic, (3) Auto Scaling Group adding more EC2 instances when CPU spikes, (4) A caching layer (Redis) to avoid recomputing identical predictions.

---

## Topic 2: Machine Learning

---

**🟢 Q7. What type of machine learning problem is this?**

> Binary Classification. The label is either 1 (hit — score ≥ 50) or 0 (not a hit). We predict a probability and threshold at 0.50.

---

**🟢 Q8. What is Logistic Regression? Why is it called "regression" if it classifies?**

> Logistic Regression is a linear classification algorithm. It computes a weighted sum of features, then applies the sigmoid function to squash the output between 0 and 1, interpreting it as a probability. It is called "regression" historically because it was developed as an extension of linear regression. The regression is on the log-odds (logit), not the class label directly.

---

**🟢 Q9. What is TF-IDF? Explain Term Frequency and Inverse Document Frequency separately.**

> **TF (Term Frequency):** How often a word appears in the current document. If "python" appears 3 times in a title of 10 words, TF = 3/10 = 0.3.
>
> **IDF (Inverse Document Frequency):** Log of (total documents / documents containing the word). If "python" appears in 500 of 3000 documents, IDF = log(3000/500) = 1.79. Common words like "the" have low IDF; rare, specific words have high IDF.
>
> **TF-IDF = TF × IDF.** Words that are frequent in a document but rare overall get the highest scores — they are the most distinctive words.

---

**🟢 Q10. What is One-Hot Encoding? Why do we need it?**

> OHE converts a categorical variable (like `domain_type = "github"`) into a binary vector. Each unique category becomes its own column with value 0 or 1. We need it because ML models work with numbers, not strings. And we cannot use simple integer encoding (github=1, blogs=2) because that implies a numeric ordering and magnitude that doesn't exist between categories.

---

**🟢 Q11. What is Standard Scaling? Why is it needed?**

> Standard Scaling (Z-score normalisation) transforms a feature to have mean = 0 and standard deviation = 1. Formula: `z = (x - mean) / std`. It is needed because features like `submission_hour` (0–23) and `title_len` (10–100) are on completely different scales. Without scaling, Logistic Regression's gradient descent would update weights unevenly — the larger-scale feature would dominate.

---

**🟡 Q12. What is a scikit-learn Pipeline? What problem does it solve?**

> A scikit-learn Pipeline is a chain of transformers followed by a final estimator (classifier/regressor). Problem it solves: **data leakage**. If you fit the StandardScaler on the entire dataset before splitting into train/test, the scaler "knows" about the test data's mean and std — this leaks test information into training. With a Pipeline, you call `pipeline.fit(X_train, y_train)` and the scaler fits only on training data, then transforms test data using training statistics. This gives honest performance metrics.

---

**🟡 Q13. What is a ColumnTransformer?**

> A ColumnTransformer applies different preprocessing transformers to different columns of a DataFrame in parallel, then horizontally concatenates the outputs into a single feature matrix. Without it, you'd manually split, transform, and rejoin columns — error-prone. It's what allows us to apply TF-IDF to the `title` column while simultaneously applying OHE to `domain_type` and StandardScaler to numeric columns.

---

**🟡 Q14. What is `stratify=y` in `train_test_split`?**

> `stratify=y` preserves the class distribution from the full dataset in both the train and test splits. Our dataset has ~28% hits and ~72% non-hits. Without stratify, by random chance the train set might have 35% hits — making the model think hits are more common than they are, and making test metrics misleading. Stratify ensures both splits maintain 28/72 proportion.

---

**🟡 Q15. Why did you use `class_weight='balanced'` in Logistic Regression?**

> Because our dataset is imbalanced — only ~28% of posts are hits. Without balancing, the model achieves 72% accuracy by predicting "not a hit" for everything — it never learns to identify hits at all. `class_weight='balanced'` automatically computes weights inversely proportional to class frequency: the minority class (hits) gets higher weight during training, penalising the model more for missing a hit.

---

**🟡 Q16. Explain Accuracy, Precision, Recall, and F1-Score. When is each useful?**

> - **Accuracy** = (TP + TN) / Total. Good when classes are balanced. Misleading when imbalanced.
> - **Precision** = TP / (TP + FP). "Of all posts I predicted as hits, what fraction actually were?" Use when false positives are costly (e.g., recommending bad content).
> - **Recall** = TP / (TP + FN). "Of all actual hits, what fraction did I catch?" Use when false negatives are costly (e.g., missing cancer in a scan).
> - **F1-Score** = 2 × (Precision × Recall) / (Precision + Recall). Harmonic mean — balances both. Use when you care equally about precision and recall, especially with imbalanced datasets.

---

**🟡 Q17. What is ROC-AUC?**

> ROC stands for Receiver Operating Characteristic. The ROC curve plots True Positive Rate (Recall) vs False Positive Rate at every possible threshold. AUC (Area Under Curve) summarises this into a single number between 0 and 1. AUC = 0.5 means the model is no better than random guessing. AUC = 1.0 means perfect discrimination. AUC measures how well the model **ranks** hits higher than non-hits, independent of the classification threshold.

---

**🔴 Q18. Why did you use synthetic data? What are the risks?**

> We use synthetic data because (1) the HN Algolia API has rate limits and may be unavailable inside a Docker container during build, and (2) we needed reproducibility — the same training data every time for consistent model artifacts.
>
> **Risks:** Synthetic data may not capture real-world distribution accurately. The patterns we hardcoded (e.g., "Show HN + github = likely hit") may not reflect actual HN behaviour. The model might perform well on synthetic test data but poorly on real posts. In production, you'd replace this with a proper data pipeline pulling from the real HN API and storing data in S3.

---

**🔴 Q19. What is data leakage? Give an example from this project where it could occur.**

> Data leakage is when information from the test set accidentally influences model training, giving falsely optimistic metrics. Example: If we computed TF-IDF vocabulary on the full dataset (before splitting), words that appear only in the test set would influence the vocabulary. After splitting, the test set's TF-IDF vectors would be computed using a vocabulary shaped by test data — an information leak. The scikit-learn Pipeline prevents this by fitting all transformers only on training data.

---

**🔴 Q20. Could you have used a neural network instead? Why or why not?**

> Yes, technically. A neural network with an embedding layer for titles would likely capture more complex semantic patterns. However: (1) Neural networks require significantly more data — 3000 synthetic samples would likely cause severe overfitting. (2) They need GPU for fast training — not available on t3.micro. (3) They are black boxes — Logistic Regression gives interpretable coefficients showing which words most influence the prediction. (4) Our features are mostly engineered and relatively low-dimensional — a simple linear model is appropriate. The principle of Occam's Razor applies: use the simplest model that works.

---

## Topic 3: FastAPI & REST API

---

**🟢 Q21. What is a REST API?**

> REST (Representational State Transfer) is an architectural style for web APIs. A REST API communicates over HTTP using standard methods — GET (retrieve), POST (create/submit), PUT (update), DELETE (remove). Data is typically exchanged in JSON format. It is stateless — each request contains all information needed; the server doesn't remember previous requests.

---

**🟢 Q22. What is FastAPI? What makes it different from Flask?**

> FastAPI is a modern Python web framework built on top of Starlette (ASGI) and Pydantic. Differences from Flask: (1) FastAPI is **asynchronous** (async/await) — handles more concurrent requests. (2) **Automatic data validation** via Pydantic — invalid requests are rejected with structured errors automatically. (3) **Auto-generated interactive documentation** at `/docs` (Swagger UI) and `/redoc`. (4) **Type hints everywhere** — better IDE support and fewer runtime bugs. Flask requires manual validation and separate documentation tools.

---

**🟢 Q23. What is the difference between GET and POST requests?**

> **GET:** Retrieves data. Parameters in URL query string. No request body. Idempotent — calling it multiple times has the same effect. Used for `/health`, `/metrics`, `/`.
>
> **POST:** Sends data to the server. Data in the request body (JSON). Not idempotent — may create or change state. Used for `/predict` because we're sending a JSON payload (title, url) and the server processes it.

---

**🟡 Q24. What is CORS? Why did you enable it?**

> CORS (Cross-Origin Resource Sharing) is a browser security mechanism that blocks JavaScript running on one origin (e.g., `http://mysite.com`) from making requests to a different origin (e.g., `http://3.7.45.137:8000`). We enabled CORS with `allow_origins=["*"]` so that any web application can call our prediction API — necessary for the browser dashboard on port 8000 to call the API endpoint, and for any future frontend integrations.

---

**🟡 Q25. What is Pydantic? Why is it used?**

> Pydantic is a Python data validation library using type annotations. When FastAPI receives a POST request to `/predict`, Pydantic automatically: (1) Parses the JSON body, (2) Validates that `title` is a string with 3–300 characters, (3) Returns HTTP 422 Unprocessable Entity with a detailed error if validation fails, (4) Generates the OpenAPI schema for the docs UI. Without Pydantic, you'd write all this validation code manually.

---

**🟡 Q26. What is a lifespan context manager in FastAPI? Why use it?**

> Lifespan is a FastAPI feature that runs startup and shutdown code for the application. We use it to load `model.joblib` once at startup into a global variable. Why: loading the model from disk takes ~100–500ms. If we loaded it on every request, the API would be 100× slower. By loading once at startup, all subsequent predictions use the already-loaded in-memory object — sub-millisecond inference time.

---

**🔴 Q27. What is the difference between WSGI and ASGI?**

> **WSGI** (Web Server Gateway Interface) is the traditional Python web standard — synchronous. Each request blocks a thread until complete. Flask and Django use WSGI.
>
> **ASGI** (Asynchronous Server Gateway Interface) is the modern standard — supports `async`/`await`. While waiting for I/O (database query, external API call), the server can handle other requests in the same thread. FastAPI uses ASGI via Uvicorn. For ML inference (CPU-bound), the difference is smaller — but for a system that might call external APIs or databases, ASGI handles concurrency far better.

---

## Topic 4: Docker

---

**🟢 Q28. What is Docker? What problem does it solve?**

> Docker is a containerisation platform that packages an application and all its dependencies (OS libraries, Python interpreter, packages) into a portable, isolated unit called a container. It solves the "it works on my machine" problem — a container runs identically on any system with Docker installed, eliminating environment-specific bugs during deployment.

---

**🟢 Q29. What is the difference between a Docker Image and a Docker Container?**

> An **Image** is a read-only, immutable template — like a class in object-oriented programming. It contains the OS, application code, and all dependencies.
>
> A **Container** is a running instance of an image — like an object instantiated from a class. Multiple containers can run from the same image simultaneously. When a container stops, the image remains unchanged.

---

**🟢 Q30. What is the purpose of a Dockerfile?**

> A Dockerfile is a text script containing step-by-step instructions to build a Docker image. Each instruction (`FROM`, `RUN`, `COPY`, `CMD`) creates a layer in the image. It makes image creation reproducible — anyone can rebuild the same image from the same Dockerfile.

---

**🟡 Q31. Explain Docker layer caching. How did you optimise the Dockerfile for it?**

> Docker builds images layer by layer. If a layer's instruction and its inputs haven't changed, Docker reuses the cached layer instead of re-executing it. We optimise by copying `requirements.txt` and running `pip install` *before* copying the application code. Since `requirements.txt` rarely changes, the pip install layer is almost always cached. Only the code-copy layer needs to rebuild on each code change — saving several minutes per build.

---

**🟡 Q32. What does `PYTHONPATH=/workspace` do? Why was it needed?**

> `PYTHONPATH` tells Python where to look for modules when importing. Inside the container, the working directory is `/workspace`. Without `PYTHONPATH=/workspace`, when pytest or the app tries `from app.main import ...`, Python looks in its default search paths and doesn't find `app/`. Setting `PYTHONPATH=/workspace` makes Python treat `/workspace` as the root, so `app.main` resolves to `/workspace/app/main.py`. This fixed our `ModuleNotFoundError: No module named 'app'` error.

---

**🟡 Q33. What is a Docker HEALTHCHECK? How does it work?**

> `HEALTHCHECK` is a Dockerfile instruction that tells Docker to periodically run a command inside the container to verify it's functioning correctly. We use:
> ```
> HEALTHCHECK --interval=20s --timeout=5s --retries=3 \
>   CMD curl -f http://localhost:8000/health || exit 1
> ```
> Every 20 seconds, Docker runs `curl /health` inside the container. If it returns a non-zero exit code 3 times consecutively, Docker marks the container as `(unhealthy)`. This status is visible in `docker ps` and can trigger actions in Docker Compose, ECS, or Kubernetes.

---

**🟡 Q34. What is `docker exec` and when did you use it in this project?**

> `docker exec` runs a command inside an already-running container. We used it to fix our Jenkins smoke test. The original smoke test ran `curl http://localhost:8009/health` from inside the Jenkins container — which failed because `localhost` inside Jenkins refers to Jenkins' own network namespace, not the host. The fix: `docker exec hn-hit-predictor-smoke curl http://localhost:8000/health` — this runs `curl` inside the smoke container's namespace where `localhost:8000` correctly reaches Uvicorn.

---

**🔴 Q35. Explain Docker networking. What is a network namespace?**

> Docker uses Linux **network namespaces** to isolate containers. Each container gets its own virtual network interface, its own loopback (`localhost`/`127.0.0.1`), and its own routing table — completely isolated from other containers and the host.
>
> When you run `docker run -p 8009:8000`, Docker creates an iptables DNAT (Destination NAT) rule on the **host** that forwards traffic arriving on host port 8009 to the container's internal port 8000. But this rule is in the host's network namespace. Inside the Jenkins container's namespace, there is no such rule — `localhost:8009` doesn't exist there.

---

**🔴 Q36. What is Docker-out-of-Docker (DooD)? What security risk does it carry?**

> DooD is the pattern of mounting the Docker daemon socket (`/var/run/docker.sock`) from the host into a container, allowing that container to control the host's Docker daemon. We did this for Jenkins — so Jenkins (running inside a container) can run `docker build` and `docker run` on the EC2 host.
>
> **Security risk:** The Docker socket provides root-level access to the host. Any process inside the Jenkins container can create new containers, mount host filesystems, or escape the container entirely. In production, you'd use: (1) Docker-in-Docker (dind) with isolated daemon, (2) Rootless Docker, (3) Kaniko (builds images without Docker daemon), or (4) Buildah.

---

## Topic 5: Docker Compose

---

**🟢 Q37. What is Docker Compose? Why is it used?**

> Docker Compose is a tool for defining and running multi-container Docker applications from a single YAML file (`docker-compose.yml`). Instead of running multiple long `docker run` commands, you describe all services, their ports, volumes, and environment variables in one file and start everything with `docker compose up -d`.

---

**🟡 Q38. What does `restart: unless-stopped` mean?**

> It means Docker automatically restarts the container if it crashes (exits with non-zero code), or if the Docker daemon restarts (e.g., after EC2 reboot). The exception: if you explicitly stopped the container with `docker stop`, it won't restart. This ensures the API and Jenkins survive EC2 reboots without manual intervention.

---

**🟡 Q39. What is a named volume in Docker? Why do we use `jenkins_home`?**

> A named volume is a Docker-managed storage area on the host filesystem, decoupled from the container's lifecycle. We use `jenkins_home` to persist Jenkins configuration, jobs, pipeline history, and plugins. Without a named volume, every time the Jenkins container restarts, all configuration would be lost — you'd have to reconfigure Jenkins from scratch after every restart or update.

---

## Topic 6: Jenkins & CI/CD

---

**🟢 Q40. What is Continuous Integration (CI)?**

> CI is the practice of automatically integrating code changes from multiple developers into a shared repository frequently (often many times per day), with each integration verified by an automated build and test run. The goal is to catch integration bugs early, before they accumulate into large, hard-to-debug problems.

---

**🟢 Q41. What is a Jenkinsfile?**

> A Jenkinsfile is a text file written in Groovy DSL (Domain-Specific Language) that defines a Jenkins pipeline as code. It describes all stages, steps, environment variables, and post-build actions. Storing it in the Git repository means the pipeline definition is version-controlled alongside the application code — any change to the pipeline is tracked, reviewable, and reversible.

---

**🟢 Q42. How many stages does your Jenkins pipeline have? Name them.**

> 7 stages:
> 1. Checkout & Lint
> 2. DevSecOps — IaC Security (Checkov)
> 3. Build Test Environment & Run Tests
> 4. Package Production Image
> 5. DevSecOps — Container Scan (Trivy)
> 6. Integration Smoke Test
> 7. Deploy to Production (AWS EC2)

---

**🟡 Q43. What is `agent any` in a Jenkinsfile?**

> `agent any` tells Jenkins to run the pipeline on any available Jenkins node (agent). In our setup, we have only one node — the built-in Jenkins controller — so it always runs there. In a larger setup, `agent any` might assign the pipeline to any of several build agents (separate machines), and you could use `agent { label 'docker' }` to target only agents with Docker installed.

---

**🟡 Q44. What is `BUILD_NUMBER` in Jenkins?**

> `BUILD_NUMBER` is a Jenkins built-in environment variable that auto-increments with each pipeline run. Run 1 → `BUILD_NUMBER=1`, Run 2 → `BUILD_NUMBER=2`, etc. We use it to create unique image tags: `hn-hit-predictor:v5`, `hn-hit-predictor:v6`. This makes every build traceable — if a bug is introduced, you can redeploy `:v4` immediately without rebuilding.

---

**🟡 Q45. What does `post { always {} }` do in Jenkins?**

> The `post` block defines actions that run after all stages complete, regardless of success or failure. `always {}` runs in every case. We use it to run `docker rm -f hn-hit-predictor-smoke || true` — ensuring the smoke test container is always cleaned up. Without this, a failed smoke test would leave the container running, occupying port 8009 and causing the next build to fail with "port already in use."

---

**🟡 Q46. What was the bug in Stage 6 (Smoke Test) and how did you fix it?**

> **Bug:** The original smoke test ran `curl http://localhost:8009/health` from inside the Jenkins container. Inside a Docker container, `localhost` refers to that container's own loopback interface — not the EC2 host. The smoke container's port 8009 was bound to the EC2 host, not to the Jenkins container's localhost. So `curl` received "Connection Refused."
>
> **Fix:** `docker exec hn-hit-predictor-smoke curl -s -f http://localhost:8000/health`. This runs `curl` inside the smoke container's network namespace, where `localhost:8000` correctly reaches Uvicorn. `docker exec` bypasses all inter-container networking complexity.

---

**🔴 Q47. What is the difference between Declarative and Scripted Pipeline in Jenkins?**

> **Declarative Pipeline** (what we used): Structured, opinionated syntax with `pipeline {}`, `stages {}`, `steps {}`. Easier to read, write, and validate. Enforces a specific structure. Automatically provides `post {}`, `environment {}`, and `options {}` blocks.
>
> **Scripted Pipeline:** Raw Groovy code with `node {}`. Extremely flexible — you can write any Groovy logic. But more complex, harder to read, and no built-in structure enforcement. Used when Declarative Pipeline isn't expressive enough.

---

**🔴 Q48. How would you add email notifications to the Jenkins pipeline on failure?**

> In the `post` block:
> ```groovy
> post {
>     failure {
>         mail to: 'navdeep@example.com',
>              subject: "FAILED: Pipeline ${env.JOB_NAME} #${env.BUILD_NUMBER}",
>              body: "Check console output at ${env.BUILD_URL}"
>     }
> }
> ```
> Jenkins requires the Email Extension Plugin and SMTP server configuration under `Manage Jenkins → Configure System → Email Notification`.

---

## Topic 7: AWS CloudFormation

---

**🟢 Q49. What is Infrastructure as Code (IaC)?**

> IaC is the practice of managing and provisioning computing infrastructure through machine-readable configuration files rather than through manual processes or interactive configuration tools. Benefits: reproducibility (same template = same infrastructure every time), version control (track changes in Git), auditability (know who changed what and when), automation (no manual clicking in consoles).

---

**🟢 Q50. What is an AWS CloudFormation Stack?**

> A CloudFormation Stack is a collection of AWS resources that are created, updated, and deleted together as a single unit. When you deploy `infra.yaml`, CloudFormation creates a Stack containing all 7 resources (EC2, S3, IAM Role, Security Group, etc.). If you delete the stack, all resources are deleted together — no orphaned resources.

---

**🟡 Q51. What is the difference between CloudFormation Parameters and Outputs?**

> **Parameters:** Input values supplied at stack creation time. They allow the same template to be reused in different environments (dev/prod) with different values. Example: `InstanceType` (t3.micro for dev, m5.large for prod), `AdminCidr` (different IPs per environment).
>
> **Outputs:** Values exported from the stack after creation. Used to easily retrieve resource identifiers (like the EC2's public IP or the S3 bucket name) without searching through the console. Can also be referenced by other stacks via `Fn::ImportValue`.

---

**🟡 Q52. What is a CloudFormation Condition? Where did you use it?**

> A Condition is a named boolean expression evaluated at stack creation time. We used:
> ```yaml
> Conditions:
>   HasKeyName: !Not [!Equals [!Ref KeyName, ""]]
> ```
> Then in the EC2 resource:
> ```yaml
> KeyName: !If [HasKeyName, !Ref KeyName, !Ref "AWS::NoValue"]
> ```
> This makes the SSH key pair optional — if the user leaves `KeyName` blank, no key is attached (the EC2 uses IAM/SSM access only). If they provide a key name, it's used.

---

**🟡 Q53. What is `Fn::Base64` and `!Sub` in CloudFormation?**

> `Fn::Base64` encodes a string as Base64. Required for EC2 UserData — AWS expects the bootstrap script as a Base64-encoded string.
>
> `!Sub` (Substitution) is an intrinsic function that replaces `${VariableName}` placeholders in a string with their values. Example: `!Sub "hn-hit-predictor-${AWS::AccountId}-${AWS::Region}"` creates a globally unique S3 bucket name using the actual AWS Account ID and region.

---

**🔴 Q54. What is CloudFormation Drift Detection?**

> Drift occurs when someone manually changes an AWS resource (e.g., modifies a Security Group in the Console) after it was provisioned by CloudFormation. The actual resource state diverges from the declared template state. CloudFormation's Drift Detection compares the current resource configuration against the template and reports differences. In a mature DevOps environment, you'd disable Console access to resources and enforce all changes through CloudFormation to prevent drift.

---

## Topic 8: AWS EC2

---

**🟢 Q55. What is EC2?**

> EC2 (Elastic Compute Cloud) is AWS's virtual machine service. It provides resizable compute capacity in the cloud. You choose an instance type (CPU + RAM), select an AMI (operating system), configure storage and networking, and get a running Linux or Windows server accessible via SSH or browser.

---

**🟢 Q56. What is an AMI?**

> AMI (Amazon Machine Image) is a template used to create EC2 instances. It contains the operating system, pre-installed software, and configuration. We use Amazon Linux 2023 — AWS's own Linux distribution optimised for EC2, with pre-installed AWS CLI and SSM Agent. Using the SSM Parameter Store to look up the latest AMI ID ensures we always use the most current, patched version.

---

**🟡 Q57. What is a Security Group in AWS? How is it different from a firewall?**

> A Security Group is a virtual stateful firewall that controls inbound and outbound traffic to EC2 instances. **Stateful** means: if you allow inbound traffic on port 8000, the response packets are automatically allowed outbound — you don't write separate outbound rules. Traditional firewalls are often stateless (you must write both inbound and outbound rules). Security Groups are attached at the instance level (not network level), so each instance can have different rules.

---

**🟡 Q58. Why did you add a swapfile? What is swap memory?**

> Swap is disk space used as an overflow area when RAM is full. The OS moves the least-recently-used RAM contents to swap (the swapfile on the EBS SSD), freeing RAM for more urgent processes. Our t3.micro has only 1 GB RAM. During `docker build`, running `pip install numpy scipy scikit-learn pandas` simultaneously exceeded 1 GB, triggering the OOM (Out of Memory) killer. Adding 2 GB of swap prevented this — at the cost of slower performance when swap is used (disk I/O instead of RAM access).

---

**🔴 Q59. What is EC2 instance metadata? What is IMDS?**

> Instance Metadata Service (IMDS) is an HTTP endpoint available only from within an EC2 instance at `http://169.254.169.254/`. It provides metadata about the instance: instance ID, region, public IP, IAM role credentials (temporary, rotating), user data, and more.
>
> Applications use IMDS to get IAM credentials automatically — no hardcoded access keys needed. This is what `boto3` (AWS SDK for Python) uses when you call `boto3.client('s3')` on EC2 without providing explicit credentials.
>
> IMDSv2 (the newer version) requires a session token, adding protection against SSRF (Server-Side Request Forgery) attacks that could steal instance credentials.

---

## Topic 9: AWS S3

---

**🟢 Q60. What is S3? What does "object storage" mean?**

> S3 (Simple Storage Service) is AWS's object storage service. Object storage means data is stored as discrete objects (files), each with a unique key (path) and metadata. Unlike a file system, objects are not hierarchically organised on disk — the "folder" structure is an illusion created by key prefixes. Objects can be any size (up to 5 TB) and are accessible via HTTP. S3 is infinitely scalable, 99.999999999% durable (11 nines), and globally accessible.

---

**🟡 Q61. Why did you encrypt the S3 bucket with AES-256?**

> Server-Side Encryption with AES-256 encrypts data at rest on S3's storage systems. This protects model artifacts from being read if someone gains physical or low-level access to AWS's storage. It's a compliance requirement in most industries (healthcare, finance) and a DevSecOps best practice validated by Checkov check `CKV_AWS_19`. AES-256 is the same encryption standard used by governments and financial institutions.

---

**🟡 Q62. What does "versioning enabled" on S3 mean?**

> With versioning enabled, every time you overwrite an object (like `model.joblib`), S3 keeps the previous version. You can restore any previous version. This provides: (1) Rollback — if a newly trained model performs worse, restore the previous artifact. (2) Audit trail — complete history of model versions. (3) Accidental deletion protection — deleted objects become "delete markers", with previous versions still accessible.

---

## Topic 10: AWS CloudWatch

---

**🟢 Q63. What is CloudWatch?**

> AWS CloudWatch is a monitoring and observability service. It collects metrics (numerical time-series data like CPU %), logs (text events from applications and AWS services), and alarms (automated alerts when metrics breach thresholds). It also supports dashboards, anomaly detection, and event-driven automation via CloudWatch Events/EventBridge.

---

**🟡 Q64. Why doesn't AWS CloudWatch collect RAM usage by default? How did you get it?**

> AWS CloudWatch collects EC2 metrics at the **hypervisor level** — what the virtualisation layer can see: CPU cycles allocated, network packets, disk I/O operations. Memory usage is managed entirely within the guest OS — the hypervisor doesn't have visibility into how the OS allocates RAM between processes.
>
> To collect RAM metrics, we installed the **Amazon CloudWatch Agent** inside the OS (via UserData in CloudFormation). The agent runs as a service, reads `/proc/meminfo`, and publishes `mem_used_percent` to CloudWatch under the `CWAgent` namespace every 60 seconds.

---

**🟡 Q65. Explain the CloudWatch Alarm you created. Why two evaluation periods?**

> We created a `HighCPUAlarm` that triggers when `CPUUtilization` ≥ 80% (Average statistic) for 2 consecutive 5-minute periods (10 minutes total). Using two periods prevents false alarms from brief CPU spikes — for example, when Jenkins runs a Docker build (which causes high CPU for 2–5 minutes). We only want the alarm to fire for sustained high CPU that indicates a real problem (traffic overload, runaway process). A single 5-minute period would generate too many spurious alerts.

---

**🔴 Q66. How could you use CloudWatch to trigger a Lambda function when CPU is high?**

> CloudWatch Alarm → SNS Topic → Lambda Function. In the alarm's `AlarmActions`, instead of (or in addition to) an Auto Scaling policy, you specify an SNS Topic ARN. Subscribe a Lambda function to that SNS topic. When the alarm fires, SNS invokes the Lambda. The Lambda can then: send a Slack notification, write to a DynamoDB incident log, or call the EC2 API to terminate runaway processes.

---

## Topic 11: AWS IAM

---

**🟢 Q67. What is IAM? What are the main entities in IAM?**

> IAM (Identity and Access Management) is AWS's permission system controlling who can do what to which AWS resources.
>
> Main entities:
> - **Users:** Individual people or service accounts with long-term credentials (username/password, access keys)
> - **Groups:** Collections of users sharing the same permissions
> - **Roles:** Sets of permissions that can be assumed by AWS services (EC2, Lambda) or external identities — no long-term credentials
> - **Policies:** JSON documents defining allowed/denied actions on specific resources

---

**🟡 Q68. What is an IAM Role? How is it different from an IAM User?**

> An IAM User has long-term credentials (access key + secret key) belonging to a person or application. An IAM Role has no permanent credentials — it issues **temporary, automatically rotating** security credentials (STS tokens, valid for 1–12 hours). Roles are assumed by AWS services, EC2 instances, Lambda functions, or even other AWS accounts.
>
> For EC2, using a Role (via Instance Profile) is far more secure than using an IAM User's access keys: no key to accidentally commit to GitHub, automatic rotation, and credentials are only valid while the instance is running.

---

**🟡 Q69. What is the Principle of Least Privilege? How did you apply it?**

> Least Privilege means granting only the minimum permissions required to perform a task, and nothing more. We applied it by:
> 1. Creating a custom `S3ArtifactsAccess` policy granting only `s3:GetObject`, `s3:PutObject`, `s3:ListBucket` on **only our specific bucket ARN** — not `s3:*` on all buckets.
> 2. Using AWS Managed policies (`CloudWatchAgentServerPolicy`) which are already scoped to what CloudWatch Agent needs.
> 3. The EC2 role cannot access other EC2 instances, delete S3 buckets, modify IAM policies, or perform any other actions.

---

## Topic 12: DevSecOps

---

**🟢 Q70. What is DevSecOps?**

> DevSecOps (Development + Security + Operations) is the practice of integrating security into every phase of the software development lifecycle, rather than treating it as a separate phase at the end. Security checks are automated in the CI/CD pipeline — every commit is scanned. Security is everyone's responsibility, not just a dedicated security team's.

---

**🟢 Q71. What is Checkov? What type of scanning does it perform?**

> Checkov is a static analysis security tool for Infrastructure as Code. It scans CloudFormation, Terraform, Kubernetes, and other IaC files against hundreds of built-in security policies (CIS Benchmarks, NIST, AWS Well-Architected Framework). It performs **static analysis** — it reads the code without executing it and identifies misconfigurations before deployment. Example findings: SSH open to 0.0.0.0/0, S3 bucket not encrypted, no MFA on root account.

---

**🟢 Q72. What is Trivy? What does it scan?**

> Trivy (by Aqua Security) is an open-source vulnerability scanner for containers. It scans Docker images for CVEs (Common Vulnerabilities and Exposures) in: OS packages (Debian apt packages, Alpine apk packages), language packages (Python pip, Node npm, Go modules, Ruby gems, Java JAR files). It downloads the latest CVE database and matches installed package versions against known vulnerabilities.

---

**🟡 Q73. What is a CVE? Who maintains the CVE database?**

> CVE (Common Vulnerabilities and Exposures) is a standardised identifier for publicly known cybersecurity vulnerabilities. Format: `CVE-YEAR-NUMBER` (e.g., `CVE-2026-76642`). The CVE program is managed by MITRE Corporation and sponsored by the US Department of Homeland Security. NIST (National Institute of Standards and Technology) maintains the NVD (National Vulnerability Database) which enriches CVE records with severity scores (CVSS), impact analysis, and remediation guidance.

---

**🟡 Q74. Trivy found HIGH CVEs in your container. Why did you still deploy?**

> The HIGH CVEs found (e.g., in `util-linux`/`bsdutils`) are **OS library vulnerabilities** in the Debian Bookworm base image — not in our Python application code. `util-linux` manages filesystem mounting, which is not a functionality our web API uses. Additionally, the `Status` column showed `affected` with no fixed version available — there's no patch to apply. We used `--exit-code 0` (soft-fail) to report findings without blocking deployment, documenting accepted residual risk. In production, you'd formally accept or remediate each finding through a risk management process.

---

**🟡 Q75. What is the difference between SAST and DAST?**

> **SAST (Static Application Security Testing):** Analyses source code or IaC files without executing them. Checkov is SAST. Finds configuration issues, hardcoded secrets, SQL injection patterns in code. Fast, runs at commit time.
>
> **DAST (Dynamic Application Security Testing):** Tests the running application by sending malicious inputs (like a hacker would). Tools like OWASP ZAP, Burp Suite. Finds runtime vulnerabilities — XSS, actual injection vulnerabilities. Slower, requires a deployed environment.

---

**🔴 Q76. What is a supply chain attack? How does container scanning help?**

> A supply chain attack targets the dependencies of a project rather than the project itself. Example: SolarWinds hack — attackers compromised the build pipeline to inject malicious code into software updates. In the Docker world: a base image (`python:3.11-slim`) or a pip package could be compromised with malicious code. Container scanning (Trivy) detects known malicious packages or packages with known CVEs in your image — providing an additional layer of defence against supply chain attacks.

---

## Topic 13: Scenario / What-If Questions

---

**🔴 Q77. The model's accuracy drops from 78% to 60% next month. What would you do?**

> This is **model drift** — the real-world distribution has shifted. Steps:
> 1. **Detect:** Set up monitoring that compares prediction distribution over time (e.g., % of posts predicted as hits). Alert when it deviates significantly.
> 2. **Diagnose:** Check if input data distribution changed (new HN posting trends, different domain types becoming popular).
> 3. **Retrain:** Collect recent real HN data, retrain the model, evaluate on a fresh held-out test set.
> 4. **A/B test:** Route 10% of traffic to the new model, 90% to the old. Compare predictions.
> 5. **Deploy:** If new model performs better, roll out fully via the Jenkins pipeline.

---

**🔴 Q78. What happens if the Jenkins pipeline is running and the EC2 instance crashes?**

> Jenkins state is stored in the `/var/jenkins_home` Docker volume on the EC2 EBS. If EC2 crashes: (1) The in-progress build would be lost (no completed build record), (2) When EC2 restarts, Docker restarts all containers (`restart: unless-stopped`), (3) Jenkins loads from the persistent volume — all previous build history, jobs, and configuration are intact, (4) The failed build would appear as a timed-out/aborted run in Jenkins history.

---

**🔴 Q79. How would you roll back to the previous version if a deployment causes issues?**

> Because each build is tagged with `v${BUILD_NUMBER}`:
> ```bash
> # On EC2, stop the broken container and start the previous version
> docker rm -f hn-hit-predictor-api
> docker run -d --name hn-hit-predictor-api \
>     --restart unless-stopped -p 8000:8000 \
>     hn-hit-predictor:v6   # Previous version
> ```
> Or trigger the Jenkins pipeline's Deploy stage pointing to the previous image tag. In production, this would be integrated into the pipeline as a `Rollback` button in Jenkins.

---

**🔴 Q80. How would you scale this system to handle 1 million predictions per day?**

> At ~11 predictions/second average:
> 1. **Multiple Uvicorn workers:** `uvicorn app.main:app --workers 4` — uses all CPU cores.
> 2. **Application Load Balancer + Auto Scaling Group:** 2–10 EC2 instances scaling on CPU/request count.
> 3. **ECR for image storage:** Push Docker images to AWS Elastic Container Registry for multi-instance pulls.
> 4. **Redis caching:** Cache predictions for identical titles/URLs — most requests likely repeat popular titles.
> 5. **RDS or DynamoDB:** Store prediction logs for model monitoring.
> 6. **Consider moving to ECS Fargate or EKS:** Managed container orchestration at scale.

---

**🔴 Q81. What is the CAP theorem? How does it apply to your project?**

> CAP theorem states that a distributed system can guarantee only **two** of three properties simultaneously: **Consistency** (all nodes see the same data at the same time), **Availability** (every request gets a response), **Partition Tolerance** (system works despite network failures between nodes).
>
> Our current single-EC2 setup is not distributed — CAP doesn't directly apply. If we scaled to multiple EC2 instances: the ML model (stateless inference) is Availability + Partition Tolerant (AP) — different instances might serve slightly different model versions briefly after a deploy. We'd favour availability (keep serving predictions) over strict consistency (all instances having the exact same model version simultaneously).

---

## Topic 14: Quick-Fire Round

---

**🟢 Q82. What port does your FastAPI run on?** → 8000

**🟢 Q83. What port does Jenkins run on?** → 8080

**🟢 Q84. What is the EC2 instance type?** → t3.micro

**🟢 Q85. What Python version is used?** → Python 3.11

**🟢 Q86. What is the base Docker image?** → python:3.11-slim (Debian Bookworm)

**🟢 Q87. How many training samples are used?** → 3000 (synthetic) or ~2600 synthetic + live API data

**🟢 Q88. What is the hit threshold (score)?** → Score ≥ 50 points

**🟢 Q89. What algorithm is used for classification?** → Logistic Regression

**🟢 Q90. How many features does the model use?** → 6 raw features → ~3006 dimensions after transformation

**🟢 Q91. What is the train/test split ratio?** → 80% train, 20% test

**🟢 Q92. What file is the trained model saved as?** → `models/model.joblib`

**🟢 Q93. What CloudFormation resource type creates an EC2 instance?** → `AWS::EC2::Instance`

**🟢 Q94. What is the S3 bucket encryption algorithm?** → AES-256

**🟢 Q95. How long are CloudWatch logs retained?** → 7 days (RetentionInDays: 7)

**🟢 Q96. At what CPU % does the CloudWatch alarm trigger?** → 80%

**🟢 Q97. How many consecutive evaluation periods before alarm fires?** → 2 periods (10 minutes)

**🟢 Q98. What tool scans CloudFormation for security issues?** → Checkov (by Bridgecrew/Prisma Cloud)

**🟢 Q99. What tool scans Docker images for CVEs?** → Trivy (by Aqua Security)

**🟢 Q100. What command trains the model inside Docker?** → `RUN python -m src.train`

---

## 🎯 Top 10 Questions Most Likely to Be Asked

Based on typical academic viva patterns for MLOps/Cloud projects:

| Rank | Question |
|---|---|
| 1 | What is MLOps and how is it different from ML? (Q2) |
| 2 | Explain your complete project flow end-to-end (Q5) |
| 3 | What is Docker and why did you use it? (Q28) |
| 4 | Explain TF-IDF with an example (Q9) |
| 5 | What is the Jenkins pipeline and what are its stages? (Q41, Q42) |
| 6 | What is the difference between Precision and Recall? (Q16) |
| 7 | What was the bug in Stage 6 and how did you fix it? (Q46) |
| 8 | What is IaC and why use CloudFormation? (Q49) |
| 9 | What is the Principle of Least Privilege? (Q69) |
| 10 | What is DevSecOps? (Q70) |

---

*Prepare these thoroughly — good luck with your viva, Navdeep!*
