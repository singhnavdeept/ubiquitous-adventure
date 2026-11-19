---
title: "Aux 04: Identity, Access Management & Cryptographic Foundations"
course_code: "INT378"
category: "foundations-guide"
hub: "[[INT378 Master Strategy & Curriculum Roadmap]]"
atlas: "[[00 - Prerequisite & Auxiliary Knowledge Atlas]]"
related_units:
  - "[[Unit 5 - DevSecOps, IAM and Cloud Security]]"
related_labs:
  - "[[Lab 02 - AWS IAM, MFA, Custom Policies & RBAC]]"
  - "[[Lab 07 - DevSecOps Pipeline (SAST, Trivy & Secret Mgmt)]]"
core_prerequisites:
  - "AuthN vs AuthZ vs Accounting"
  - "Symmetric vs Asymmetric vs Hashing vs HMAC"
  - "AWS IAM Evaluation Hierarchy"
  - "Identity-Based vs Resource-Based Policies"
  - "AWS STS Temporary Session Tokens"
  - "EC2 Instance Profiles"
  - "KMS Hardware Security Modules & Envelope Encryption"
tags:
  - int378/foundations
  - iam
  - cryptography
  - security
  - sts
  - kms
  - encryption
last_updated: 2026-11-20
---

# Aux 04: Identity, Access Management & Cryptographic Foundations

Cloud security is governed by identity boundaries, cryptographic proofs, and policy evaluation engines. When you configure IAM permissions or encrypt data in S3, these are the cryptographic and authorization foundations at work.

---

## 1. The Security Triad: AuthN vs. AuthZ vs. Accounting

Engineers frequently confuse authentication with authorization. They are distinct operational stages:

```mermaid
flowchart LR
    Actor["User / Service"] -->|"1. Present Credentials"| AuthN["Authentication (AuthN)<br>'Who are you?'<br>(Password, MFA, API Key, x509 Cert)"]
    AuthN -->|"Identity Verified"| AuthZ["Authorization (AuthZ)<br>'What are you allowed to do?'<br>(IAM Policies, RBAC, ABAC)"]
    AuthZ -->|"Action Executed"| Audit["Accounting / Audit<br>'Who did what and when?'<br>(AWS CloudTrail, System Audit Logs)"]
```

1. **Authentication (AuthN)**: Validating that an entity is genuinely who they claim to be.
2. **Authorization (AuthZ)**: Evaluating whether the authenticated entity has permission to perform a specific action on a specific resource.
3. **Accounting (Audit)**: Chronologically logging the event for security forensics and regulatory compliance.

---

## 2. Cryptography 101 for Cloud & DevOps Engineers

```mermaid
flowchart TD
    subgraph CryptoBranches["Cryptographic Primitive Families"]
        direction TB
        Sym["Symmetric Encryption (AES-256 GCM)<br>- 1 Shared Key for Encrypt & Decrypt<br>- Hardware Accelerated (Blazing Fast)<br>- Used for: S3 Data-at-Rest, Disk Encryption"]
        Asym["Asymmetric Encryption (RSA, ECDSA)<br>- Public Key (Encrypt/Verify) + Private Key (Decrypt/Sign)<br>- Computationally Heavy<br>- Used for: SSH, TLS Handshakes, Digital Signatures"]
        Hash["Cryptographic Hashing (SHA-256, SHA-512)<br>- One-Way Mathematical Digest (Irreversible)<br>- Fixed 256-bit Output<br>- Used for: Password Storage, Git Commit Hashes, Integrity Checks"]
        HMAC["HMAC (Hash-based Message Authentication Code)<br>- Secret Key + Message Digest<br>- Proves Authenticity and Data Integrity<br>- Used for: GitHub Webhook Signatures, AWS SigV4"]
    end
```

> [!CAUTION]
> **Base64 is NOT Encryption or Hashing!**
> Base64 is merely an **encoding format** designed to convert raw binary bytes into ASCII text for safe transport over HTTP or JSON. Anyone can decode Base64 in one second (`echo "c2VjcmV0" | base64 -d`). Never assume storing a secret in Base64 (like Kubernetes Secrets) provides security.

---

## 3. AWS IAM Policy Mechanics Under the Microscope

An IAM Policy is a formal JSON grammar evaluated by the AWS authorization engine.

### 3.1 Identity-Based Policies vs. Resource-Based Policies
- **Identity-Based Policies**: Attached to a User, Group, or Role. Defines what that identity can do across AWS resources.
- **Resource-Based Policies**: Attached directly to the AWS resource itself (e.g., **S3 Bucket Policy**, **AWS KMS Key Policy**, **Amazon SQS Policy**). Defines *who* (which principals) can access that specific resource.

```mermaid
flowchart TD
    subgraph CrossAccount["Cross-Account Access Rule"]
        AccountA["Account A: IAM User (dev-alex)"]
        AccountB["Account B: Production S3 Bucket"]
        
        AccountA -->|"Must have Identity Policy Allowing S3 Access"| Gate{"Cross-Account Evaluation"}
        Gate -->|"AND Resource Policy on Bucket must Allow Account A!"| AccountB
    end
```

> [!NOTE]
> - **Same AWS Account**: Access is granted if **either** the Identity Policy OR the Resource Policy allows it.
> - **Cross-Account**: Access is granted **only if BOTH** the Identity Policy in the caller's account AND the Resource Policy in the destination account explicitly allow it!

### 3.2 The Complete 6-Step IAM Policy Evaluation Hierarchy
When any AWS API call is received, the IAM policy engine evaluates the request through this strict evaluation flow:

