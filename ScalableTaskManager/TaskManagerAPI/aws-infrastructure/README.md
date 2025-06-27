# 🏗️ TaskManager Multi-Tier AWS Infrastructure

This directory contains the complete **Terraform Infrastructure as Code (IaC)** for deploying a production-ready, highly available, and scalable TaskManager application on AWS using a comprehensive **multi-tier architecture**.

## 🌍 Architecture Overview

### **AWS Region**: us-east-1 (N. Virginia)
- **Multi-AZ Deployment**: Spans across us-east-1a and us-east-1b
- **High Availability**: Cross-AZ redundancy for all critical components
- **Auto Scaling**: Dynamic horizontal scaling (1-5 instances)
- **Security**: Multi-layer security with private subnets and VPC endpoints

## 🎯 Infrastructure Components

### 🌐 **Networking Layer**
| Component | Configuration | Details |
|-----------|---------------|---------|
| **VPC** | 10.0.0.0/16 | Custom Virtual Private Cloud |
| **Internet Gateway** | Single IGW | Internet connectivity for public resources |
| **NAT Gateways** | 2 NAT Gateways + Elastic IPs | Outbound internet access for private subnets |
| **Public Subnets** | 10.0.1.0/24, 10.0.2.0/24 | ALB and NAT Gateways |
| **Private Subnets** | 10.0.3.0/24, 10.0.4.0/24 | Application and database tiers |

### ⚖️ **Load Balancing & Auto Scaling**
| Component | Configuration | Details |
|-----------|---------------|---------|
| **Application Load Balancer** | Internet-facing, Multi-AZ | HTTP/HTTPS traffic distribution |
| **Target Groups** | Health checks enabled | Traffic routing to healthy instances |
| **Auto Scaling Group** | Min: 1, Max: 5, Desired: 2 | CPU-based dynamic scaling |
| **Launch Template** | t3.medium, Docker support | EC2 instance configuration |

### 💻 **Compute Layer**
| Component | Configuration | Details |
|-----------|---------------|---------|
| **EC2 Instances** | t3.medium | .NET Core API hosting |
| **Docker Containers** | Containerized deployment | Application isolation |
| **Multi-AZ Deployment** | us-east-1a & us-east-1b | High availability |
| **IAM Instance Profile** | Enhanced permissions | Access to AWS services |

### 🗄️ **Database Layer**
| Component | Configuration | Details |
|-----------|---------------|---------|
| **RDS MySQL 8.0** | db.t3.micro, Multi-AZ | Managed relational database |
| **Primary Instance** | us-east-1a | Active database server |
| **Standby Instance** | us-east-1b | Automatic failover |
| **Encryption** | Enabled at rest | Data security |
| **Automated Backups** | 7-day retention | Data protection |

### ⚡ **Caching Layer**
| Component | Configuration | Details |
|-----------|---------------|---------|
| **ElastiCache Redis** | cache.t3.micro, Multi-AZ | Session management and caching |
| **Replication Group** | 2 cache clusters | High availability caching |
| **Encryption** | In-transit and at-rest | Secure data handling |

### 🪣 **Storage Layer**
| Component | Configuration | Details |
|-----------|---------------|---------|
| **S3 Bucket** | Versioning enabled | Static assets, logs, backups |
| **Encryption** | AES256 | Server-side encryption |
| **Public Access** | Blocked | Security hardened |

### 🔒 **Security & Secrets Management**
| Component | Configuration | Details |
|-----------|---------------|---------|
| **Security Groups** | Multi-layer rules | Network-level security |
| **AWS Secrets Manager** | Database credentials | Secure credential storage |
| **IAM Roles & Policies** | Least privilege | Service permissions |
| **VPC Endpoints** | S3, Secrets Manager, SSM | Secure AWS service access |

### 📊 **Monitoring & Management**
| Component | Configuration | Details |
|-----------|---------------|---------|
| **CloudWatch** | Logs, metrics, dashboards | Comprehensive monitoring |
| **CloudWatch Alarms** | CPU, memory, health checks | Proactive alerting |
| **SNS Topics** | Email notifications | Alert delivery |
| **Systems Manager** | Parameter Store, Session Manager | Configuration management |

## 🗂️ File Structure

```
aws-infrastructure/
├── terraform/
│   ├── main.tf              # Main infrastructure configuration
│   ├── variables.tf         # Input variables
│   ├── outputs.tf           # Output values
│   ├── terraform.tfvars     # Variable values (create from example)
│   ├── terraform.tfvars.example  # Example variable values
│   └── user_data.sh         # EC2 instance initialization script
├── docker-compose.yml       # Local development setup
├── nginx.conf              # NGINX configuration for load balancing
└── README.md               # This file
```

## 🚀 Quick Start Deployment

### **Prerequisites**
```bash
# Required tools
- AWS CLI configured with appropriate permissions
- Terraform >= 1.0
- Docker (for local development)
```

### **Step 1: Configure Variables**
```bash
# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit with your specific values
nano terraform.tfvars
```

### **Step 2: Initialize Terraform**
```bash
cd terraform/
terraform init
```

### **Step 3: Plan Deployment**
```bash
terraform plan
```

### **Step 4: Deploy Infrastructure**
```bash
terraform apply -auto-approve
```

