terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "project-backend-terraform-statefiles231-bucket"
    key    = "dev/backend/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    use_lockfile = true
  }
}