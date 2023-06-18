# Create a VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  

  tags = {
    Name = "workload-vpc"
  }
}


# Create private subnets
resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.53.82.0/26"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-1a"
    "kubernetes.io/cluster/uat-cluster" = "shared"
    "kubernetes.io/role/internal-elb"   = "1" 
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.53.82.64/26"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-2b"
    "kubernetes.io/cluster/uat-cluster" = "shared"
    "kubernetes.io/role/internal-elb"   = "1" 
  }
}

# Create database subnets
resource "aws_subnet" "db-subnet-1" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.53.82.160/28"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "db-1a"
  }
}

resource "aws_subnet" "db-subnet-2" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.53.82.176/28"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "db-2b"
  }
}




# Create a private route table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "privateRT"
  }
}


resource "aws_route_table_association" "db-2b-rt-assoc" {
  subnet_id      = aws_subnet.db-subnet-2.id
  route_table_id = aws_route_table.private-rt.id
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private-1a-rt-assoc" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-2b-rt-assoc" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-rt.id
}