### **Step 5: Verify Deployment**
```bash
# Get the application URL
terraform output application_url

# View deployment summary
terraform output deployment_summary
```

## 📋 Required Variables

Create `terraform.tfvars` with the following variables:

```hcl
# Basic Configuration
aws_region    = "us-east-1"
environment   = "production"

# EC2 Configuration
ami_id        = "ami-0c55b159cbfafe1d0"  # Amazon Linux 2
instance_type = "t3.medium"
key_pair_name = "your-key-pair-name"

# Auto Scaling Configuration
asg_min_size         = 1
asg_max_size         = 5
asg_desired_capacity = 2

# Database Configuration
db_instance_class = "db.t3.micro"
db_username      = "admin"
db_password      = "your-secure-password"
enable_multi_az  = true

# Alerts Configuration
alert_email = "your-email@example.com"
```

## 🔧 Infrastructure Outputs

After successful deployment, you'll receive key outputs:

### **Application Access**
- **Application URL**: Load Balancer DNS name
- **Database Endpoint**: RDS connection string
- **Cache Endpoint**: ElastiCache Redis endpoint

### **Infrastructure Details**
- **VPC ID**: Virtual Private Cloud identifier
- **Subnet IDs**: Public and private subnet identifiers
- **Security Group IDs**: All security group identifiers
- **S3 Bucket**: Static assets storage bucket name

### **Enhanced Services**
- **NAT Gateway IPs**: Public IP addresses for outbound traffic
- **Secrets Manager ARN**: Database credentials storage
- **VPC Endpoint IDs**: Secure AWS service access points

## 📊 Monitoring & Alerts

### **CloudWatch Dashboards**
- **Application Metrics**: CPU, Memory, Request Count
- **Database Metrics**: Connections, Query Performance
- **Cache Metrics**: Hit Rate, Memory Usage
- **Load Balancer Metrics**: Target Health, Response Times

### **Automated Alerts**
- **High CPU Utilization**: Auto-scaling trigger
- **Database Performance**: Connection and CPU alerts
- **Application Health**: Target failure notifications
- **Cache Performance**: Memory and CPU monitoring

## 🔒 Security Features

### **Network Security**
- **Private Subnets**: Application and database isolation
- **Security Groups**: Multi-layer firewall rules
- **NACLs**: Additional network-level protection

### **Data Security**
- **Encryption at Rest**: RDS, ElastiCache, S3
- **Encryption in Transit**: All service communications
- **Secrets Management**: AWS Secrets Manager integration

### **Access Control**
- **IAM Roles**: Least privilege access
- **VPC Endpoints**: Secure AWS service communication
- **Session Manager**: Secure instance access without SSH

## 🎯 Traffic Flow

### **User Request Path**
1. **User** → **Application Load Balancer** (Health-checked routing)
2. **ALB** → **EC2 Instances** (Auto Scaling Group)
3. **EC2** → **ElastiCache Redis** (Session/Cache lookup)
4. **EC2** → **RDS MySQL** (Database operations)
5. **EC2** → **S3** (Static assets via VPC Endpoint)

### **Security Flow**
- **Private Subnets**: All application components isolated
- **NAT Gateways**: Controlled outbound internet access
- **VPC Endpoints**: Secure AWS service communication
- **Secrets Manager**: Secure credential retrieval

## 🛠️ Management Operations

### **Scaling Operations**
```bash
# Update Auto Scaling Group capacity
terraform apply -var="asg_desired_capacity=3"

# Update instance types
terraform apply -var="instance_type=t3.large"
```

### **Monitoring Operations**
```bash
# View CloudWatch logs
aws logs describe-log-groups --log-group-name-prefix "/aws/ec2/taskmanager"

# Check Auto Scaling activity
aws autoscaling describe-scaling-activities --auto-scaling-group-name <asg-name>
```

### **Database Operations**
```bash
# Create database snapshot
aws rds create-db-snapshot --db-instance-identifier <db-id> --db-snapshot-identifier <snapshot-id>

# Restore from snapshot
terraform apply -var="restore_from_snapshot=true"
```

## 🧹 Cleanup

To destroy the entire infrastructure:

```bash
terraform destroy -auto-approve
```

**⚠️ Warning**: This will permanently delete all resources including data!

## 📚 Additional Resources

- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Task Manager API Documentation](../README.md)

## 🆘 Troubleshooting

### **Common Issues**

1. **Terraform Init Fails**
   ```bash
   # Clear cache and reinitialize
   rm -rf .terraform
   terraform init
   ```

2. **Resource Limits**
   ```bash
   # Check AWS service limits
   aws service-quotas get-service-quota --service-code ec2 --quota-code L-1216C47A
   ```

3. **Deployment Failures**
   ```bash
   # Enable detailed logging
   export TF_LOG=DEBUG
   terraform apply
   ```

### **Support Contacts**
- **Infrastructure Issues**: Create GitHub issue
- **AWS Support**: AWS Support Center
- **Emergency**: Monitor CloudWatch alarms and SNS notifications

---

**Architecture Status**: ✅ Production Ready | 🌍 Multi-AZ | 🔄 Auto-Scaling | 🔒 Security Hardened | 📊 Fully Monitored 