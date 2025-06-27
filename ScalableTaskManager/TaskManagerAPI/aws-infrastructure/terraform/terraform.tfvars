# AWS Configuration
aws_region = "us-east-1"
environment = "production"

# EC2 Configuration
ami_id = "ami-0c02fb55956c7d316"  # Amazon Linux 2 AMI (us-east-1)
instance_type = "t3.micro"  # Free tier eligible
key_pair_name = "taskmanager-key"  # You'll create this in AWS Console

# RDS Configuration
db_instance_class = "db.t3.micro"  # Free tier eligible
db_username = "taskmanager"
db_password = "YourSecurePassword123!"  # CHANGE THIS!
enable_multi_az = false  # Set to true for production

# Auto Scaling Configuration
asg_min_size = 1
asg_max_size = 3
asg_desired_capacity = 1

# SNS Alerts Configuration
alert_email = "your-email@example.com"  # CHANGE THIS! 