# ---------------------------------------------------------------------------------------------------------------------
# PROVIDER
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }

    github = {
      source = "integrations/github"
      version = "5.32.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "sandbox"
}
