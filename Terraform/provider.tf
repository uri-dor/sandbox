terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 0.13"
}

provider "aws" {
  region  = "ca-central-1"
  ignore_tags {
    # Ignore tags added by the "Resource Auto Tagger" tool
    keys = ["Created By", "Creation Date", "IAM Role Name", "IAM User Name"]
  }
}