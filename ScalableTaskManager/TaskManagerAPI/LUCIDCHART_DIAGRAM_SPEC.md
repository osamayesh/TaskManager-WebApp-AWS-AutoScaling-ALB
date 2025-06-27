# 🎨 Lucidchart Diagram Specification

## Quick Copy-Paste Guide for TaskManager AWS Architecture

### 📐 Canvas Setup
- **Template**: AWS Architecture
- **Canvas Size**: 1200 x 800 pixels
- **Background**: White
- **Grid**: Enabled (helps with alignment)

### 🏗️ Main Container
1. **AWS Cloud Shape**: 
   - Search: "AWS Cloud"
   - Size: 1000 x 600 px
   - Title: "CloudFormation Stack"
   - Border: Dotted line, gray color

### 🔢 Main Data Flow (Left to Right)

#### Service Positions (X, Y coordinates from left):
1. **Internet Gateway** (150, 300)
   - Icon: "AWS Internet Gateway" 
   - Label: "1️⃣ Internet Gateway"
   - Color: Purple (#8C4FFF)

2. **Application Load Balancer** (350, 300)
   - Icon: "Elastic Load Balancing"
   - Label: "2️⃣ Application Load Balancer"
   - Color: Purple (#8C4FFF)

3. **Amazon EC2** (550, 300)
   - Icon: "Amazon EC2" 
   - Label: "3️⃣ Amazon EC2\nt3.medium\nAuto Scaling"
   - Color: Orange (#FF9900)

4. **Amazon RDS** (750, 300)
   - Icon: "Amazon RDS"
   - Label: "4️⃣ Amazon RDS\nMySQL 8.0\nMulti-AZ"
   - Color: Blue (#3F48CC)

### 📊 Supporting Services (Bottom Section)

#### Positions (X, Y):
1. **Amazon VPC** (200, 500)
   - Icon: "Amazon VPC"
   - Label: "Amazon VPC\n10.0.0.0/16"
   - Color: Purple (#8C4FFF)

2. **AWS IAM** (400, 500)
   - Icon: "AWS Identity and Access Management (IAM)"
   - Label: "AWS IAM\nRoles & Policies"
   - Color: Red (#FF4B4B)

3. **CloudWatch** (600, 500)
   - Icon: "Amazon CloudWatch"
   - Label: "CloudWatch\nLogs & Metrics"
   - Color: Green (#759C3E)

4. **Amazon SNS** (800, 500)
   - Icon: "Amazon Simple Notification Service (SNS)"
   - Label: "Amazon SNS\nEmail Alerts"
   - Color: Green (#759C3E)

### ➡️ Arrows and Connections

#### Solid Arrows (Data Flow):
- **Client** → **Internet Gateway** (thick black arrow)
- **Internet Gateway** → **ALB** (thick black arrow)
- **ALB** → **EC2** (thick black arrow)
- **EC2** → **RDS** (thick black arrow)

#### Monitoring Arrows (Green):
- **EC2** → **CloudWatch** (green arrow)
- **RDS** → **CloudWatch** (green arrow)
- **ALB** → **CloudWatch** (green arrow)
- **CloudWatch** → **SNS** (green arrow)

#### Dotted Lines (Security/Infrastructure):
- **VPC** ⇢ **ALB** (purple dotted)
- **VPC** ⇢ **EC2** (purple dotted)
- **VPC** ⇢ **RDS** (purple dotted)
- **IAM** ⇢ **EC2** (red dotted)
- **IAM** ⇢ **RDS** (red dotted)

### 🎨 Styling Details

#### Text Formatting:
- **Service Names**: Arial Bold, 12pt
- **Descriptions**: Arial Regular, 10pt
- **Numbers**: Arial Bold, 14pt, White text

#### Icon Sizes:
- **Main Services**: 80 x 80 pixels
- **Supporting Services**: 60 x 60 pixels

#### Color Palette:
```
Compute (EC2): #FF9900
Database (RDS): #3F48CC
Networking: #8C4FFF
Monitoring: #759C3E
Security: #FF4B4B
Background: #FFFFFF
```

### 📝 Text Labels (Copy these exactly):

**Internet Gateway:**
```
1️⃣
Internet Gateway
```

**Application Load Balancer:**
```
2️⃣
Application Load Balancer
HTTP/HTTPS Traffic
Health Checks
```

**Amazon EC2:**
```
3️⃣
Amazon EC2
t3.medium
Auto Scaling Group
1-5 instances
```

**Amazon RDS:**
```
4️⃣
Amazon RDS
MySQL 8.0
Multi-AZ Deployment
Encrypted Storage
```

**Amazon VPC:**
```
Amazon VPC
10.0.0.0/16
Public/Private Subnets
Security Groups
```

**AWS IAM:**
```
AWS IAM
EC2 Instance Profile
CloudWatch Permissions
Service Roles
```

**CloudWatch:**
```
CloudWatch
Application Logs
System Metrics
Custom Alarms
```

**Amazon SNS:**
```
Amazon SNS
Email Notifications
Scaling Alerts
Health Check Alerts
```

### 🔄 Quick Creation Steps:

1. **Open Lucidchart** → New Document → AWS Template
2. **Enable Shape Libraries**: AWS Architecture 2019, AWS Simple Icons
3. **Add AWS Cloud container** first
4. **Drag services** in the order listed above
5. **Position** using the coordinates provided
6. **Apply colors** using the color palette
7. **Add arrows** following the connection guide
8. **Add text labels** using the exact text provided
9. **Export** as PNG (300 DPI) when complete

### 💡 Pro Tips:
- Use **snap to grid** for perfect alignment
- **Group related services** for easy moving
- **Use consistent spacing** (150px between main services)
- **Test arrow connections** before finalizing
- **Preview** at different zoom levels

This specification will create a diagram identical to professional AWS architecture diagrams! 🎯 