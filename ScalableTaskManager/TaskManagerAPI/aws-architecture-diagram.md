# Task Manager API - AWS Solution Architecture

## Architecture Overview

This project implements a scalable, highly available Task Manager API using AWS cloud services with a 3-tier architecture pattern.

```mermaid
graph LR
    %% Client
    Client["👥<br/>Client"]
    
    %% AWS Cloud
    subgraph AWS["☁️ AWS Cloud"]
        
        %% Main Architecture Flow (4 steps)
        subgraph MainFlow["TaskManager AWS Architecture"]
            direction LR
            IGW["1️⃣<br/>🌐<br/>Internet<br/>Gateway"]
            ALB["2️⃣<br/>🔄<br/>Application<br/>Load Balancer"]
            EC2["3️⃣<br/>🟠<br/>Amazon EC2<br/>t3.medium<br/>Auto Scaling"]
            RDS["4️⃣<br/>🗄️<br/>Amazon RDS<br/>MySQL 8.0<br/>Multi-AZ"]
        end
        
        %% Supporting Services
        subgraph Support["Supporting Services"]
            VPC["🏗️<br/>Amazon VPC<br/>10.0.0.0/16"]
            IAM["🔐<br/>AWS IAM<br/>Roles & Policies"]
            CloudWatch["📈<br/>CloudWatch<br/>Logs & Metrics"]
            SNS["📧<br/>Amazon SNS<br/>Email Alerts"]
        end
    end
    
    %% Main data flow (solid arrows)
    Client --> IGW
    IGW --> ALB
    ALB --> EC2
    EC2 --> RDS
    
    %% Monitoring flow (solid arrows)
    EC2 --> CloudWatch
    RDS --> CloudWatch
    ALB --> CloudWatch
    CloudWatch --> SNS
    
    %% Infrastructure relationships (dotted arrows)
    VPC -.-> ALB
    VPC -.-> EC2
    VPC -.-> RDS
    IAM -.-> EC2
    IAM -.-> RDS
    
    %% AWS Service Colors (Official AWS Colors)
    classDef compute fill:#FF9900,stroke:#FFFFFF,stroke-width:2px,color:#FFFFFF
    classDef database fill:#3F48CC,stroke:#FFFFFF,stroke-width:2px,color:#FFFFFF
    classDef networking fill:#8C4FFF,stroke:#FFFFFF,stroke-width:2px,color:#FFFFFF
    classDef monitoring fill:#759C3E,stroke:#FFFFFF,stroke-width:2px,color:#FFFFFF
    classDef security fill:#FF4B4B,stroke:#FFFFFF,stroke-width:2px,color:#FFFFFF
    classDef client fill:#232F3E,stroke:#FF9900,stroke-width:2px,color:#FFFFFF
    
    %% Apply classes to nodes
    class EC2 compute
    class RDS database
    class IGW,ALB,VPC networking
    class CloudWatch,SNS monitoring
    class IAM security
    class Client client
```

## Infrastructure Components

### 🌐 Networking
- **VPC**: Custom Virtual Private Cloud (10.0.0.0/16)
- **Subnets**: Public (ALB) and Private (App/DB) across 2 AZs
- **Internet Gateway**: Internet connectivity
- **Route Tables**: Traffic routing configuration

### ⚖️ Load Balancing & Auto Scaling
- **Application Load Balancer**: Distributes HTTP/HTTPS traffic
- **Target Groups**: Health checks and traffic routing
- **Auto Scaling Group**: Dynamic scaling (1-5 instances)
- **Launch Template**: EC2 configuration template

### 💻 Compute
- **EC2 Instances**: t3.medium running .NET Core API
- **Docker Containers**: Containerized application deployment
- **Multi-AZ Deployment**: High availability across zones

### 🗄️ Database
- **Amazon RDS MySQL 8.0**: Managed database service
- **Multi-AZ**: Automatic failover capability
- **Encrypted Storage**: Data encryption at rest
- **Automated Backups**: 7-day retention policy

### 🔒 Security
- **Security Groups**: Network-level firewall rules
- **IAM Roles**: Service permissions and access control
- **Private Subnets**: Isolated application and database tiers

### 📊 Monitoring & Alerts
- **CloudWatch**: Centralized logging and monitoring
- **CloudWatch Alarms**: CPU, memory, and health monitoring
- **SNS**: Email notifications for critical events
- **Auto Scaling Policies**: CPU-based scaling triggers

## Deployment Features

✅ **High Availability**: Multi-AZ deployment across 2 availability zones  
✅ **Auto Scaling**: Automatic scaling based on CPU utilization  
✅ **Load Balancing**: Traffic distribution with health checks  
✅ **Security**: Multi-layer security with private subnets  
✅ **Monitoring**: Comprehensive logging and alerting  
✅ **Encryption**: Database encryption at rest  
✅ **Backup**: Automated database backups  
✅ **Infrastructure as Code**: Terraform deployment scripts  

## Getting Started

1. **Prerequisites**: AWS CLI, Terraform, Docker
2. **Configure**: Update `terraform.tfvars` with your settings
3. **Deploy**: Run `terraform apply` in the `aws-infrastructure/terraform/` directory
4. **Access**: Use the ALB DNS name output for application access

For detailed deployment instructions, see the [deployment documentation](./aws-infrastructure/README.md).