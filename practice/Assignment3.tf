# Defining providers for Ohio and N.Virginia
provider "aws" {
  access_key = var.access
  secret_key = var.secret
  region = "us-east-1" # N.Virginia
}

provider "aws" {
  access_key = var.access
  secret_key = var.secret
  alias  = "ohio"
  region = "us-east-2" # Ohio
}
variable "secret"{
  type = string
}
variable "access" {
 type = string
}

# Create EC2 instances
resource "aws_instance" "hello_ohio" {
  provider = aws.ohio
  ami      = "ami-08be1e3e6c338b037" # ohio AMI ID ID
  instance_type = "t2.micro"
  tags = {
    Name = "hello-ohio"
    user = "terraformUser"
  }
}

resource "aws_instance" "hello_virginia" {
  ami      = "ami-06c68f701d8090592" # N.Virginia AMI ID
  instance_type = "t2.micro"
  tags = {
    Name = "hello-virginia"
    user = "terraformUser"
  }
}
