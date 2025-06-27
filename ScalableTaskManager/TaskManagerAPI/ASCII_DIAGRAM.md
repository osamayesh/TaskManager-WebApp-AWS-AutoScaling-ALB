#  Comprehensive TaskManager AWS Infrastructure ASCII Diagram

##  **AWS Region: us-east-1 (N. Virginia)**

```
                  TaskManager AWS Infrastructure - ACTUAL DEPLOYMENT
    
                                   AWS us-east-1 Region                          
                                                                                   
         Internet Users                                                          
                                                                                  
            HTTPS/HTTP                                                            
                                                                                  
                                                            
               1                                                                 
                                                                               
         Internet Gateway                                                        
         (taskmanager_igw)                                                       
                                                            
                                                                                  
                                                                                  
       
                               VPC: 10.0.0.0/16                                
                            (taskmanager_vpc)                                    
                                                                                  
          
                             PUBLIC TIER                                     
                                                                               
                                 
             AZ: us-east-1a             AZ: us-east-1b                     
            Public Subnet 1          Public Subnet 2                   
             10.0.1.0/24                10.0.2.0/24                        
                                 
                                                                             
          
                                                                               
                                                     
                                                                                
          
                      2 APPLICATION LOAD BALANCER                            
                                                                               
                 ALB: taskmanager-alb                                       
                 Target Group: taskmanager_tg                               
                 HTTP/HTTPS Listener                                        
                 Security Group: alb_sg                                     
          
                                                                                
                                      Forward to Target Group                   
                                                                                
          
                            PRIVATE TIER - COMPUTE                           
                                                                               
                                 
             AZ: us-east-1a             AZ: us-east-1b                     
            Private Subnet 1         Private Subnet 2                  
             10.0.3.0/24                10.0.4.0/24                        
                                                                           
            3 AUTO SCALING            3 AUTO SCALING                     
                                                                           
            EC2: t3.medium           EC2: t3.medium                    
            Launch Template          Launch Template                   
            Min: 1, Max: 5           Min: 1, Max: 5                    
            Desired: 2               Desired: 2                        
            Security: ec2_sg          Security: ec2_sg                   
                                 
          
                                                                                
                                      MySQL Connection (Port 3306)             
                                                                                
          
                           PRIVATE TIER - DATABASE                           
                                                                               
                         4 AMAZON RDS MYSQL 8.0                             
                                                                               
                 Instance: db.t3.micro                                     
                 Multi-AZ: TRUE (us-east-1a + us-east-1b)                  
                 DB Subnet Group: taskmanager_db_subnet_group               
                 Security Group: rds_sg                                     
                 Backup: 7-day retention                                    
                 Encryption: At rest                                        
          
       
                                                                                   
       
                                 SUPPORTING SERVICES                            
       
                                                                                   
             
                                                                 
        AWS IAM          CloudWatch       Amazon SNS      Route Tables   
                                                                         
        EC2 Role        CPU Alarms      Scale           Public RT    
        Instance        Memory           Alerts          Route to     
         Profile          Alarms          Health           IGW          
        RDS Access      Health           Alerts          0.0.0.0/0    
                          Checks          Email: Conf                   
             
                                                                                   
    

    ─
                           INFRASTRUCTURE SPECIFICATIONS                       
    
                                                                                 
      REGION & AVAILABILITY                                                    
        Region: us-east-1 (N. Virginia)                                        
        Availability Zones: us-east-1a, us-east-1b                             
        Multi-AZ Deployment: TRUE (High Availability)                          
                                                                                 
      NETWORKING ARCHITECTURE                                                  
        VPC CIDR: 10.0.0.0/16 (65,536 IP addresses)                           
        Public Subnets: 10.0.1.0/24 (us-east-1a), 10.0.2.0/24 (us-east-1b)  
        Private Subnets: 10.0.3.0/24 (us-east-1a), 10.0.4.0/24 (us-east-1b) 
        Internet Gateway: taskmanager_igw                                      
                                                                                 
      LOAD BALANCING & SCALING                                                 
        ALB Name: taskmanager-alb (Application Load Balancer)                  
        Target Group: taskmanager_tg                                           
        Auto Scaling Group: taskmanager_asg                                    
        Launch Template: taskmanager_lt                                        
        Scaling: Min=1, Max=5, Desired=2 instances                             
        Instance Type: t3.medium                                               
                                                                                 
      DATABASE CONFIGURATION                                                  
        Engine: MySQL 8.0                                                      
        Instance Class: db.t3.micro                                            
        Multi-AZ: TRUE (automatic failover)                                    
        Subnet Group: taskmanager_db_subnet_group                              
        Backup Retention: 7 days                                               
                                                                                 
      SECURITY CONFIGURATION                                                   
        ALB Security Group: alb_sg (HTTP/HTTPS from 0.0.0.0/0)                
        EC2 Security Group: ec2_sg (HTTP from ALB, SSH from anywhere)         
        RDS Security Group: rds_sg (MySQL 3306 from EC2 only)                 
        IAM Role: taskmanager_ec2_role + taskmanager_ec2_profile               
                                                                                 
      MONITORING & ALERTS                                                      
        CloudWatch Alarms: CPU High/Low, Memory, Health Checks, RDS CPU       
        Auto Scaling Policies: CPU-based scale up/down                         
        SNS Topic: taskmanager_alerts                                          
        Email Notifications: Configurable via alert_email variable            
                                                                                 
    
```
