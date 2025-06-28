# 🖼️ Architecture Diagrams

This directory contains visual representations of the TaskManager API AWS architecture.

## 🎯 **AWS Architecture Diagrams**

### **📊 Overview Architecture Diagram** - `aws-architecture-diagram.jpg`
- **Size**: 154KB
- **Format**: High-level overview diagram
- **Content**: Main infrastructure components and data flow
- **Best for**: Quick reference, executive summaries, high-level presentations

### **🏗️ Detailed Architecture Diagram** - `aws-architecture-detailed.jpeg`
- **Size**: 2.17MB  
- **Format**: Comprehensive detailed diagram
- **Content**: Complete multi-tier infrastructure with all AWS services, network topology, and component relationships
- **Features**: VPC endpoints, Multi-AZ deployment, detailed subnet architecture, all AWS services
- **Best for**: Technical documentation, architecture reviews, implementation reference

## 🏗️ **Architecture Components Shown**

The diagram displays the complete **multi-tier AWS architecture**:

### **🌐 Infrastructure**
- **VPC**: Multi-AZ virtual private cloud with isolated network
- **Public Subnets**: Internet-facing components (ALB, NAT Gateway)
- **Private Subnets**: Secure application and database tiers
- **Internet Gateway**: Public internet connectivity
- **NAT Gateway**: Secure outbound internet access for private resources

### **⚖️ Load Balancing & Compute**
- **Application Load Balancer**: Internet-facing with health checks and SSL termination
- **Auto Scaling Group**: Automatic instance scaling based on demand
- **EC2 Instances**: Multi-AZ deployment with .NET Core API

### **🗄️ Data & Storage**
- **RDS MySQL**: Multi-AZ deployment for high availability
- **ElastiCache Redis**: In-memory caching for improved performance
- **S3 Bucket**: Static asset storage and backup repository

### **🔒 Security & Management**
- **Secrets Manager**: Secure credential and configuration storage
- **VPC Endpoints**: Private connectivity to AWS services
- **CloudWatch**: Comprehensive monitoring and logging
- **SNS**: Real-time alerting and notifications
- **IAM Roles**: Secure service-to-service permissions

## 📁 **File Structure**

### **🖼️ Diagram Files**
| File | Description | Size | Purpose |
|------|-------------|------|---------|
| `aws-architecture-diagram.jpg` | Overview architecture diagram | 154KB | High-level reference and executive presentations |
| `aws-architecture-detailed.jpeg` | Detailed architecture diagram | 2.17MB | Technical documentation and implementation reference |
| `aws-architecture-diagram-hd.png` | Legacy high-resolution version | 207KB | Backup/comparison |
| `aws-architecture-diagram.svg` | Vector format | 78KB | Scalable web integration |

### **🛠️ Generation Tools**
| File | Purpose | Description |
|------|---------|-------------|
| `mermaid-diagram-code.txt` | Source Code | Mermaid code for legacy diagram |
| `generate-png.sh` | Automation | Shell script for diagram generation |
| `generate-diagram.md` | Documentation | Generation guide and instructions |

## 🎨 **Architecture Highlights**

### **🏗️ Multi-Tier Design**
- **Presentation Tier**: Application Load Balancer with SSL/TLS
- **Application Tier**: Auto-scaled EC2 instances running .NET Core
- **Data Tier**: RDS MySQL with Multi-AZ for high availability
- **Caching Tier**: ElastiCache Redis for performance optimization

### **🔧 Operational Excellence**
- **Monitoring**: CloudWatch metrics and custom dashboards
- **Alerting**: SNS-based notifications for critical events
- **Security**: Multi-layer security with VPC, Security Groups, and IAM
- **Backup**: Automated database backups and S3 storage

### **📈 Scalability Features**
- **Auto Scaling**: Automatic instance scaling based on CPU/memory
- **Load Balancing**: Traffic distribution across multiple instances
- **Database Scaling**: Read replicas and Multi-AZ deployment
- **Caching**: Redis for reduced database load and faster response

## 🚀 **Usage Recommendations**

### **For Documentation**
- Use the main architecture diagram for README files and technical documentation
- Reference specific components when explaining system functionality
- Include the diagram in project presentations and reviews

### **For Development**
- Use as reference for understanding system topology
- Guide infrastructure changes and component relationships
- Support troubleshooting and system optimization efforts

### **For Operations**
- Reference during incident response and system monitoring
- Guide capacity planning and scaling decisions
- Support security audits and compliance reviews

## 🔄 **Updating the Diagram**

If you need to modify the architecture diagram:

1. **Update the source**: Create or modify the architectural design
2. **Export as JPG/PNG**: Ensure high resolution for clarity
3. **Replace files**: Update `aws-architecture-diagram.jpg` (overview) or `aws-architecture-detailed.jpeg` (detailed)
4. **Update documentation**: Modify this README if components change
5. **Commit changes**: Push updates to version control

## 📋 **Technical Specifications**

### **Diagram Standards**
- **Format**: JPG/PNG for compatibility and clarity
- **Resolution**: High-resolution for detailed viewing
- **Color Scheme**: AWS official colors for service identification
- **Layout**: Logical flow from client to data storage

### **AWS Service Representation**
- **Official Icons**: AWS service-specific iconography
- **Color Coding**: Service category color conventions
- **Flow Direction**: Clear data and control flow indicators
- **Security Boundaries**: Visual separation of security zones

---

**Diagram Status**: ✅ **Updated Architecture** | 🏗️ **Multi-Tier Design** | 🔒 **Security Focused** | 📈 **Scalable** 