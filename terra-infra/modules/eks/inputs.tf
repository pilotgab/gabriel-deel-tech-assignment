variable "region" {
  description = "AWS region where the cluster will be created"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS Node Group"
  type        = string
}

variable "private_subnets" {
  description = "List of public subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID to be used by the EKS cluster"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of worker nodes in the EKS node group"
  type        = number
}

variable "max_capacity" {
  description = "Maximum number of worker nodes in the EKS node group"
  type        = number
}

variable "min_capacity" {
  description = "Minimum number of worker nodes in the EKS node group"
  type        = number
}

variable "instance_type" {
  description = "Instance type for the EKS worker nodes"
  type        = string
}
