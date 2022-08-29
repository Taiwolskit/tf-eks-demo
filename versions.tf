terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      version = ">= 4.27"
    }
  }

  # backend "s3" {
  #   bucket         = "jcl-terraform-states"
  #   region         = "ap-northeast-1"
  #   key            = "projects/blabo/terraform.tfstate"
  #   dynamodb_table = "jcl-terraform-locks"
  # }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = terraform.workspace
      Project     = local.project_name
      Region      = var.region
    }
  }
}
