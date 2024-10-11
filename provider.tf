terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.13.1"
        }

    }
}

provider "aws" {
    region = "ap-northeast-1"
}

resource "aws_vpc" "example" {
    cidr_block = "172.17.0.0/16"

    tags  = {
        Name = "terraform_vpc"
    }
}
