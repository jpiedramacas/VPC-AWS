provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "lab-vpc"
  }
}

resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name = "lab-igw"
  }
}

resource "aws_subnet" "lab_subnet_public1" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "lab-subnet-public1-us-east-1a"
  }
}

resource "aws_subnet" "lab_subnet_private1" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "lab-subnet-private1-us-east-1a"
  }
}

resource "aws_subnet" "lab_subnet_public2" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "lab-subnet-public2"
  }
}

resource "aws_subnet" "lab_subnet_private2" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "lab-subnet-private2"
  }
}

resource "aws_route_table" "lab_rt_public" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_igw.id
  }

  tags = {
    Name = "lab-rtb-public"
  }
}

resource "aws_route_table" "lab_rt_private1" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.lab_nat.id
  }

  tags = {
    Name = "lab-rtb-private1-us-east-1a"
  }
}

resource "aws_route_table_association" "lab_rta_public1" {
  subnet_id      = aws_subnet.lab_subnet_public1.id
  route_table_id = aws_route_table.lab_rt_public.id
}

resource "aws_route_table_association" "lab_rta_public2" {
  subnet_id      = aws_subnet.lab_subnet_public2.id
  route_table_id = aws_route_table.lab_rt_public.id
}

resource "aws_route_table_association" "lab_rta_private1" {
  subnet_id      = aws_subnet.lab_subnet_private1.id
  route_table_id = aws_route_table.lab_rt_private1.id
}

resource "aws_route_table_association" "lab_rta_private2" {
  subnet_id      = aws_subnet.lab_subnet_private2.id
  route_table_id = aws_route_table.lab_rt_private1.id
}

resource "aws_eip" "lab_eip" {
  vpc = true
}

resource "aws_nat_gateway" "lab_nat" {
  allocation_id = aws_eip.lab_eip.id
  subnet_id     = aws_subnet.lab_subnet_public1.id

  tags = {
    Name = "lab-nat-public1-us-east-1a"
  }
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.lab_vpc.id

  ingress {
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

  tags = {
    Name = "Web Security Group"
  }
}

resource "aws_instance" "web_server1" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.lab_subnet_public2.id
  key_name      = "vockey"

  user_data = <<-EOF
                #!/bin/bash
                dnf install -y httpd wget php mariadb105-server
                wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-ACCLFO-2/2-lab2-vpc/s3/lab-app.zip
                unzip lab-app.zip -d /var/www/html/
                chkconfig httpd on
                service httpd start
              EOF

  tags = {
    Name = "Web Server 1"
  }

  security_groups = [aws_security_group.web_sg.name]
}

output "public_ip" {
  value = aws_instance.web_server1.public_ip
}

output "public_dns" {
  value = aws_instance.web_server1.public_dns
}
