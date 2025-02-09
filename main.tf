provider "aws" {
    region = "eu-north-1"
}

resource "aws_instance" "my_master" {
    ami = "ami-09a9858973b288bdd"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.default_subnet.default_id
}