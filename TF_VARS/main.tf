#create EC2 instance
resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instancetype
  count = var.instance_count
  tags = {
    Name = "web"

  }
}

#vi dev.tfvars
#vi prod.tfvars c4.xlarge

#terraform plan
#terraform plan --var-file="dev.tfvars"
#terraform plan --var-file="prod.tfvars"
