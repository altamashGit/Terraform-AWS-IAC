resource "aws_s3_bucket" "demo_project_bucket" {
    bucket = "demo-with-project-bucket-terraform"
  tags = {
    Name = "my-demo-project-bucket"
    environment = "dev"
  }
}