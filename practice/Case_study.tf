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
    user = "terraform user"
  }
}
# creates a internet gateway on VPC
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "my_igw"
        user = "terraform user"
    }
}

# creates a routetable and route to internet gateway
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

# public subnet and route table association
resource "aws_route_table_association" "my_association" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.my_route_table.id
}


# Create public subnet
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
    user = "terraform user"
  }
}

# Create private subnet 
resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "private_subnet"
    user = "terraform user"
  }
}

/* route already added while creating route table so not required here
 resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_subnet.public_subnet.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
} */

# creating security group 
resource "aws_security_group" "websg" {
  name        = "my-security-group"
  description = "Allow inbound traffic on port 80"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from all sources
  }
}

resource "aws_network_interface" "my_eni" {
  subnet_id       = aws_subnet.subnet1.id
  security_groups = [aws_security_group.websg.id]

  attachment {
    instance     = aws_instance.subnet1_ec2_instance.id
    device_index = 1
  }
}

# Create an EC2 instance in public subnet 
resource "aws_instance" "subnet1_ec2_instance" {
  ami           = "ami-04a81a99f5ec58529" # ubuntu AMI in N.verginia
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.websg.id]
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    echo "Hello from Terraform!" > /var/www/html/index.html
EOF

  tags = {
    Name = "subnet1-ec2-instance"
  }
}

# Create an EC2 instance in private subnet 
resource "aws_instance" "subnet2_ec2_instance" {
  ami           = "ami-04a81a99f5ec58529" # ubuntu AMI in N.verginia
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet2.id
    user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    echo "Hello from Terraform!" > /var/www/html/index.html
  EOF

  tags = {
    Name = "subnet2-ec2-instance"
  }
}
