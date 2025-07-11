terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.2.0"
    }
  }
  # Backend for this 
  backend "s3" {
    bucket = "terraform-eks-backend-state-file-bucket"
    key = "terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraform-eks-backend-state-file-lock"
  }
}

provider "aws" {
  region = "eu-central-1"
}