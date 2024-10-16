data "aws_availability_zones" "all" {}

provider "aws" {
  region = "eu-west-1"
}

module "aws_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"
  name = "gab_vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.all.names
  public_subnets  = var.public_subnets
  private_subnets  = var.private_subnets
  enable_nat_gateway = true 
  single_nat_gateway = true  


  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "gab_vpc"
  }
}

