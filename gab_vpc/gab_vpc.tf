provider "aws" {
  region = "eu-west-1"
}

module "gab_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0" 

  name = "gab_vpc"
  cidr = "10.98.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.98.96.0/19", "10.98.128.0/19", "10.98.160.0/19", "10.98.192.0/19", "10.98.224.0/19"]
  public_subnets  = ["10.98.0.0/19", "10.98.32.0/19", "10.98.64.0/19"]

  enable_nat_gateway = true 
  single_nat_gateway = true  


  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "gab_vpc"
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
