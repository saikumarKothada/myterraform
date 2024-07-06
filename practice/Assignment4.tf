# Defining providers for N.Virginia
provider "aws" {
  access_key = var.access
  secret_key = var.secret
  region = "us-east-1" # N.Virginia
}

variable "secret"{
  type = string
}
variable "access" {
 type = string
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "ec2_vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "my_public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Create an EC2 instance
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-06c68f701d8090592" # Amazon Linux 2 AMI in N.verginia
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_public_subnet.id

  tags = {
    Name = "my-ec2-instance"
  }
}
