terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myvpc"
  }
}

#PUB_SUBNET
resource "aws_subnet" "mysubpub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "mysubpub"
  }
}
#PVT_SUBNET
resource "aws_subnet" "mysubpvt" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "mysubpvt"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myigw"
  }
}
resource "aws_route_table" "myrtpub" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "myrtpub"
  }
}
resource "aws_route_table_association" "pubsubasso" {
  subnet_id      = aws_subnet.mysubpub.id
  route_table_id = aws_route_table.myrtpub.id
}

resource "aws_security_group" "mypubsg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "mysecgrp"
  }
}
resource "aws_instance" "webserver" {
  ami           =  "ami-076e3a557efe1aa9c"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.mypubsg.id}"]
  subnet_id =  aws_subnet.mysubpub.id
  associate_public_ip_address = true

  tags = {
    Name = "web"
  }
}


resource "aws_route_table" "myrtpvt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.mynatgw.id
  }

  tags = {
    Name = "myrtpvt"
  }
}
resource "aws_route_table_association" "pvtsubasso" {
  subnet_id      = aws_subnet.mysubpvt.id
  route_table_id = aws_route_table.myrtpvt.id
}


resource "aws_eip" "myeip" {
  #instance = aws_instance.web.id
  vpc      = true
}

resource "aws_nat_gateway" "mynatgw" {
  allocation_id = aws_eip.myeip.id
  subnet_id     = aws_subnet.mysubpub.id

  tags = {
    Name = "myngw"
  }

}


resource "aws_instance" "webserver1" {
  ami           =  "ami-076e3a557efe1aa9c"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.mypubsg.id}"]
  subnet_id =  aws_subnet.mysubpub.id
  associate_public_ip_address = true

  tags = {
    Name = "web"
  }
} 

resource "aws_instance" "database" {
  ami           =  "ami-076e3a557efe1aa9c"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.mypubsg.id}"]
  subnet_id =  aws_subnet.mysubpub.id
  #associate_public_ip_address = true

  tags = {
    Name = "pvt"
  }
} 



















