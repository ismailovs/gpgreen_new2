terraform {
  cloud {
    organization = "s_tc_1"

    workspaces {
      name = "gogreen"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = "us-west-2"
}