terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-tests3-deletelater"
    key            = "path/to/your/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-testdynamodb-deletelater"
    encrypt        = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
}

# Terraform module to create AWS VPC resources
module "gtavpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "gta-vpc"
  cidr = "172.16.0.0/16" # or any other valid private range

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  public_subnets  = ["172.16.101.0/24", "172.16.102.0/24", "172.16.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
