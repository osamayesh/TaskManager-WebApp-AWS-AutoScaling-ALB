# 🎨 ASCII Art AWS Architecture Diagram

```
                                TaskManager AWS Architecture
    ╔══════════════════════════════════════════════════════════════════════════════════╗
    ║                                ☁️  AWS CLOUD                                      ║
    ║                                                                                  ║
    ║    👥 Client                                                                     ║
    ║       │                                                                         ║
    ║       │ HTTPS                                                                   ║
    ║       ▼                                                                         ║
    ║  ┌─────────────┐       ┌─────────────────┐       ┌──────────────┐              ║
    ║  │     1️⃣      │       │       2️⃣        │       │      3️⃣       │              ║
    ║  │     🌐      │ ────▶ │       🔄        │ ────▶ │      🟠       │              ║
    ║  │  Internet   │       │ Application     │       │   Amazon EC2  │              ║
    ║  │   Gateway   │       │ Load Balancer   │       │   t3.medium   │              ║
    ║  │             │       │                 │       │  Auto Scaling │              ║
    ║  └─────────────┘       └─────────────────┘       └──────────────┘              ║
    ║                                                           │                      ║
    ║                                                           │ TCP:3306            ║
    ║                                                           ▼                      ║
    ║                                                  ┌─────────────────┐            ║
    ║                                                  │       4️⃣        │            ║
    ║                                                  │       🗄️        │            ║
    ║                                                  │   Amazon RDS    │            ║
    ║                                                  │   MySQL 8.0     │            ║
    ║                                                  │   Multi-AZ      │            ║
    ║                                                  └─────────────────┘            ║
    ║                                                                                  ║
    ║  ╔════════════════════════════════════════════════════════════════════════════╗  ║
    ║  ║                        Supporting Services                                 ║  ║
    ║  ╚════════════════════════════════════════════════════════════════════════════╝  ║
    ║                                                                                  ║
    ║  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐    ║
    ║  │      🏗️      │   │      🔐      │   │      📈      │   │      📧      │    ║
    ║  │  Amazon VPC  │   │   AWS IAM    │   │  CloudWatch  │   │  Amazon SNS  │    ║
    ║  │ 10.0.0.0/16  │   │ Roles & Pols │   │ Logs/Metrics │   │ Email Alerts │    ║
    ║  │              │   │              │   │              │   │              │    ║
    ║  └──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘    ║
    ║         │                   │                   ▲                   ▲          ║
    ║         │ Network           │ Security          │ Monitoring        │ Alerts   ║
    ║         │ (dotted)          │ (dotted)          │ (solid)           │ (solid)  ║
    ║         ▼                   ▼                   │                   │          ║
    ║  ┌─────────────────────────────────────────────────────────────────────────┐   ║
    ║  │                    Resource Connections                                │   ║
    ║  │                                                                         │   ║
    ║  │  VPC ┄┄┄┄▶ ALB, EC2, RDS    (Network Infrastructure)                  │   ║
    ║  │  IAM ┄┄┄┄▶ EC2, RDS          (Security & Permissions)                 │   ║
    ║  │  EC2, RDS, ALB ────▶ CloudWatch  (Monitoring Data)                    │   ║
    ║  │  CloudWatch ────▶ SNS             (Alert Notifications)               │   ║
    ║  │                                                                         │   ║
    ║  └─────────────────────────────────────────────────────────────────────────┘   ║
    ║                                                                                  ║
    ╚══════════════════════════════════════════════════════════════════════════════════╝

    ┌─────────────────────────────────────────────────────────────────────────────────┐
    │                             Legend & Service Details                             │
    ├─────────────────────────────────────────────────────────────────────────────────┤
    │ 1️⃣ Internet Gateway: Public internet access entry point                         │
    │ 2️⃣ Application Load Balancer: HTTP/HTTPS traffic distribution & health checks   │
    │ 3️⃣ Amazon EC2: .NET Core app hosting with auto scaling (1-5 t3.medium)         │
    │ 4️⃣ Amazon RDS: MySQL database with Multi-AZ deployment & encryption            │
    │                                                                                 │
    │ 🏗️  Amazon VPC: Virtual private cloud network (10.0.0.0/16)                   │
    │ 🔐 AWS IAM: Identity and access management roles                               │
    │ 📈 CloudWatch: Monitoring, logging, and metrics collection                    │
    │ 📧 Amazon SNS: Email notifications for scaling and health alerts              │
    │                                                                                 │
    │ ──▶  Solid arrows: Data flow                                                  │
    │ ┄┄▶  Dotted arrows: Infrastructure/security relationships                     │
    └─────────────────────────────────────────────────────────────────────────────────┘
```

## Alternative Compact View:

```
       Client
         │
         ▼
    [1️⃣ IGW] ──▶ [2️⃣ ALB] ──▶ [3️⃣ EC2] ──▶ [4️⃣ RDS]
         │            │            │            │
         │            │            ▼            │
         │            │       [📈 CloudWatch] ──┘
         │            │            │
         │            │            ▼
         │            │       [📧 SNS]
         │            │
    [🏗️ VPC] ─────────┴────────────┘
         │
    [🔐 IAM] ─────────────────────────────────────┘

Legend:
IGW = Internet Gateway    ALB = App Load Balancer
EC2 = Amazon EC2         RDS = Amazon RDS MySQL
VPC = Virtual Private Cloud    IAM = Identity Access Management