resource "aws_instance" "web1" {
  ami           = var.ami
  instance_type = var.instancetype

  tags = {
    Name = "HelloWorld"
  }
}

