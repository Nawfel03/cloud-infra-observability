terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Generate a random string to make bucket name globally unique
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# 1. Create S3 Bucket
resource "aws_s3_bucket" "my_tf_portfolio" {
  bucket        = "tf-portfolio-${random_id.bucket_suffix.hex}"
  force_destroy = true
}

# 2. Upload Website HTML File to S3
resource "aws_s3_object" "portfolio_file" {
  bucket       = aws_s3_bucket.my_tf_portfolio.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

# Output the bucket name to the terminal
output "s3_bucket_name" {
  value       = aws_s3_bucket.my_tf_portfolio.bucket
  description = "Name of the newly created S3 bucket"
}
