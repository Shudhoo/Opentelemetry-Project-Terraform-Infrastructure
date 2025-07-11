# This is for VPC Creation
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "main_vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.cluster_name}-private-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "public" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.cluster_name}-public-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_internet_gateway" "main_igw" {
    vpc_id = aws_vpc.main_vpc.id

    tags = {
      Name = "${var.cluster_name}-igw"
    }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.cluster_name}-nat-epi"
  }
}

resource "aws_nat_gateway" "main_nat" {
  subnet_id = aws_subnet.public[0].id
  allocation_id = aws_eip.nat_eip.id

  tags = {
    Name = "${var.cluster_name}-nat"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "${var.cluster_name}-public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main_nat.id
  }

  tags = {
    Name = "${var.cluster_name}-private-rt"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count = length(var.public_subnet_cidrs)
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.public[count.index].id
}

resource "aws_route_table_association" "private_rt-association" {
  count = length(var.private_subnet_cidrs)
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private[count.index].id
}