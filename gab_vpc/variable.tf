variable "region" {
 description = "the vpc region"
 default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.98.0.0/16"
}
variable "private_subnets" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     =  ["10.98.96.0/19", "10.98.128.0/19", "10.98.160.0/19", "10.98.192.0/19", "10.98.224.0/19"]
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.98.0.0/19", "10.98.32.0/19", "10.98.64.0/19"]

}