terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

# VPC Configuration
resource "aws_vpc" "taskmanager_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "TaskManager-VPC"
    Environment = var.environment
  }
}

# Internet Gateway
resource "aws_internet_gateway" "taskmanager_igw" {
  vpc_id = aws_vpc.taskmanager_vpc.id

  tags = {
    Name = "TaskManager-IGW"
    Environment = var.environment
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.taskmanager_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "TaskManager-Public-Subnet-1"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.taskmanager_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "TaskManager-Public-Subnet-2"
    Environment = var.environment
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.taskmanager_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "TaskManager-Private-Subnet-1"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.taskmanager_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "TaskManager-Private-Subnet-2"
    Environment = var.environment
  }
}

# Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.taskmanager_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.taskmanager_igw.id
  }

  tags = {
    Name = "TaskManager-Public-RT"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_1" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.taskmanager_igw]

  tags = {
    Name = "TaskManager-NAT-EIP-1"
    Environment = var.environment
  }
}

resource "aws_eip" "nat_2" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.taskmanager_igw]

  tags = {
    Name = "TaskManager-NAT-EIP-2"
    Environment = var.environment
  }
}

# NAT Gateways
resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "TaskManager-NAT-Gateway-1"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_2.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name = "TaskManager-NAT-Gateway-2"
    Environment = var.environment
  }
}

# Private Route Tables
resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.taskmanager_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }

  tags = {
    Name = "TaskManager-Private-RT-1"
    Environment = var.environment
  }
}

resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.taskmanager_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_2.id
  }

  tags = {
    Name = "TaskManager-Private-RT-2"
    Environment = var.environment
  }
}

# Private Route Table Associations
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt_2.id
}

# Security Groups
resource "aws_security_group" "alb_sg" {
  name_prefix = "taskmanager-alb-sg"
  vpc_id      = aws_vpc.taskmanager_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TaskManager-ALB-SG"
    Environment = var.environment
  }
}

resource "aws_security_group" "ec2_sg" {
  name_prefix = "taskmanager-ec2-sg"
  vpc_id      = aws_vpc.taskmanager_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TaskManager-EC2-SG"
    Environment = var.environment
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "taskmanager-rds-sg"
  vpc_id      = aws_vpc.taskmanager_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  tags = {
    Name = "TaskManager-RDS-SG"
    Environment = var.environment
  }
}

# Security Group for ElastiCache
resource "aws_security_group" "elasticache_sg" {
  name_prefix = "taskmanager-elasticache-sg"
  vpc_id      = aws_vpc.taskmanager_vpc.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  tags = {
    Name = "TaskManager-ElastiCache-SG"
    Environment = var.environment
  }
}

# Security Group for VPC Endpoints
resource "aws_security_group" "vpc_endpoint_sg" {
  name_prefix = "taskmanager-vpc-endpoint-sg"
  vpc_id      = aws_vpc.taskmanager_vpc.id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TaskManager-VPC-Endpoint-SG"
    Environment = var.environment
  }
}

# Application Load Balancer
resource "aws_lb" "taskmanager_alb" {
  name               = "taskmanager-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "TaskManager-ALB"
    Environment = var.environment
  }
}

# Target Group
resource "aws_lb_target_group" "taskmanager_tg" {
  name     = "taskmanager-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.taskmanager_vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "TaskManager-TG"
    Environment = var.environment
  }
}

# ALB Listener
resource "aws_lb_listener" "taskmanager_listener" {
  load_balancer_arn = aws_lb.taskmanager_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.taskmanager_tg.arn
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "taskmanager_db_subnet_group" {
  name       = "taskmanager-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name = "TaskManager-DB-Subnet-Group"
    Environment = var.environment
  }
}

# RDS Instance
resource "aws_db_instance" "taskmanager_db" {
  identifier     = "taskmanager-db"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = var.db_instance_class
  
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"
  storage_encrypted     = true

  db_name  = "TaskManagerDB"
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.taskmanager_db_subnet_group.name

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  multi_az = var.enable_multi_az

  skip_final_snapshot = true

  tags = {
    Name = "TaskManager-DB"
    Environment = var.environment
  }
}

# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "taskmanager_cache_subnet_group" {
  name       = "taskmanager-cache-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name = "TaskManager-Cache-Subnet-Group"
    Environment = var.environment
  }
}

