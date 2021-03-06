resource "random_pet" "rndpet" {
  keepers = {
    env_name = "${var.env_name}"
  }
}

resource "aws_vpc" "bosh_vpc" {
  cidr_block       = local.bosh_vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "bosh-${random_pet.rndpet.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "bosh_public_subnet" {
  vpc_id            = aws_vpc.bosh_vpc.id
  cidr_block        = local.bosh_public_subnet_cidr
  availability_zone = local.bosh_public_subnet_az

  tags = {
    Name = "bosh"
  }
}

resource "aws_subnet" "bosh_private_subnet" {
  vpc_id            = aws_vpc.bosh_vpc.id
  cidr_block        = local.bosh_private_subnet_cidr
  availability_zone = local.bosh_private_subnet_az

  tags = {
    Name = "bosh"
  }
}

resource "aws_security_group" "bosh_public_sg" {
  name        = "bosh_public"
  description = "Allow inbound traffic from the concourse"
  vpc_id      = aws_vpc.bosh_vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.concourse_public_ip]
  }

  ingress {
    description = "Bosh agent from VPC"
    from_port   = 6868
    to_port     = 6868
    protocol    = "tcp"
    cidr_blocks = [var.concourse_public_ip]
  }

  ingress {
    description = "Bosh Director from VPC"
    from_port   = 25555
    to_port     = 25555
    protocol    = "tcp"
    cidr_blocks = [var.concourse_public_ip]
  }

  ingress {
    description = "Bosh Director from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bosh_public"
  }
}

resource "aws_security_group" "bosh_private_sg" {
  name        = "bosh_private"
  description = "Allow inbound traffic from the concourse"
  vpc_id      = aws_vpc.bosh_vpc.id
  
  ingress {
    description = "bosh DNS"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [local.bosh_vpc_cidr]
  }

  ingress {
    description = "Bosh Director from VPC"
    from_port   = 4222
    to_port     = 4222
    protocol    = "tcp"
    cidr_blocks = [local.bosh_vpc_cidr]
  }

  ingress {
    description = "Bosh agent from VPC"
    from_port   = 6868
    to_port     = 6868
    protocol    = "tcp"
    cidr_blocks = [local.bosh_vpc_cidr]
  }

  ingress {
    description = "Bosh agent from VPC"
    from_port   = 7777
    to_port     = 7777
    protocol    = "tcp"
    cidr_blocks = [local.bosh_vpc_cidr]
  }

  ingress {
    description = "Bosh agent from VPC"
    from_port   = 7788
    to_port     = 7788
    protocol    = "tcp"
    cidr_blocks = [local.bosh_vpc_cidr]
  }

  ingress {
    description = "Bosh agent from VPC"
    from_port   = 7799
    to_port     = 7799
    protocol    = "tcp"
    cidr_blocks = [local.bosh_vpc_cidr]
  }

  ingress {
    description = "Bosh agent from VPC"
    from_port   = 6868
    to_port     = 6868
    protocol    = "tcp"
    cidr_blocks = [local.bosh_vpc_cidr]
  }

  ingress {
    description = "Bosh Director from VPC"
    from_port   = 25250
    to_port     = 25250
    protocol    = "tcp"
    cidr_blocks = [local.bosh_vpc_cidr]
  }

  ingress {
    description = "Bosh Director from VPC"
    from_port   = 25555
    to_port     = 25555
    protocol    = "tcp"
    cidr_blocks = [local.bosh_vpc_cidr]
  }

  ingress {
    description = "Bosh Director from VPC"
    from_port   = 25777
    to_port     = 25777
    protocol    = "tcp"
    cidr_blocks = [local.bosh_vpc_cidr]
  }

  ingress {
    description = "Bosh Director from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bosh_private"
  }
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = var.env_name
  public_key = tls_private_key.this.public_key_openssh
}
