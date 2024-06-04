data "aws_availability_zones" "all" {}

locals {
  vpc_cidr = var.vpc_cidr
  azs      = data.aws_availability_zones.all.names
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = var.cluster_name
  cidr = local.vpc_cidr

  azs              = data.aws_availability_zones.all.names
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.vpc_database_subnets

  map_public_ip_on_launch      = var.map_public_ip_on_launch
  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = var.single_nat_gateway
  one_nat_gateway_per_az       = var.one_nat_gateway_per_az
  enable_dns_hostnames         = true
  enable_dns_support           = true

  enable_flow_log                                 = true
  create_flow_log_cloudwatch_log_group            = true
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cw_log_group_retention_days

  vpc_flow_log_tags = {
    Name = "${var.cluster_name}-vpc-flow-logs-cloudwatch-logs"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/Deel-Test" = "owned"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
    "karpenter.sh/discovery"                    = "${var.cluster_name}"
  }

  tags = {
    Environment = var.cluster_name
    Type        = "${var.environment_type}"
    ManagedBy   = "Terraform"
  }
}
