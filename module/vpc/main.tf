resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "MainVPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
  
}

resource "aws_subnet" "private_subnet" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_subnet_cidr
    availability_zone = var.availability_zone
    
    tags = {
        Name = "PrivateSubnet"
    }
  
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MainIGW"
  }
}

resource "aws_eip" "aws_eip_nat_gateway" {
  domain = "vpc"
    tags = {
        Name = "NATGatewayEIP"
    }  
}

resource "aws_nat_gateway" "public_nat_gateway" {
  allocation_id = aws_eip.aws_eip_nat_gateway.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "PublicNATGateway"
  }
  
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_rt_nat" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.public_nat_gateway.id
}

resource "aws_route_table_association" "assoc_private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
  
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}