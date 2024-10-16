provider "aws" {
  region = "eu-west-1"
}

module "gab_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.2" 

  name = "gab_vpc"
  cidr = "10.98.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.98.96.0/19", "10.98.128.0/19", "10.98.160.0/19", "10.98.192.0/19", "10.98.224.0/19"]
  public_subnets  = ["10.98.0.0/19", "10.98.32.0/19", "10.98.64.0/19"]

  enable_nat_gateway = true 
  single_nat_gateway = true  

  enable_flow_log = true
  flow_log_cloudwatch_iam_role_arn   = aws_iam_role.vpc_flow_log_role.arn


  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "gab_vpc"
  }
}


resource "aws_iam_role" "vpc_flow_log_role" {
  name = "vpcFlowLogRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name   = "vpcFlowLogPolicy"
  role   = aws_iam_role.vpc_flow_log_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name              = "gab_vpc-flow-logs"
  retention_in_days = 7 
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.gab_vpc.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"

  route_table_ids = module.gab_vpc.public_route_table_ids

  tags = {
    Name = "s3-vpc-endpoint"
  }
}


# Output VPC ID
output "vpc_id" {
  value = module.gab_vpc.vpc_id
}

# Output Subnet IDs
output "private_subnet_ids" {
  value = module.gab_vpc.private_subnets
}

# Output the Public Subnet IDs
output "public_subnet_ids" {
  value = module.gab_vpc.public_subnets
}
