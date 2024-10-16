
# Output VPC ID
output "vpc_id" {
  value = module.vpc.vpc_id
}

# Output Subnet IDs
output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

# Output the Public Subnet IDs
output "public_subnet_ids" {
  value = module.vpc.public_subnets
}
