#Configure the AWS Provider.,
provider "aws" {
  region = "us-east-1"
}

# Define variables for the vpc scalable
variable "vpc_id" {
  default = "vpc-08fcbd2bedfbbddaa" 
  }

variable "db_password" {
    }


resource "aws_subnet" "private_subnet" {
  vpc_id            = "vpc-08fcbd2bedfbbddaa" 
  cidr_block        = "192.168.192.0/19"
  availability_zone = "us-east-1a"

  tags = {
    Name = "dopso2-private-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = "vpc-08fcbd2bedfbbddaa" 
  cidr_block        = "192.168.224.0/19"
  availability_zone = "us-east-1b"

  tags = {
    Name = "dopso2-private-subnet2"
  }
}

resource "aws_db_instance" "db_instance" {
  identifier             = "db_instance"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "14.1"
  username               = "admin"
  password               = var.db_password
  skip_final_snapshot    = true
}

resource "aws_ecr_repository" "ecr" {
  name                 = "dopso2-fe"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "Development"
    Name        = "dopso2-fe"
  }
}

resource "aws_ecr_repository" "ecr01" {
  name                 = "dopso2-be"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "Development"
    Name        = "dopso2-be"
  }
}

terraform {

  backend "s3" {

    bucket = "dops02-terraform"

    key    = "state-file-folder"

    region = "us-east-2"

  }

}

 