terraform {
  backend "s3" {
    bucket = "gabvpc"
    key = "gab_vpc"
    region = "us-east-1" 
  }
}
