resource "aws_key_pair" "deployer" {
  key_name   = "deployer_key"
  public_key = file("../ec2_key_pair/deployer_key.pub")
}

resource "aws_instance" "bastion_host" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_a.id
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "Bastion Server"
  }
}

resource "aws_instance" "app_server_a" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_a.id
  key_name      = aws_key_pair.deployer.key_name
  user_data     = file("../scripts/setup.sh")

  tags = {
    Name = "App Server A"
  }

}

resource "aws_instance" "app_server_c" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_c.id
  key_name      = aws_key_pair.deployer.key_name
  user_data     = file("../scripts/setup.sh")

  tags = {
    Name = "App Server C"
  }

}


resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
