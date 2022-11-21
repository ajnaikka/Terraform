 terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Provider-Block
provider "aws" {
  region = "ap-south-1"
  }
# Create EC2 Instance

resource "aws_instance" "web1" {
  ami           = "ami-01216e7612243e0ef"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"
  #availability_zone = "ap-south-1b" changig terraform behaviour

  tags = {
    Name = "HelloWorld"
  }
  lifecycle {
    prevent_destroy = true  # Default is false
  }
}


#terraform destory --auto-approve