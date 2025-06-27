# Task Manager API - AWS Solution Architecture

## Architecture Overview

This project implements a scalable, highly available Task Manager API using AWS cloud services with a 3-tier architecture pattern.

```mermaid
graph LR
    %% External Users
    Users["👥<br/>Users"]
    
    %% AWS Cloud Services with specific icons
    subgraph AWS["☁️ AWS Cloud"]
        
        %% Main data flow with AWS service icons
        IGW["1️⃣<br/>🌐<br/>Internet Gateway"]
        ALB["2️⃣<br/>🔄<br/>Application Load Balancer"]
        EC2["3️⃣<br/>🟠<br/>Amazon EC2<br/>Auto Scaling"]
        RDS["4️⃣<br/>🗄️<br/>Amazon RDS<br/>MySQL"]
        
        %% Supporting Services with specific AWS icons
        subgraph Support["AWS Supporting Services"]
            VPC["🏗️<br/>Amazon VPC<br/>Networking"]
            IAM["🔐<br/>AWS IAM<br/>Identity & Access"]
            CW["📈<br/>CloudWatch<br/>Monitoring"]
            SNS["📨<br/>Amazon SNS<br/>Notifications"]
        end
        
    end
    
    %% Data Flow
    Users --> IGW
    IGW --> ALB
    ALB --> EC2
    EC2 --> RDS
    
    %% Monitoring & Management
    EC2 --> CW
    RDS --> CW
    ALB --> CW
    CW --> SNS
    
    %% Security & Infrastructure
    IAM -.-> EC2
    IAM -.-> RDS
    VPC -.-> ALB
    VPC -.-> EC2
    VPC -.-> RDS
    
    %% AWS Service Color Styling
    classDef awsCompute fill:#FF9900,stroke:#232F3E,stroke-width:3px,color:#FFFFFF
    classDef awsDatabase fill:#3F48CC,stroke:#FFFFFF,stroke-width:3px,color:#FFFFFF
    classDef awsNetwork fill:#8C4FFF,stroke:#FFFFFF,stroke-width:3px,color:#FFFFFF
    classDef awsMonitoring fill:#759C3E,stroke:#FFFFFF,stroke-width:3px,color:#FFFFFF
    classDef awsManagement fill:#FF4B4B,stroke:#FFFFFF,stroke-width:3px,color:#FFFFFF
    classDef userAccess fill:#34495E,stroke:#2C3E50,stroke-width:2px,color:#FFFFFF
    
    class EC2 awsCompute
    class RDS awsDatabase
    class IGW,ALB,VPC awsNetwork
    class CW,SNS awsMonitoring
    class IAM awsManagement
    class Users userAccess
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