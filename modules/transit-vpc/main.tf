# Create a VPC
resource "aws_vpc" "transit-vpc" {
  cidr_block = var.transit_vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "transit-vpc"
  }
}

# Create public subnet
resource "aws_subnet" "transit-public-1a" {
  vpc_id                  = aws_vpc.transit-vpc.id
  cidr_block              = "10.53.108.128/28"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "transit-public-1a"
  }
}

resource "aws_subnet" "transit-public-1b" {
  vpc_id                  = aws_vpc.transit-vpc.id
  cidr_block              = "10.53.108.144/28"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "transit-public-1b"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "transit-IGW" {
  vpc_id = aws_vpc.transit-vpc.id

  tags = {
    Name = "transit-transit-IGW"
  }
}

# Create a public route table
resource "aws_route_table" "transitvpc-public-rt" {
  vpc_id = aws_vpc.transit-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.transit-IGW.id
  }

  tags = {
    Name = "transitvpc-publicRT"
  }
}


# Associate public subnets with public route table
resource "aws_route_table_association" "transitvpc-public-1a-rt-assoc" {
  subnet_id      = aws_subnet.transit-public-1a.id
  route_table_id = aws_route_table.transitvpc-public-rt.id
}

resource "aws_route_table_association" "transitvpc-public-2b-rt-assoc" {
  subnet_id      = aws_subnet.transit-public-1b.id
  route_table_id = aws_route_table.transitvpc-public-rt.id
}

# Create security group for web server
resource "aws_security_group" "transit-vpc-web_security_group" {
  name_prefix = "ca_alb_security_group"
  vpc_id      = aws_vpc.transit-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

  tags = {
    Name = "ca_alb_security_group"
  }
}

