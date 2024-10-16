terraform {
  backend "s3" {
    bucket = "deel-test-1"
    key = "gab_vpc"
    region = "us-east-1" 
  }
}
