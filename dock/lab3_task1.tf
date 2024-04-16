# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "4.53.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-west-2"
# }

# //Virtual Private Cloud
# resource "aws_vpc" "testvpc" {
#   cidr_block       = "10.1.0.0/16"
# #   instance_tenancy = "default"

#   tags = {
#     Name = "Test VPC"
#   }
# }

# //Subnet 1
# resource "aws_subnet" "public_subnet" {
#   vpc_id     = aws_vpc.testvpc.id
#   cidr_block = "10.1.1.0/24"
#   availability_zone = "us-west-2a"

#   tags = {
#     Name = "PublicSubnet"
#   }
# }

# //Subnet2
# resource "aws_subnet" "private_subnet" {
#   vpc_id     = aws_vpc.testvpc.id
#   cidr_block = "10.1.2.0/24"
#   availability_zone = "us-west-2a"

#   tags = {
#     Name = "PrivateSubnet"
#   }
# }


# https://registry.terraform.io/providers/hashicorp/aws/4.53.0/docs
# https://registry.terraform.io/providers/hashicorp/aws/4.53.0/docs/resources/vpc
# https://registry.terraform.io/providers/hashicorp/aws/4.53.0/docs/resources/subnet