```mermaid
flowchart TD
    Start["Incoming AWS API Request (e.g., s3:PutObject)"] --> S1{"1. Explicit Deny in ANY policy?"}
    S1 -- YES --> Denied["ACCESS DENIED (Immediate Halt)"]
    S1 -- NO --> S2{"2. Organizations SCP allows action?"}
    S2 -- NO --> Denied
    S2 -- YES --> S3{"3. Resource Policy allows action?"}
    S3 -- YES --> S4{"4. Permission Boundary restricts action?"}
    S3 -- NO --> S5{"5. Identity Policy allows action?"}
    S5 -- NO --> Denied
    S5 -- YES --> S4
    S4 -- RESTRICTED --> Denied
    S4 -- PERMITTED --> Allowed["ACCESS GRANTED"]
```

---

## 4. AWS Security Token Service (STS) & Temporary Credentials

Static AWS Access Keys (`AKIA...` + Secret Key) stored in config files are the leading cause of enterprise cloud security compromises. AWS solves this via **AWS STS**.

```mermaid
sequenceDiagram
    autonumber
    actor Caller as IAM User / EC2 / GitHub Actions
    participant STS as AWS Security Token Service (STS)
    participant S3 as Target Resource (Amazon S3)

    Caller->>STS: aws sts assume-role (Target Role ARN, Session Name)
    STS->>STS: Evaluates Role Trust Policy
    STS-->>Caller: Returns Temporary Credentials:<br>- AccessKeyId (starts with ASIA...)<br>- SecretAccessKey<br>- SessionToken (Expires in 1 hour)
    Caller->>S3: API Call with Session Token in Request Header
    S3->>S3: Cryptographically verifies STS token signature
    S3-->>Caller: API Call Succeeded!
```

- **Prefix Indicator**:
  - `AKIA...`: Permanent long-term credential (IAM User).
  - `ASIA...`: Short-lived temporary credential issued by STS.
- **The Session Token**: When using temporary credentials, requests must provide **both** the Access/Secret keys AND the `SessionToken` parameter. When the expiration time arrives, the credentials become mathematically invalid.

---

## 5. EC2 Instance Profiles: How Virtual Machines Access AWS

How does an application running on an EC2 instance read files from an S3 bucket or write metrics to CloudWatch without hardcoding access keys in the code?

```mermaid
flowchart TD
    subgraph IAM_Control["IAM Control Plane"]
        Role["IAM Role: WebAppS3Role<br>- Permissions: s3:GetObject on 'my-bucket/*'<br>- Trust Policy: Allows ec2.amazonaws.com to assume"]
    end

    subgraph EC2_VM["EC2 Instance (Virtual Machine)"]
        Prof["EC2 Instance Profile (Container for the Role)"]
        App["Your Application (Python Boto3 / AWS SDK)"]
        IMDS["Instance Metadata Service (169.254.169.254)"]
        
        App -->|"1. SDK automatically requests credentials"| IMDS
        IMDS -->|"2. Fetches short-lived STS tokens"| Prof
        Prof -.->|"Associated"| Role
        IMDS -->>|"3. Injects ASIA... keys into memory"| App
    end

    App -->|"4. Calls S3 using temporary STS credentials"| S3[("Amazon S3 Bucket")]
```

---

## 6. AWS KMS & Envelope Encryption

### Why Direct KMS Encryption Fails at Scale
AWS Key Management Service (KMS) protects Customer Master Keys (CMKs) inside tamper-resistant **Hardware Security Modules (HSMs)**.
- *Limitation*: The KMS API restricts direct cryptographic operations to payloads under **4 KB**.
- If you have a 500 MB database backup or 10 GB video file, streaming gigabytes of data over the network to KMS would cause massive latency and cost thousands in API fees.

### The Solution: Envelope Encryption
Envelope encryption encrypts plaintext data with a unique, local **Data Encryption Key (DEK)**, and encrypts that Data Key with the root **KMS Key**.

```mermaid
flowchart TD
    subgraph KMS_HSM["AWS KMS Hardware Security Module"]
        KMSKey["KMS Root Key (Never leaves HSM boundary)"]
    end

    subgraph AppMemory["Local Application Memory (Compute Node)"]
        Data["Customer Dataset (e.g., 500 MB)"]
        PlainDEK["Plaintext Data Key (DEK) - 256 bits"]
        EncDEK["Encrypted Data Key (CipherDEK)"]
        EncData["Encrypted Dataset (AES-256 GCM)"]
    end

    KMSKey -->|"1. GenerateDataKey API"| PlainDEK
    KMSKey -->|"2. Returns Encrypted DEK"| EncDEK
    Data -->|"3. Encrypted locally with PlainDEK"| EncData
    PlainDEK -->|"4. Plaintext DEK wiped from memory immediately!"| Trash["Purged"]
    
    subgraph FinalStorage["Disk Storage (S3 / EBS)"]
        Saved["Stored on Disk: [ Encrypted Dataset + Encrypted DEK ]"]
    end

    EncData --> Saved
    EncDEK --> Saved
```

#### How Decryption Works
1. To read the file, the application reads the stored `Encrypted DEK` and calls `kms:Decrypt(Encrypted DEK)`.
2. KMS decrypts the 256-bit key inside its HSM and returns the `Plaintext DEK` to application RAM.
3. The application decrypts the 500 MB dataset locally using fast CPU instructions and immediately zeroes the plaintext key from memory.
