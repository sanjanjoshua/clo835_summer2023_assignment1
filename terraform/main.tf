provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "clo835" {
  key_name   = "clo835-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "ec2_app" {
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = aws_key_pair.clo835.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install docker -y
              service docker start
              usermod -aG docker ec2-user
              chkconfig docker on
              yum install -y unzip
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install
              EOF

  tags = {
    Name = "clo835-app-instance"
  }
}
