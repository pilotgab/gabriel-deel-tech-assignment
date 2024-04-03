
variable "vpc_cidr" {}

variable "environment_type" {
  #  default = "dev"
}

variable "environment" {
  #  default = "dev"
}
variable "cluster_name" {

}
variable "map_public_ip_on_launch" {
  default = "false"
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "flow_log_cw_log_group_retention_days" {
  default = 0
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "True will create a single NAT gateway for all private subnets."
}

variable "one_nat_gateway_per_az" {
  type        = bool
  default     = false
  description = "True will create a NAT gateway per AZ, single_nat_gateway must be false to set it to true"
}