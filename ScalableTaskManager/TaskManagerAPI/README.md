# Task Manager API - AWS Cloud Native Application

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![.NET Core](https://img.shields.io/badge/.NET_Core-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-623CE4?style=for-the-badge&logo=terraform&logoColor=white)

A scalable, cloud-native Task Manager API built with **.NET Core** and deployed on **AWS** using modern DevOps practices. Features auto-scaling, load balancing, and comprehensive monitoring.

## 🏗️ Solution Architecture

This project implements a **3-tier AWS architecture** with high availability, auto-scaling, and enterprise-grade security.

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

## 🚀 Features

### ✨ **Core Functionality**
- ✅ **CRUD Operations** - Create, Read, Update, Delete tasks
- ✅ **User Authentication** - JWT-based secure authentication
- ✅ **User Registration** - Account creation and management
- ✅ **Task Management** - Priority, status, and due date tracking
- ✅ **RESTful API** - Clean API design with proper HTTP methods
- ✅ **Web Interface** - Responsive web UI for task management

### 🏗️ **AWS Cloud Features**
- ✅ **Auto Scaling** - Automatic scaling based on CPU utilization
- ✅ **Load Balancing** - Application Load Balancer with health checks
- ✅ **High Availability** - Multi-AZ deployment across 2 availability zones
- ✅ **Security** - Multi-layer security with private subnets
- ✅ **Monitoring** - CloudWatch logging and alerting
- ✅ **Database** - RDS MySQL with automated backups
- ✅ **Infrastructure as Code** - Terraform deployment scripts

### 🔧 **Technical Features**
- ✅ **Containerization** - Docker containers for consistent deployment
- ✅ **Encryption** - Data encryption at rest and in transit
- ✅ **Backup & Recovery** - Automated database backups
- ✅ **Environment Configuration** - Separate dev/staging/prod environments
- ✅ **Logging** - Centralized application and system logging
- ✅ **Health Checks** - Application and infrastructure health monitoring

## 🛠️ Tech Stack

### **Backend**
- **Framework**: .NET Core 8.0
- **Language**: C#
- **ORM**: Entity Framework Core
- **Authentication**: JWT (JSON Web Tokens)
- **API Documentation**: Swagger/OpenAPI

### **Database**
- **Primary**: Amazon RDS MySQL 8.0
- **Development**: MySQL with Docker Compose
- **Features**: Multi-AZ, Encryption, Automated Backups

### **Infrastructure**
- **Cloud Provider**: Amazon Web Services (AWS)
- **Compute**: EC2 instances (t3.medium)
- **Load Balancer**: Application Load Balancer (ALB)
- **Auto Scaling**: Auto Scaling Groups with CPU-based policies
- **Networking**: VPC, Subnets, Security Groups
- **Monitoring**: CloudWatch, SNS
- **IaC**: Terraform

### **DevOps & Tools**
- **Containerization**: Docker & Docker Compose
- **Reverse Proxy**: Nginx
- **Deployment**: Infrastructure as Code (Terraform)
- **Monitoring**: AWS CloudWatch
- **Alerts**: Amazon SNS

## 📁 Project Structure

```
TaskManagerAPI/
├── 📁 Controllers/              # API Controllers
│   ├── AccountController.cs     # User account management
│   ├── AuthController.cs        # Authentication endpoints
│   ├── TasksController.cs       # Task CRUD operations
│   └── TasksWebController.cs    # Web interface controller
├── 📁 Models/                   # Data models
│   ├── DTOs/                    # Data Transfer Objects
│   ├── TaskItem.cs              # Task entity model
│   └── User.cs                  # User entity model
├── 📁 Services/                 # Business logic layer
│   ├── IAuthService.cs          # Authentication interface
│   ├── AuthService.cs           # Authentication implementation
│   ├── ITaskService.cs          # Task service interface
│   └── TaskService.cs           # Task service implementation
├── 📁 Data/                     # Data access layer
│   └── TaskManagerDbContext.cs  # Entity Framework context
├── 📁 Views/                    # MVC Views
│   ├── Account/                 # Account views
│   ├── Home/                    # Home page views
│   └── TasksWeb/                # Task management views
├── 📁 aws-infrastructure/       # AWS deployment
│   ├── terraform/               # Terraform IaC scripts
│   ├── docker-compose.yml       # Local development
│   └── nginx.conf              # Nginx configuration
├── 📁 Middleware/              # Custom middleware
├── 📄 Dockerfile              # Container configuration
├── 📄 Program.cs              # Application entry point
└── 📄 TaskManagerAPI.csproj   # Project configuration
```

## ⚡ Quick Start

### **Prerequisites**
- [.NET 8.0 SDK](https://dotnet.microsoft.com/download)
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [AWS CLI](https://aws.amazon.com/cli/) (for deployment)
- [Terraform](https://www.terraform.io/downloads.html) (for infrastructure)

### **1. Clone the Repository**
```bash
git clone https://github.com/osamayesh/TaskManager-WebApp-AWS-AutoScaling-ALB.git
cd TaskManager-WebApp-AWS-AutoScaling-ALB
```

### **2. Local Development Setup**
```bash
# Start MySQL database and API with Docker Compose
cd aws-infrastructure
docker-compose up -d

# The application will be available at:
# - API: http://localhost:5000
# - Web UI: http://localhost:80
```

### **3. AWS Deployment**
```bash
# Navigate to Terraform directory
cd aws-infrastructure/terraform

# Copy and configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your AWS settings

# Initialize and deploy
terraform init
terraform plan
terraform apply
```

## 🔧 Configuration

### **Environment Variables**
```bash
# Database Configuration
ConnectionStrings__DefaultConnection="Server=mysql;Database=TaskManagerDB_Dev;User=root;Password=yourpassword;"

# JWT Configuration
JWT__Key="your-super-secret-jwt-key-here"
JWT__Issuer="TaskManagerAPI"
JWT__Audience="TaskManagerAPI"
JWT__ExpiryInMinutes="60"

# Environment
ASPNETCORE_ENVIRONMENT="Production"
```

### **Terraform Variables**
```hcl
# terraform.tfvars
aws_region = "us-east-1"
environment = "production"
key_pair_name = "your-ec2-key-pair"
db_password = "your-secure-db-password"
alert_email = "your-email@example.com"
```

## 📚 API Documentation

### **Authentication Endpoints**
```http
POST /api/auth/register
POST /api/auth/login
```

### **Task Management Endpoints**
```http
GET    /api/tasks              # Get all tasks
GET    /api/tasks/{id}         # Get task by ID
POST   /api/tasks              # Create new task
PUT    /api/tasks/{id}         # Update task
DELETE /api/tasks/{id}         # Delete task
```

### **Sample API Requests**

#### **Register User**
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "SecurePassword123!"
  }'
```

#### **Create Task**
```bash
curl -X POST http://localhost:5000/api/tasks \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "title": "Complete project documentation",
    "description": "Write comprehensive README and API docs",
    "priority": "High",
    "status": "Pending",
    "dueDate": "2024-02-15T18:00:00Z"
  }'
```

## 🚀 Deployment Guide

### **Local Development**
1. **Start Services**: `docker-compose up -d`
2. **Access Application**: Navigate to `http://localhost:80`
3. **API Testing**: Use `http://localhost:5000/swagger`

### **AWS Production Deployment**

#### **Step 1: Prerequisites**
```bash
# Install required tools
aws configure  # Configure AWS credentials
terraform --version  # Verify Terraform installation
```

#### **Step 2: Deploy Infrastructure**
```bash
cd aws-infrastructure/terraform
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your configuration
terraform init
terraform plan
terraform apply
```

#### **Step 3: Access Application**
```bash
# Get the load balancer URL from Terraform output
terraform output application_load_balancer_dns
```

### **Monitoring & Maintenance**
- **CloudWatch Logs**: `/aws/ec2/taskmanager`
- **Metrics**: CPU, Memory, Database performance
- **Alerts**: Email notifications via SNS
- **Auto Scaling**: Automatic scaling based on CPU utilization

## 📊 Infrastructure Components

### **🌐 Networking**
- **VPC**: Custom Virtual Private Cloud (10.0.0.0/16)
- **Subnets**: Public (ALB) and Private (App/DB) across 2 AZs
- **Internet Gateway**: Internet connectivity
- **Route Tables**: Traffic routing configuration

### **⚖️ Load Balancing & Auto Scaling**
- **Application Load Balancer**: Distributes HTTP/HTTPS traffic
- **Target Groups**: Health checks and traffic routing
- **Auto Scaling Group**: Dynamic scaling (1-5 instances)
- **Launch Template**: EC2 configuration template

### **💻 Compute**
- **EC2 Instances**: t3.medium running .NET Core API
- **Docker Containers**: Containerized application deployment
- **Multi-AZ Deployment**: High availability across zones

### **🗄️ Database**
- **Amazon RDS MySQL 8.0**: Managed database service
- **Multi-AZ**: Automatic failover capability
- **Encrypted Storage**: Data encryption at rest
- **Automated Backups**: 7-day retention policy

### **🔒 Security**
- **Security Groups**: Network-level firewall rules
- **IAM Roles**: Service permissions and access control
- **Private Subnets**: Isolated application and database tiers

### **📊 Monitoring & Alerts**
- **CloudWatch**: Centralized logging and monitoring
- **CloudWatch Alarms**: CPU, memory, and health monitoring
- **SNS**: Email notifications for critical events
- **Auto Scaling Policies**: CPU-based scaling triggers

## 🔍 Monitoring & Troubleshooting

### **Health Checks**
- **Application**: `/health` endpoint
- **Load Balancer**: HTTP 200 response check
- **Database**: Connection and query performance

### **Logs Location**
```bash
# Application logs
/aws/ec2/taskmanager

# System logs
/var/log/cloud-init.log
/var/log/docker.log
```

### **Common Issues**
1. **Database Connection**: Check security groups and connection strings
2. **Auto Scaling**: Verify CloudWatch agent installation
3. **Load Balancer**: Check target group health status

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### **Development Guidelines**
- Follow .NET naming conventions
- Write unit tests for new features
- Update documentation for API changes
- Ensure Docker builds successfully

## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **AWS** for providing excellent cloud services
- **.NET Core** community for the robust framework
- **Terraform** for Infrastructure as Code capabilities
- **Docker** for containerization platform

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/osamayesh/TaskManager-WebApp-AWS-AutoScaling-ALB/issues)
- **Documentation**: This README and inline code comments
- **Email**: [Contact](mailto:your-email@example.com)

---

⭐ **Star this repository** if you find it useful!

---

**Built with ❤️ by [Osama Yesh](https://github.com/osamayesh)** 