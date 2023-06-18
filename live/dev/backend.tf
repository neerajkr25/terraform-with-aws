terraform {
  backend "s3" {
    bucket = "dev-cadiy-tf-statelocking"
    key    = "dev-terraform.tfstate"
    region = "ap-south-1"
  }
}