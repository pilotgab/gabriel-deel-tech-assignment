terraform {
  backend "s3" {
    bucket = "deel-test"
    key = "deel-test-1"
    region = "eu-west-1" 
  }
}
