variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     =  "10.0.0.0/16"
}
variable "private_subnets" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vpc_database_subnets" {
  description = "subnets for the database"
  type = list(string)
  default = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}

variable "region" {
  description = "AWS Region for the resources"
  default     = "us-east-1"
}

variable "enable_private_subnet_internet_access" {
  description = "Enable internet access for private subnets"
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "enable cluster end public access"
  type        = bool
  default     = true
}

# EKS Cluster-specific variables

variable "desired_capacity" {
  description = "Desired capacity of node group"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Max capacity of node group"
  type        = number
  default     = 4
}

variable "min_capacity" {
  description = "Min capacity of node group"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Instance type for worker nodes"
  type        = string
  default     = "t2.micro"
}