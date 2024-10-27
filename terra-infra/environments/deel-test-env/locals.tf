locals {
  cluster_name     = var.environment
  environment_type = var.environment
  environment      = var.environment
  region           = var.region
  tags = {
    Environment = "deel-test"
    ManagedBy   = "terraform"
  }
}
