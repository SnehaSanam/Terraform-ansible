# Key Pair
resource "aws_key_pair" "ec2-key" {
  key_name   = "terra-key-ansible"
  public_key = file("terra-key-ansible.pub")
}

# VPC
resource "aws_default_vpc" "default" {}

# Security Group
resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "This is security group"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }

  tags = {
    Name = "automate-sg"
  }
}

# EC2 instances
resource "aws_instance" "my_instance" {
  for_each = tomap({
    master  = "ami-0df368112825f8d8f"  # ubuntu
    worker1 = "ami-09de149defa704528"  # redhat
    worker2 = "ami-08f9a9c699d2ab3f9"  # amazon linux
  })

  depends_on = [aws_key_pair.ec2-key, aws_security_group.my_security_group]

  ami           = each.value
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2-key.key_name
  security_groups = [aws_security_group.my_security_group.name]

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
  }
}
