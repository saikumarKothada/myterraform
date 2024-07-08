# Defining provider for N.Virginia
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

resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-06c68f701d8090592" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    echo "Hello from Terraform!" > /var/www/html/index.html
  EOF

  tags = {
    Name = "my-ec2-instance"
  }
}

output "private_ip" {
  value = aws_instance.my_ec2_instance.private_ip
}
