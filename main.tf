resource "aws_vpc" "free_camp_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "free_camp"
  }
}

resource "aws_subnet" "free_camp_subnet" {
  vpc_id                  = aws_vpc.free_camp_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    "Name" = "free_camp_public_subnet"
  }
}

resource "aws_internet_gateway" "free_camp_internet_gw" {
  vpc_id = aws_vpc.free_camp_vpc.id

  tags = {
    "Name" = "free_camp_internet_gw"
  }
}

resource "aws_route_table" "free_camp_public_rt" {
  vpc_id = aws_vpc.free_camp_vpc.id

  tags = {
    "Name" = "free_camp_public_rt"
  }
}

resource "aws_route" "free_camp_default_route" {
  route_table_id         = aws_route_table.free_camp_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.free_camp_internet_gw.id
}

resource "aws_route_table_association" "free_camp_public_rt_association" {
  subnet_id      = aws_subnet.free_camp_subnet.id
  route_table_id = aws_route_table.free_camp_public_rt.id
}

resource "aws_security_group" "free_camp_sg" {
  vpc_id = aws_vpc.free_camp_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["177.188.149.26/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "free_camp_sg"
  }
}