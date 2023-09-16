

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr


  tags = {
    Name = "Main VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[0]
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[1]
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.public.id
}



resource "aws_eip" "nat_eip_a" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway_a" {
  subnet_id     = aws_subnet.public_subnet_a.id
  allocation_id = aws_eip.nat_eip_a.id
}

resource "aws_eip" "nat_eip_c" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway_c" {
  subnet_id     = aws_subnet.public_subnet_c.id
  allocation_id = aws_eip.nat_eip_c.id
}


resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[0]
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[1]
  availability_zone = "ap-northeast-1c"
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_1a.id
}

resource "aws_route_table" "private_1c" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_c.id
  }
}


resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_subnet_c.id
  route_table_id = aws_route_table.private_1c.id
}



