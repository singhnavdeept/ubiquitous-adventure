# Data Engineering Roadmap


## How to use this file

- Work **top to bottom, phase by phase**
- Check off `[ ]` items as you finish them
- Each phase builds directly on the previous one — don't skip
- Estimated time per phase assumes 1–2 hours of focused learning per day

---

## Phase 1 — Core Language & Tools

**Goal:** Be productive in a terminal, write clean Python, and query any database.  
**Estimated time:** 4–6 weeks

### Python

- [ ] Variables, data types, loops, functions, list comprehensions
- [ ] File I/O — reading/writing CSV, JSON, text files
- [ ] Error handling — try/except, custom exceptions
- [ ] `pandas` — DataFrames, filtering, groupby, merge, pivot
- [ ] `numpy` — arrays, vectorised operations
- [ ] Writing modular code — functions, modules, packages
- [ ] Virtual environments — `venv`, `pip`, `requirements.txt`
- [ ] Writing unit tests with `pytest`
- [ ] Type hints and docstrings

### SQL

- [ ] SELECT, WHERE, GROUP BY, ORDER BY, HAVING
- [ ] JOINs — INNER, LEFT, RIGHT, FULL OUTER, CROSS
- [ ] Subqueries and derived tables
- [ ] Common Table Expressions (CTEs) — `WITH` clause
- [ ] Window functions — `ROW_NUMBER`, `RANK`, `LAG`, `LEAD`, `SUM OVER`
- [ ] Aggregation functions — `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- [ ] String, date, and type-casting functions
- [ ] Understanding query execution plans (`EXPLAIN`)
- [ ] Indexes — when and how they help

### Linux & Shell

- [ ] Navigating the filesystem — `ls`, `cd`, `pwd`, `find`
- [ ] File operations — `cp`, `mv`, `rm`, `chmod`, `chown`
- [ ] Viewing files — `cat`, `less`, `head`, `tail`, `grep`, `awk`, `sed`
- [ ] Piping and redirection — `|`, `>`, `>>`, `<`
- [ ] Writing bash scripts — variables, loops, conditionals
- [ ] Scheduling with `cron`
- [ ] Environment variables — `export`, `.env` files
- [ ] SSH — connecting to remote machines, key-based auth
- [ ] Process management — `ps`, `kill`, `nohup`, `tmux`

### Git & Version Control

- [ ] Init, clone, add, commit, push, pull
- [ ] Branching — `git branch`, `git checkout`, `git merge`
- [ ] Resolving merge conflicts
- [ ] Pull requests and code review workflow
- [ ] `.gitignore` — what to exclude
- [ ] Tagging releases
- [ ] Basic CI understanding — what runs on a PR

**Phase 1 checkpoint:** You can write a Python script that reads a CSV, transforms it with pandas, queries a local Postgres database, and runs in a shell script triggered by cron.

---

## Phase 2 — Databases & Storage

**Goal:** Know where data lives, what format it lives in, and why those choices matter.  
**Estimated time:** 3–4 weeks

### Relational Databases (OLTP)

- [x] How relational databases work — tables, rows, columns, keys
- [x] Primary keys, foreign keys, constraints
- [x] Normalisation — 1NF, 2NF, 3NF
- [x] Transactions — ACID properties
- [ ] PostgreSQL — install, connect, CRUD, psycopg2 from Python
- [x] MySQL basics — differences from Postgres
- [ ] Connection pooling concepts

### Analytical Databases (OLAP)

- [ ] OLTP vs OLAP — why they have different designs
- [ ] Columnar storage — why it's faster for analytics
- [ ] Snowflake — virtual warehouses, compute/storage separation
- [ ] Google BigQuery — slots, partitioned tables, clustering
- [ ] Amazon Redshift — distribution keys, sort keys
- [ ] Query cost optimisation basics in each warehouse

### NoSQL Stores

- [ ] When to use NoSQL vs relational — trade-offs
- [ ] Document stores — MongoDB basics, when documents make sense
- [ ] Wide-column — [[Architecture of Cassandra]], use cases (time-series, IoT)
- [ ] Key-value — Redis for caching and fast lookups
- [ ] DynamoDB — partition keys, sort keys, access patterns first

### File Formats

- [ ] CSV — limitations at scale
- [ ] JSON and JSONL — nested data, streaming ingestion
- [ ] **Parquet** — columnar, compressed, predicate pushdown (learn this deeply)
- [ ] Avro — schema embedded, great for Kafka
- [ ] ORC — Hive ecosystem columnar format
- [ ] When to use each format and why

### Object Storage & Data Lakes

- [ ] Amazon S3 — buckets, prefixes, IAM policies, lifecycle rules
- [ ] Google Cloud Storage / Azure Blob — conceptually similar
- [ ] Data lake architecture — raw / curated / consumption zones
- [ ] Data warehouse vs data lake vs lakehouse — differences
- [ ] Apache Iceberg — table format, time travel, schema evolution
- [ ] Delta Lake — ACID on object storage, merge operations

**Phase 2 checkpoint:** You can design a storage architecture for a new project — choose the right database type, file format, and storage layer for a given use case.

---

## Phase 3 — Data Modeling & Batch Pipelines

**Goal:** Model data for analytics and build reliable batch transformation pipelines.  
**Estimated time:** 4–6 weeks

### Dimensional Modeling

- [ ] Why dimensional modeling exists — analytics vs transactional
- [ ] Facts vs dimensions — what each one is
- [ ] Star schema — fact table at centre, dimension tables around it
- [ ] Snowflake schema — normalised dimensions
- [ ] Surrogate keys vs natural keys
- [ ] Grain — defining what one row in a fact table means
- [ ] Additive, semi-additive, and non-additive measures
- [ ] Conformed dimensions — sharing dimensions across fact tables

### Slowly Changing Dimensions (SCD)

- [ ] Why history matters in dimension tables
- [ ] SCD Type 1 — overwrite (no history)
- [ ] SCD Type 2 — add new row with `valid_from` / `valid_to` dates
- [ ] SCD Type 3 — add a column for previous value
- [ ] Snapshot tables as an alternative

### ETL / ELT Patterns

- [ ] ETL — transform before loading (traditional, on-prem)
- [ ] ELT — load raw, transform in warehouse (modern cloud pattern)
- [ ] Full loads vs incremental loads
- [ ] Incremental strategies — `updated_at` watermark, CDC, `MERGE`
- [ ] Idempotency — why running a pipeline twice must give the same result

### dbt (data build tool)

- [ ] What dbt does — SQL-based transformations as version-controlled code
- [ ] Project structure — models, sources, seeds, snapshots, tests, docs
- [ ] Model materialisation — table, view, incremental, ephemeral
- [ ] Writing `ref()` and `source()` — building the dependency graph
- [ ] dbt tests — `unique`, `not_null`, `accepted_values`, `relationships`
- [ ] Custom generic tests
- [ ] dbt docs — generating lineage graphs
- [ ] Snapshots for SCD Type 2
- [ ] Incremental models — `is_incremental()` macro
- [ ] Running dbt in CI/CD

### Data Quality

- [ ] What data quality means — completeness, accuracy, freshness, uniqueness
- [ ] Writing dbt tests for every critical model
- [ ] Great Expectations — expectations, checkpoints, data docs
- [ ] Alerting on data quality failures
- [ ] Row count checks, null rate checks, distribution checks

### Data Lineage

- [ ] What lineage means — tracking where data comes from and goes
- [ ] Column-level lineage vs table-level lineage
- [ ] OpenLineage standard
- [ ] Marquez — open-source lineage server
- [ ] How dbt exposes lineage natively

**Phase 3 checkpoint:** You can build a full dbt project — sources, staging models, intermediate models, mart models — with tests and documentation for a realistic business domain.

---

## Phase 4 — Orchestration & Cloud

**Goal:** Automate, schedule, and deploy pipelines reliably on cloud infrastructure.  
**Estimated time:** 4–6 weeks

### Apache Airflow

- [ ] Core concepts — DAGs, tasks, operators, sensors
- [ ] Task dependencies — `set_upstream`, `set_downstream`, `>>` syntax
- [ ] Scheduling — cron expressions, `schedule_interval`
- [ ] Built-in operators — `BashOperator`, `PythonOperator`, `BranchOperator`
- [ ] Provider packages — S3, Postgres, BigQuery, dbt operators
- [ ] XComs — passing data between tasks
- [ ] Variables and Connections — managing secrets and config
- [ ] Backfilling — re-running historical DAG runs
- [ ] SLAs and alerting — email on failure, on retry
- [ ] Airflow pools — limiting concurrency
- [ ] Airflow on Docker and managed services (MWAA, Cloud Composer, Astronomer)

### Modern Orchestrators (pick one to learn after Airflow)

- [ ] **Dagster** — asset-based paradigm, software-defined assets, rich UI
    - [ ] Assets, jobs, schedules, sensors, resources
    - [ ] Asset materialisation and freshness policies
- [ ] **Prefect** — Python-native, easy local dev, Prefect Cloud
    - [ ] Flows, tasks, deployments, work pools
- [ ] **Mage** — newer, notebook-style blocks, good for smaller teams

### Docker & Containers

- [ ] What Docker solves — reproducible environments
- [ ] Images vs containers
- [ ] Writing a `Dockerfile` for a Python pipeline
- [ ] `docker build`, `docker run`, `docker exec`
- [ ] `docker-compose` — local multi-service setups (Airflow + Postgres + Redis)
- [ ] Container registries — ECR, GCR, Docker Hub
- [ ] Environment variables and secrets in containers

### Kubernetes (K8s) Basics

- [ ] What K8s solves — scheduling containers at scale
- [ ] Core objects — Pod, Deployment, Service, Job, CronJob
- [ ] `kubectl` — basic commands
- [ ] Helm — package manager for K8s apps
- [ ] KubernetesExecutor in Airflow
- [ ] Resource limits — CPU and memory requests

### Cloud Platform (pick AWS, GCP, or Azure — AWS recommended)

**AWS path:**

- [ ] IAM — users, roles, policies, least privilege
- [ ] S3 — the backbone of every AWS data stack
- [ ] EC2 — compute basics
- [ ] Lambda — serverless functions for lightweight ingestion
- [ ] RDS — managed Postgres/MySQL
- [ ] Redshift — columnar warehouse
- [ ] Glue — managed Spark and data catalog
- [ ] Athena — serverless SQL over S3
- [ ] SQS / SNS — messaging
- [ ] CloudWatch — logs and metrics
- [ ] VPC — networking basics

### Infrastructure as Code (IaC)

- [ ] Why IaC matters — repeatable, version-controlled infra
- [ ] Terraform — providers, resources, variables, state
- [ ] `terraform init`, `plan`, `apply`, `destroy`
- [ ] Managing Terraform state — remote backends (S3 + DynamoDB)
- [ ] AWS CloudFormation (if staying in AWS ecosystem)

**Phase 4 checkpoint:** You can deploy a full batch pipeline — dbt + Airflow — on a cloud provider using Docker, with infra provisioned via Terraform and secrets managed properly.

---

## Phase 5 — Streaming & Real-Time Systems

**Goal:** Build pipelines that handle continuous, high-volume event streams.  
**Estimated time:** 6–8 weeks

### Messaging Foundations

- [ ] Why streaming — real-time vs batch latency trade-offs
- [ ] Producer / consumer model
- [ ] At-most-once, at-least-once, exactly-once delivery semantics
- [ ] Back-pressure — what happens when consumers are slow

### Apache Kafka

- [ ] Architecture — brokers, topics, partitions, replicas
- [ ] Producers — sending messages, keys, partitioning strategy
- [ ] Consumers and consumer groups — how partitions are assigned
- [ ] Offsets — what they are, committing strategies
- [ ] Retention — time-based and size-based
- [ ] Kafka Connect — source and sink connectors
- [ ] Kafka Streams — lightweight stream processing on Kafka
- [ ] `kafka-python` / `confluent-kafka` — Python clients
- [ ] Schema Registry — Avro schemas, schema evolution rules
- [ ] Kafka on cloud — MSK (AWS), Confluent Cloud

### Change Data Capture (CDC)

- [ ] What CDC is — capturing row-level changes from a database
- [ ] Log-based CDC vs query-based CDC
- [ ] Debezium — connectors for Postgres, MySQL, MongoDB
- [ ] CDC into Kafka — the standard pattern
- [ ] Using CDC to feed real-time and batch pipelines simultaneously

### Stream Processing

- [ ] Event time vs processing time — why the difference matters
- [ ] Watermarks — handling late-arriving events
- [ ] Windowing — tumbling, sliding, session windows
- [ ] Stateful processing — maintaining state across events
- [ ] **Apache Flink**
    - [ ] DataStream API and Table API
    - [ ] Stateful operators, keyed streams
    - [ ] Checkpointing and state backends
    - [ ] Exactly-once with Kafka
- [ ] **Spark Structured Streaming**
    - [ ] Streaming DataFrames
    - [ ] Trigger modes — micro-batch vs continuous
    - [ ] Watermarks and late data
    - [ ] Sinks — Kafka, Delta Lake, Parquet
- [ ] **Apache Beam** — unified batch + streaming model (runner-agnostic)

### Cloud Streaming Services

- [ ] Amazon Kinesis — Data Streams, Firehose, Analytics
- [ ] Google Pub/Sub and Dataflow
- [ ] Azure Event Hubs

### Real-Time Pipeline Patterns

- [ ] Lambda architecture — batch layer + speed layer
- [ ] Kappa architecture — streaming only, simpler ops
- [ ] CQRS — command query responsibility segregation
- [ ] Streaming ETL — ingest → enrich → sink
- [ ] Micro-batch vs true streaming — when each makes sense
- [ ] Real-time aggregations — pre-aggregating into OLAP stores
- [ ] Serving real-time results — Druid, Pinot, ClickHouse

**Phase 5 checkpoint:** You can build a Kafka + Flink (or Spark Streaming) pipeline that ingests CDC events, applies windowed aggregations, and writes results to a data store — handling late data and failures gracefully.

---

## Phase 6 — Scale, Reliability & Platform Engineering

**Goal:** Operate data systems at production scale with confidence.  
**Estimated time:** 8–12 weeks (ongoing)

### Spark at Scale

- [ ] Spark architecture — driver, executors, cluster managers
- [ ] RDDs vs DataFrames vs Datasets — use DataFrames
- [ ] Partitioning — why it's the single biggest lever for performance
- [ ] Shuffles — what causes them, why they're expensive
- [ ] Broadcast joins — avoiding shuffles for small tables
- [ ] Skew handling — salting, AQE (Adaptive Query Execution)
- [ ] Caching and persistence — when to use `cache()` vs `persist()`
- [ ] Memory tuning — executor memory, off-heap, overhead
- [ ] Writing efficient Spark jobs — predicate pushdown, column pruning
- [ ] Spark on Kubernetes and EMR

### Data Observability

- [ ] Four pillars — freshness, volume, schema, distribution
- [ ] Monte Carlo — automated anomaly detection
- [ ] Building your own monitors — row count, null rate, value range checks
- [ ] Prometheus + Grafana — metrics and dashboards for pipeline health
- [ ] Structured logging — JSON logs, correlation IDs
- [ ] Alerting — PagerDuty, Opsgenie integration
- [ ] SLAs and SLOs for data pipelines
- [ ] On-call runbooks for common failures

### Fault Tolerance & Reliability

- [ ] Idempotency — design every write to be safe to repeat
- [ ] Retry logic — exponential backoff, dead letter queues
- [ ] Circuit breakers — preventing cascade failures
- [ ] Backfill strategies — how to re-process historical data safely
- [ ] Partial failure handling — what to do when one task in a DAG fails
- [ ] Disaster recovery — RPO and RTO for data pipelines
- [ ] Testing pipelines — unit tests, integration tests, contract tests

### Schema Evolution & Data Contracts

- [ ] Why schema changes break pipelines
- [ ] Backward vs forward compatibility
- [ ] Confluent Schema Registry — enforcing schema contracts
- [ ] Schema evolution strategies — adding nullable columns, never deleting
- [ ] Data contracts — producers commit to a schema, consumers trust it
- [ ] Tools — Schemata, OpenAPI for data

### Security & Governance

- [ ] Role-based access control (RBAC) — principle of least privilege
- [ ] Column-level security — masking PII in warehouse queries
- [ ] Row-level security — restricting data by user/group
- [ ] Data classification — public, internal, confidential, restricted
- [ ] PII identification and masking — regex patterns, NLP-based detection
- [ ] GDPR / CCPA compliance basics for data engineers
- [ ] Right to erasure — how to handle deletion in immutable stores
- [ ] Audit logging — who queried what, when
- [ ] Secrets management — HashiCorp Vault, AWS Secrets Manager

### Data Platform Design

- [ ] Data mesh — domain ownership, data as a product
- [ ] Data product thinking — SLAs, ownership, discoverability
- [ ] Data catalog — Amundsen, DataHub, Google Data Catalog
- [ ] Metadata management — technical vs business metadata
- [ ] Self-serve analytics — enabling non-engineers to get data safely
- [ ] Cost management — query cost, storage cost, compute cost optimisation
- [ ] The modern data stack — understanding how tools fit together

---

## Reference: The Modern Data Stack at a Glance

```
Ingestion          →   Storage            →   Transform         →   Serve
──────────────────────────────────────────────────────────────────────────
Fivetran / Airbyte     S3 / GCS / ADLS        dbt                   BI tools
Kafka / Debezium       Snowflake / BigQuery    Spark / Flink         APIs
Custom scrapers        Delta Lake / Iceberg    dbt + Airflow         ML features
Webhooks / APIs        Redshift               SQL in warehouse       Dashboards
```

```
Orchestration: Airflow / Dagster / Prefect
Observability: Monte Carlo / Prometheus / custom monitors
Quality:       Great Expectations / dbt tests
Lineage:       OpenLineage / dbt docs / DataHub
IaC:           Terraform
Containers:    Docker + Kubernetes
```

---

## Recommended learning order (condensed)

1. Python + SQL + Linux basics
2. Postgres + S3 + Parquet
3. Build a simple ETL in Python
4. Learn dbt — build a real project
5. Learn Airflow — schedule that project
6. Containerise with Docker
7. Deploy on a cloud provider
8. Add Terraform for infra
9. Learn Kafka fundamentals
10. Build a streaming pipeline with Spark Streaming or Flink
11. Add observability and alerting
12. Study platform design patterns

---

## Books & resources

|Topic|Resource|
|---|---|
|SQL|_Learning SQL_ — Alan Beaulieu|
|Data Modeling|_The Data Warehouse Toolkit_ — Kimball & Ross|
|Spark|_Learning Spark_ (O'Reilly, 2nd ed)|
|Kafka|_Kafka: The Definitive Guide_ (O'Reilly)|
|Flink|_Stream Processing with Apache Flink_ (O'Reilly)|
|Data Engineering|_Fundamentals of Data Engineering_ — Joe Reis & Matt Housley|
|dbt|[docs.getdbt.com](https://docs.getdbt.com/)|
|Airflow|[airflow.apache.org/docs](https://airflow.apache.org/docs)|
|Practice|[dataengineering.wiki](https://dataengineering.wiki/)|

---

_Last updated: 2025 | Work through each phase completely before moving on._