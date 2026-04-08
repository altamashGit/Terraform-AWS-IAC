# 1. s3 bucket for terraform state files
resource "aws_s3_bucket" "terraform_statefiles_bucket" {
  bucket = "project-backend-terraform-statefiles231-bucket"
  force_destroy = true
  tags = {
    Name = "my-terraform-statefiles-bucket"
    environment = "dev"
  }
}

# 2. dynamodb table for terraform state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "project-backend-terraform-locks-table12378"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}