# This is the Backend for this project 

# S3 for Remote-Backend
resource "aws_s3_bucket" "s3_backend" {
    bucket = "terraform-eks-backend-state-file-bucket"
    lifecycle {
      prevent_destroy = false
    }
    tags = {
      Name = "terraform-eks-backend-state-file-bucket"
    }
}

resource "aws_s3_bucket_versioning" "s3_backend_versioning" {
  bucket = aws_s3_bucket.s3_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Dynamodb for Locking 
resource "aws_dynamodb_table" "dynamodb_locking" {
  name = "terraform-eks-backend-state-file-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "terraform-eks-backend-state-file-lock"
  }
}