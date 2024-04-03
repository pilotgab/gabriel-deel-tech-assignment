output "vpc" {
  value = module.vpc
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}


output "database_subnet_group_name" {

  value = module.vpc.database_subnet_group_name


}
output "db_cidr_block" {
  value = module.vpc.database_subnets_cidr_blocks
}

output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "combined_route_table_ids" {
  value = concat(module.vpc.public_route_table_ids, module.vpc.private_route_table_ids)
}