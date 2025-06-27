output "application_load_balancer_dns" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.taskmanager_alb.dns_name
}

output "application_load_balancer_zone_id" {
  description = "Hosted zone ID of the Application Load Balancer"
  value       = aws_lb.taskmanager_alb.zone_id
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.taskmanager_db.endpoint
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.taskmanager_db.port
}

output "auto_scaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.taskmanager_asg.name
}

output "auto_scaling_group_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.taskmanager_asg.arn
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = aws_sns_topic.taskmanager_alerts.arn
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.taskmanager_logs.name
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.taskmanager_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

output "security_group_alb_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "security_group_ec2_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2_sg.id
}

output "security_group_rds_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds_sg.id
}

output "iam_role_ec2_arn" {
  description = "ARN of the EC2 IAM role"
  value       = aws_iam_role.taskmanager_ec2_role.arn
}

output "application_url" {
  description = "Application URL (Load Balancer DNS)"
  value       = "http://${aws_lb.taskmanager_alb.dns_name}"
}

# Enhanced Infrastructure Outputs

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = [aws_nat_gateway.nat_1.id, aws_nat_gateway.nat_2.id]
}

output "nat_gateway_ips" {
  description = "Public IP addresses of the NAT Gateways"
  value       = [aws_eip.nat_1.public_ip, aws_eip.nat_2.public_ip]
}

output "elasticache_redis_endpoint" {
  description = "ElastiCache Redis primary endpoint"
  value       = aws_elasticache_replication_group.taskmanager_redis.primary_endpoint_address
}

output "elasticache_redis_port" {
  description = "ElastiCache Redis port"
  value       = aws_elasticache_replication_group.taskmanager_redis.port
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for static assets"
  value       = aws_s3_bucket.taskmanager_assets.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket for static assets"
  value       = aws_s3_bucket.taskmanager_assets.arn
}

output "secrets_manager_secret_arn" {
  description = "ARN of the Secrets Manager secret for database credentials"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "vpc_endpoint_s3_id" {
  description = "ID of the S3 VPC Endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "vpc_endpoint_secrets_manager_id" {
  description = "ID of the Secrets Manager VPC Endpoint"
  value       = aws_vpc_endpoint.secretsmanager.id
}

output "security_group_elasticache_id" {
  description = "ID of the ElastiCache security group"
  value       = aws_security_group.elasticache_sg.id
}

output "security_group_vpc_endpoint_id" {
  description = "ID of the VPC Endpoint security group"
  value       = aws_security_group.vpc_endpoint_sg.id
}

output "deployment_summary" {
  description = "Summary of deployed AWS services"
  value = {
    "ALB_DNS"                = aws_lb.taskmanager_alb.dns_name
    "ASG_Name"               = aws_autoscaling_group.taskmanager_asg.name
    "ASG_Min_Size"           = aws_autoscaling_group.taskmanager_asg.min_size
    "ASG_Max_Size"           = aws_autoscaling_group.taskmanager_asg.max_size
    "ASG_Desired"            = aws_autoscaling_group.taskmanager_asg.desired_capacity
    "RDS_Endpoint"           = aws_db_instance.taskmanager_db.endpoint
    "RDS_Multi_AZ"           = aws_db_instance.taskmanager_db.multi_az
    "ElastiCache_Endpoint"   = aws_elasticache_replication_group.taskmanager_redis.primary_endpoint_address
    "S3_Bucket"              = aws_s3_bucket.taskmanager_assets.bucket
    "Secrets_Manager_ARN"    = aws_secretsmanager_secret.db_credentials.arn
    "NAT_Gateway_IPs"        = [aws_eip.nat_1.public_ip, aws_eip.nat_2.public_ip]
    "SNS_Topic"              = aws_sns_topic.taskmanager_alerts.arn
    "VPC_ID"                 = aws_vpc.taskmanager_vpc.id
    "Environment"            = var.environment
  }
}

output "architecture_endpoints" {
  description = "Key endpoints for the multi-tier architecture"
  value = {
    "Application_URL"        = "http://${aws_lb.taskmanager_alb.dns_name}"
    "Database_Endpoint"      = aws_db_instance.taskmanager_db.endpoint
    "Cache_Endpoint"         = aws_elasticache_replication_group.taskmanager_redis.primary_endpoint_address
    "S3_Bucket"              = aws_s3_bucket.taskmanager_assets.bucket
    "Secrets_Manager_Secret" = aws_secretsmanager_secret.db_credentials.name
  }
} 