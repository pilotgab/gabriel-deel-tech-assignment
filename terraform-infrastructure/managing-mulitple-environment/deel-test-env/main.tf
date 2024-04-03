module "vpc" {
  source                  = "../../web-app-modules/vpc"
  cluster_name            = local.environment
  environment             = local.environment
  environment_type        = local.environment
  map_public_ip_on_launch = true
  vpc_cidr                = var.vpc_cidr
  private_subnets         = var.private_subnets
  public_subnets          = var.public_subnets

}


resource "aws_security_group" "eks_security_group" {
  name        = "eks-security-group"
  description = "Security group for EKS cluster"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-security-group"
  }
}


module "eks" {
  source = "../../web-app-modules/eks"
  region          = var.region
  cluster_name    = "Deel-Test"
  node_group_name = "deel-eks-nodes"
  private_subnets = [module.vpc.vpc_private_subnets[1],
  module.vpc.vpc_private_subnets[0]]

  security_group_id = [aws_security_group.eks_security_group.id]
  desired_capacity  = var.desired_capacity
  max_capacity      = var.max_capacity
  min_capacity      = var.min_capacity
  instance_type     = var.instance_type
}


module "cloudfront" {
  source      = "../../web-app-modules/cloudfront"
  region      = var.region
  bucket_name = "deel-test-report"
}


