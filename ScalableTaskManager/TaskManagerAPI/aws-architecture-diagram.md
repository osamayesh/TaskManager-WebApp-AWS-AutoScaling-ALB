# Task Manager API - AWS Solution Architecture

## Architecture Overview

This project implements a scalable, highly available Task Manager API using AWS cloud services with a 3-tier architecture pattern.

```mermaid
graph TB
    %% External Users
    Users[👥 Users/Clients]
    
    %% AWS Cloud
    subgraph AWS["☁️ AWS Cloud - Task Manager API"]
        direction TB
        
        %% Internet Gateway
        IGW[🌐 Internet Gateway]
        
        %% VPC
        subgraph VPC["🏢 VPC: 10.0.0.0/16"]
            direction TB
            
            %% Public Tier
            subgraph PublicTier["🌍 PUBLIC TIER"]
                direction LR
                subgraph AZ1["🏢 Availability Zone A"]
                    PubSub1[📡 Public Subnet<br/>10.0.1.0/24]
                end
                subgraph AZ2["🏢 Availability Zone B"] 
                    PubSub2[📡 Public Subnet<br/>10.0.2.0/24]
                end
                ALB[⚖️ Application Load Balancer<br/>• HTTP/HTTPS Traffic<br/>• Health Checks<br/>• SSL Termination]
            end
            
            %% Application Tier
            subgraph AppTier["💻 APPLICATION TIER"]
                direction LR
                subgraph AZ3["🏢 Availability Zone A"]
                    PrivSub1[🔒 Private Subnet<br/>10.0.3.0/24]
                    EC2_1[🖥️ EC2 Instance<br/>• t3.medium<br/>• .NET Core API<br/>• Docker Container<br/>• Auto Scaling]
                end
                subgraph AZ4["🏢 Availability Zone B"]
                    PrivSub2[🔒 Private Subnet<br/>10.0.4.0/24] 
                    EC2_2[🖥️ EC2 Instance<br/>• t3.medium<br/>• .NET Core API<br/>• Docker Container<br/>• Auto Scaling]
                end
                ASG[📈 Auto Scaling Group<br/>• Min: 1, Max: 5<br/>• CPU-based Scaling<br/>• Target Tracking]
            end
            
            %% Database Tier
            subgraph DataTier["🗄️ DATABASE TIER"]
                RDS[🐬 Amazon RDS MySQL<br/>• Version 8.0.x<br/>• Multi-AZ Deployment<br/>• Encrypted Storage<br/>• Automated Backups<br/>• 7-day Retention]
            end
            
        end
        
        %% Monitoring & Security
        subgraph Services["🔧 AWS SERVICES"]
            direction TB
            subgraph Security["🔐 Security"]
                SG[🛡️ Security Groups<br/>• ALB: 80,443 ← Internet<br/>• EC2: 80 ← ALB, 22 ← SSH<br/>• RDS: 3306 ← EC2]
                IAM[👤 IAM Roles<br/>• EC2 Instance Profile<br/>• CloudWatch Permissions]
            end
            
            subgraph Monitoring["📊 Monitoring & Alerts"]
                CW[📈 CloudWatch<br/>• Application Logs<br/>• System Metrics<br/>• Custom Metrics]
                SNS[📧 SNS Notifications<br/>• Email Alerts<br/>• Scaling Events<br/>• System Alarms]
                Alarms[⚠️ CloudWatch Alarms<br/>• CPU Utilization<br/>• Memory Usage<br/>• Health Checks<br/>• Database Performance]
            end
        end
    end
    
    %% Traffic Flow
    Users -->|HTTPS/HTTP| IGW
    IGW --> ALB
    ALB -->|HTTP:80| EC2_1
    ALB -->|HTTP:80| EC2_2
    EC2_1 -->|MySQL:3306| RDS
    EC2_2 -->|MySQL:3306| RDS
    
    %% Auto Scaling
    ASG -.->|Manages| EC2_1
    ASG -.->|Manages| EC2_2
    
    %% Security
    SG -.->|Protects| ALB
    SG -.->|Protects| EC2_1
    SG -.->|Protects| EC2_2
    SG -.->|Protects| RDS
    IAM -.->|Authorizes| EC2_1
    IAM -.->|Authorizes| EC2_2
    
    %% Monitoring
    EC2_1 -->|Logs & Metrics| CW
    EC2_2 -->|Logs & Metrics| CW
    RDS -->|Database Metrics| CW
    ALB -->|Load Balancer Metrics| CW
    CW --> Alarms
    Alarms -->|Triggers| SNS
    Alarms -->|Triggers| ASG
    
    %% Styling
    classDef awsCloud fill:#232F3E,stroke:#FF9900,stroke-width:3px,color:#FFFFFF
    classDef publicTier fill:#3498DB,stroke:#2980B9,stroke-width:2px,color:#FFFFFF
    classDef appTier fill:#27AE60,stroke:#229954,stroke-width:2px,color:#FFFFFF
    classDef dataTier fill:#8E44AD,stroke:#7D3C98,stroke-width:2px,color:#FFFFFF
    classDef securityService fill:#E74C3C,stroke:#C0392B,stroke-width:2px,color:#FFFFFF
    classDef monitoringService fill:#F39C12,stroke:#E67E22,stroke-width:2px,color:#FFFFFF
    classDef userService fill:#34495E,stroke:#2C3E50,stroke-width:2px,color:#FFFFFF
    
    class AWS awsCloud
    class PublicTier,ALB,IGW publicTier
    class AppTier,ASG,EC2_1,EC2_2 appTier
    class DataTier,RDS dataTier
    class Security,SG,IAM securityService
    class Monitoring,CW,SNS,Alarms monitoringService
    class Users userService
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