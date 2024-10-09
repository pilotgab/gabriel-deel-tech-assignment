terraform {
  backend "s3" {
    bucket = "deel-test-1"
    key = "deel-test-infra"
    region = "eu-west-1" 
  }
}
