# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "4.53.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-west-2"
# }

# resource "aws_vpc" "testvpc" {
#   cidr_block = "10.1.0.0/16"
#   tags = {
#     Name = "Test VPC"
#   }
# }

# resource "aws_subnet" "public_subnet" {
#   vpc_id            = aws_vpc.testvpc.id
#   cidr_block        = "10.1.1.0/24"
#   availability_zone = "us-west-2a"
#   tags = {
#     Name = "PublicSubnet"
#   }
# }

# resource "aws_subnet" "private_subnet" {
#   vpc_id            = aws_vpc.testvpc.id
#   cidr_block        = "10.1.2.0/24"
#   availability_zone = "us-west-2a"
#   tags = {
#     Name = "PrivateSubnet"
#   }
# }

# resource "aws_internet_gateway" "labigw" {
#   vpc_id = aws_vpc.testvpc.id

#   tags = {
#     Name = "Lab IGW"
#   }
# }

# resource "aws_eip" "static_ip" {
#   vpc = true
#   tags = {
#     Name = "NAT GW Static IP"
#   }
# }

# resource "aws_nat_gateway" "labnatgw" {
#   allocation_id = aws_eip.static_ip.id
#   subnet_id     = aws_subnet.public_subnet.id

#   tags = {
#     Name = "Lab NAT GW"
#   }

#   depends_on = [aws_internet_gateway.labigw, aws_eip.static_ip]
# }