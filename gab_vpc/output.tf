
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
