terraform{
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
      }
    }

    backend "s3" {
      bucket = "s3-backend-bucket-19925"
      key = "terraform.tfstate"
      region = "ap-south-1"
    }
}

provider "aws" {
  region = "ap-south-1"
}


resource "aws_default_vpc" "vpc"{
  
}

data "aws_subnets" "default"{
    filter{
        name = "vpc-id"
        values = [aws_default_vpc.vpc.id]
    }
}

resource "aws_security_group" "web_sg" {

  name        = "web-sg"
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id      = aws_default_vpc.vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

module "load-balancer"{
  source = "./load-balancer"
  vpc_id = aws_default_vpc.vpc.id
  security_group = aws_security_group.web_sg.id
  subnet_ids = data.aws_subnets.default.ids
}

module "auto-scaling-group"{
  source = "./auto-scaling-group"
  target_group_arn = module.load-balancer.target_group_arn
  subnets = data.aws_subnets.default.ids
  security_group_id = aws_security_group.web_sg.id
}
