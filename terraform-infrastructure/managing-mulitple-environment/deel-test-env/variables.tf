variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.40.0.0/16"
}

variable "private_subnets" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default = [
    "10.40.1.0/24",
    "10.40.2.0/24",
    "10.40.3.0/24",
    "10.40.6.0/24" # New subnet specifically for EKS
  ]
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default = ["10.40.4.0/24",
  "10.40.5.0/24"]
}

variable "region" {
  description = "AWS Region for the resources"
  default     = "eu-west-1"
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
  default     = "t2.large"
}