terraform {
  required_version = ">= 1.5"

  backend "s3" {
    bucket       = "lej-event-db-tfstate"
    key          = "event-db-provisioning/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_db_subnet_group" "event_db" {

  name = "event-db-subnet-group"

  subnet_ids = [
    "subnet-067d5fcad50f93a09",
    "subnet-0a9746e9551395daa"
  ]

  tags = {
    Name = "event-db-subnet-group"
  }
}

resource "aws_db_instance" "event_db" {

  identifier = var.db_identifier

  db_name = var.db_name

  engine = "mysql"

  engine_version = "8.4"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  
  storage_type = "gp3"

  username = var.db_username

  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.event_db.name

  vpc_security_group_ids = [
    "sg-01d90b22707927bc3"
  ]

  publicly_accessible = false

  skip_final_snapshot = true

  deletion_protection = false
}

