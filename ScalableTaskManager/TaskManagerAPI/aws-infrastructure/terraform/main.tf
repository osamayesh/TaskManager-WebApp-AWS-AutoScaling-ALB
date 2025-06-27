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

# IAM Policy for EC2 CloudWatch Access
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