# ElastiCache Redis Cluster
resource "aws_elasticache_replication_group" "taskmanager_redis" {
  replication_group_id       = "taskmanager-redis"
  description                = "TaskManager Redis cluster for session management and caching"
  
  node_type                  = "cache.t3.micro"
  port                       = 6379
  parameter_group_name       = "default.redis7"
  
  num_cache_clusters         = 2
  automatic_failover_enabled = true
  multi_az_enabled           = true
  
  subnet_group_name = aws_elasticache_subnet_group.taskmanager_cache_subnet_group.name
  security_group_ids = [aws_security_group.elasticache_sg.id]
  
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  tags = {
    Name = "TaskManager-Redis"
    Environment = var.environment
  }
}

# S3 Bucket for Static Assets and Backups
resource "aws_s3_bucket" "taskmanager_assets" {
  bucket = "taskmanager-assets-${random_string.bucket_suffix.result}"

  tags = {
    Name = "TaskManager-Assets"
    Environment = var.environment
  }
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "taskmanager_assets_versioning" {
  bucket = aws_s3_bucket.taskmanager_assets.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "taskmanager_assets_encryption" {
  bucket = aws_s3_bucket.taskmanager_assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "taskmanager_assets_pab" {
  bucket = aws_s3_bucket.taskmanager_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# AWS Secrets Manager Secret for Database Credentials
resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "taskmanager/database/credentials"
  description             = "Database credentials for TaskManager application"
  recovery_window_in_days = 7

  tags = {
    Name = "TaskManager-DB-Credentials"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    endpoint = aws_db_instance.taskmanager_db.endpoint
    port     = aws_db_instance.taskmanager_db.port
    dbname   = aws_db_instance.taskmanager_db.db_name
  })
}

# VPC Endpoints for AWS Services
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.taskmanager_vpc.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  
  route_table_ids = [
    aws_route_table.private_rt_1.id,
    aws_route_table.private_rt_2.id
  ]

  tags = {
    Name = "TaskManager-S3-VPC-Endpoint"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.taskmanager_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
  
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  
  private_dns_enabled = true

  tags = {
    Name = "TaskManager-SecretsManager-VPC-Endpoint"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.taskmanager_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
  
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  
  private_dns_enabled = true

  tags = {
    Name = "TaskManager-SSM-VPC-Endpoint"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id              = aws_vpc.taskmanager_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
  
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  
  private_dns_enabled = true

  tags = {
    Name = "TaskManager-SSMMessages-VPC-Endpoint"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "ec2_messages" {
  vpc_id              = aws_vpc.taskmanager_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
  
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  
  private_dns_enabled = true

  tags = {
    Name = "TaskManager-EC2Messages-VPC-Endpoint"
    Environment = var.environment
  }
}

# Launch Template
resource "aws_launch_template" "taskmanager_lt" {
  name_prefix   = "taskmanager-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.taskmanager_ec2_profile.name
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    db_endpoint = aws_db_instance.taskmanager_db.endpoint
    db_name     = aws_db_instance.taskmanager_db.db_name
    db_username = var.db_username
    db_password = var.db_password
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "TaskManager-Instance"
      Environment = var.environment
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "taskmanager_asg" {
  name                = "taskmanager-asg"
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  target_group_arns   = [aws_lb_target_group.taskmanager_tg.arn]
  health_check_type   = "ELB"
  health_check_grace_period = 300

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity

  launch_template {
    id      = aws_launch_template.taskmanager_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "TaskManager-ASG-Instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

# Auto Scaling Policies
resource "aws_autoscaling_policy" "taskmanager_scale_up" {
  name                   = "taskmanager-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown              = 300
  autoscaling_group_name = aws_autoscaling_group.taskmanager_asg.name
}

resource "aws_autoscaling_policy" "taskmanager_scale_down" {
  name                   = "taskmanager-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown              = 300
  autoscaling_group_name = aws_autoscaling_group.taskmanager_asg.name
}

# IAM Role for EC2 Instances
resource "aws_iam_role" "taskmanager_ec2_role" {
  name = "TaskManager-EC2-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "TaskManager-EC2-Role"
    Environment = var.environment
  }
}

# IAM Policy for EC2 Enhanced Access
resource "aws_iam_role_policy" "taskmanager_ec2_policy" {
  name = "TaskManager-EC2-Policy"
  role = aws_iam_role.taskmanager_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.taskmanager_assets.arn,
          "${aws_s3_bucket.taskmanager_assets.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.db_credentials.arn
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
          "ssm:DescribeParameters"
        ]
        Resource = "arn:aws:ssm:${var.aws_region}:*:parameter/taskmanager/*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "taskmanager_ec2_profile" {
  name = "TaskManager-EC2-Profile"
  role = aws_iam_role.taskmanager_ec2_role.name

  tags = {
    Name = "TaskManager-EC2-Profile"
    Environment = var.environment
  }
}

# SNS Topic for Alerts
resource "aws_sns_topic" "taskmanager_alerts" {
  name = "TaskManager-Alerts"

  tags = {
    Name = "TaskManager-Alerts"
    Environment = var.environment
  }
}

# SNS Topic Subscription (Email)
resource "aws_sns_topic_subscription" "taskmanager_alerts_email" {
  topic_arn = aws_sns_topic.taskmanager_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "taskmanager_logs" {
  name              = "/aws/ec2/taskmanager"
  retention_in_days = 14

  tags = {
    Name = "TaskManager-Logs"
    Environment = var.environment
  }
}

# CloudWatch Alarms with SNS Notifications
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "taskmanager-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization - Scale Up"
  alarm_actions       = [
    aws_autoscaling_policy.taskmanager_scale_up.arn,
    aws_sns_topic.taskmanager_alerts.arn
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.taskmanager_asg.name
  }

  tags = {
    Name = "TaskManager-CPU-High-Alarm"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "taskmanager-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "20"
  alarm_description   = "This metric monitors ec2 cpu utilization - Scale Down"
  alarm_actions       = [
    aws_autoscaling_policy.taskmanager_scale_down.arn,
    aws_sns_topic.taskmanager_alerts.arn
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.taskmanager_asg.name
  }

  tags = {
    Name = "TaskManager-CPU-Low-Alarm"
    Environment = var.environment
  }
}

# CloudWatch Alarm for High Memory Usage
resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "taskmanager-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"
  alarm_description   = "This metric monitors ec2 memory utilization"
  alarm_actions       = [aws_sns_topic.taskmanager_alerts.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.taskmanager_asg.name
  }

  tags = {
    Name = "TaskManager-Memory-High-Alarm"
    Environment = var.environment
  }
}

# CloudWatch Alarm for Application Health Check Failures
resource "aws_cloudwatch_metric_alarm" "health_check_failures" {
  alarm_name          = "taskmanager-health-check-failures"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Average"
  threshold           = "0"
  alarm_description   = "This metric monitors application health check failures"
  alarm_actions       = [aws_sns_topic.taskmanager_alerts.arn]

  dimensions = {
    TargetGroup  = aws_lb_target_group.taskmanager_tg.arn_suffix
    LoadBalancer = aws_lb.taskmanager_alb.arn_suffix
  }

  tags = {
    Name = "TaskManager-Health-Check-Failures"
    Environment = var.environment
  }
}

# CloudWatch Alarm for Database CPU
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "taskmanager-rds-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"
  alarm_description   = "This metric monitors RDS CPU utilization"
  alarm_actions       = [aws_sns_topic.taskmanager_alerts.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.taskmanager_db.id
  }

  tags = {
    Name = "TaskManager-RDS-CPU-High"
    Environment = var.environment
  }
}

# CloudWatch Alarm for ElastiCache CPU
resource "aws_cloudwatch_metric_alarm" "elasticache_cpu_high" {
  alarm_name          = "taskmanager-elasticache-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"
  alarm_description   = "This metric monitors ElastiCache CPU utilization"
  alarm_actions       = [aws_sns_topic.taskmanager_alerts.arn]

  dimensions = {
    CacheClusterId = aws_elasticache_replication_group.taskmanager_redis.id
  }

  tags = {
    Name = "TaskManager-ElastiCache-CPU-High"
    Environment = var.environment
  }
}

# CloudWatch Alarm for ElastiCache Memory
resource "aws_cloudwatch_metric_alarm" "elasticache_memory_high" {
  alarm_name          = "taskmanager-elasticache-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"
  alarm_description   = "This metric monitors ElastiCache memory utilization"
  alarm_actions       = [aws_sns_topic.taskmanager_alerts.arn]

  dimensions = {
    CacheClusterId = aws_elasticache_replication_group.taskmanager_redis.id
  }

  tags = {
    Name = "TaskManager-ElastiCache-Memory-High"
    Environment = var.environment
  }
} 