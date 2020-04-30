terraform {
  backend "remote" {
    organization = "georgiman"

    workspaces {
      name = "github-random-pet"
    }
  }
}


  

variable "region" {
  description = "AWS default region"
  default     = "us-east-1"
}

variable "ami" {
  description = "AWS ami according to the region"
}

variable "instance_type" {
  description = "AWS instance characteristics"
  default     = "t2.micro"
}

variable "aws_security_group_name" {
  description = "Dedicated security group"
  default     = "windiws-test"
}

variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [3389, 5985, 5986]
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "windows" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.windows_sg.id]
}

# Example of for_each function use
resource "aws_security_group" "windows_sg" {
  name        = var.aws_security_group_name
  description = "Security group settings"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
