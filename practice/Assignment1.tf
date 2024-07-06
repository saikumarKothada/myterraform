variable "secret"{
  type = string
}
variable "access" {
 type = string
}
provider "aws" {
  access_key = var.access
  secret_key = var.secret
  region = "us-east-2"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0862be96e41dcbf74" 
  instance_type = "t2.micro" 
#  subnet_id     = aws_default_subnet.default.id

  tags = {
    user = "terraformUser"
    Name = "MyEC2Instance"
  }
}

/* resource "aws_default_subnet" "default" {
  availability_zone = "us-east-2a" 
} */
