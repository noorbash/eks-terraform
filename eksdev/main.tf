# Specify the Terraform version
#required_version: Ensures that Terraform uses version 1.0.0 or newer. You can modify the version as per your requirements.
#required_providers: Specifies the source and version of the AWS provider. In this case, it will use the AWS provider version 4.x.
#provider "aws": Defines the AWS provider with a region passed as a variable (var.aws_region)

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.57.0"
    }
  }
}

provider "aws" {
  region = us-east-1
}


# S3 Backend Configuration
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"   # Replace with your bucket name
    key            = "terrform/terraform.tfstate"     # Path to the state file in the bucket
    region         = "us-east-1"                     # Replace with your region
    dynamodb_table = "terraform-lock-table"          # DynamoDB table for state locking
    encrypt        = true                            # Enable state file encryption
  }
}

# Calling the VPC module (using existing VPC and subnets)
module "vpc" {
  source  = "./modules/vpc"
  vpc_id  = var.vpc_id
  subnets = var.subnet_ids
}

# IAM roles for EKS and worker nodes
module "iam" {
  source          = "./modules/iam"
  eks_role_name   = "eks-cluster-role"
  node_role_name  = "eks-node-role"
}

# EKS cluster and node group with CPU auto-scaling
module "eks" {
  source          = "./modules/eks"
  cluster_name    = "eks-cluster"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.subnets
  cluster_role_arn = module.iam.eks_role_arn
  node_role_arn    = module.iam.node_role_arn
  ssh_key_name    = var.ssh_key_name
}

# Application Load Balancer
module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.subnets
  security_group_ids  = module.eks.cluster_sg
}

# EC2 instance with EBS volume
module "ec2" {
  source              = "./modules/ec2"
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.vpc.subnets[0]
  instance_type       = "t3.medium"
  key_name            = var.ssh_key_name
  ebs_volume_size     = 50
  security_group_ids  = module.eks.cluster_sg
}

# CloudWatch alarms
module "cloudwatch" {
  source             = "./modules/cloudwatch"
  cluster_name       = "eks-cluster"
  autoscaling_group  = module.eks.node_group_asg
}