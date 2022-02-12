data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "CustomVpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count = var.counter
#  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.${1+count.index}.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet-${data.aws_availability_zones.available.names[count.index]}"
  }
}
resource "aws_subnet" "private_subnet" {
  count = var.counter
#  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.${11+count.index}.0/24"
  availability_zone= "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags = {
    Name = "PrivateSubnet-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_eip" "nat-eip" {
  vpc      = true

  tags = {
    Name = "NAT-EIP"
}


resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "NAT-GW"
  }
}


resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-RT"
  }
}


resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "Private-RT"
  }
}


resource "aws_route_table_association" "public-subnet-asso-a" {
  count = var.counter 
  subnet_id      = aws_subnet.public_subnet[0].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-subnet-asso-b" {
  count = var.counter
  subnet_id      = aws_subnet.public_subnet[1].id
  route_table_id = aws_route_table.public-rt.id
}


resource "aws_route_table_association" "private-subnet-asso-a" {
  subnet_id = aws_subnet.private_subnet[0].id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-subnet-asso-b" {
  subnet_id = aws_subnet.private_subnet[1].id
  route_table_id = aws_route_table.private-rt.id
}

