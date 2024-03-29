# Configure the AWS Provider

provider "aws" {
  region     = "us-east-1"
  access_key = access_key
  secret_key = secret_key

}

resource "aws_instance" "my-server1" {
  ami           = "ami-06aa3f7caf3a30282"
  instance_type = "t2.micro"
  tags = {
    Name = "ubuntu-server"
  }

}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "dev-subnet1"
  }
}
resource "aws_subnet" "subnet-2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "dev-subnet2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "aws-table-as" {
  route_table_id = aws_route_table.route-table.id
  subnet_id      = aws_subnet.subnet-1.id
}



resource "aws_security_group" "allow-web" {
  name        = "allow_web"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.main.id


  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }


  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
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

resource "aws_network_interface" "web-server-nwi" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow-web.id]

  # attachment {
  #   instance     = aws_instance.my-server1.id
  #   device_index = 1
  # }
}

resource "aws_eip" "main-eip" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nwi.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw]
}

resource "aws_instance" "web-server-interface" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  
    network_interface {
      device_index = 0
    network_interface_id = aws_network_interface.web-server-nwi.id
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF

  
  }

