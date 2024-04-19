# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

# Subnets
# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)

  tags = {
    Name        = "nat"
    Environment = "${var.environment}"
  }
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-public-subnet"
    Environment = "${var.environment}"
  }
}


# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-private-subnet"
    Environment = "${var.environment}"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  # count = length(var.private_subnets_cidr)
  description = "DB Subnet Group"

  subnet_ids = aws_subnet.private_subnet.*.id
  # depends_on = [ aws_subnet.private_subnet ]
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0" #CIDR of Priv ?
  gateway_id             = aws_internet_gateway.ig.id
}

# Route for NAT
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0" # 
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Route table associations for both Public & Private Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

# Default Security Group of VPC
resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default SG to allow traffic from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on = [
    aws_vpc.vpc
  ]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    Environment = "${var.environment}"
  }
}

# Default Security Group for External Resources

# Default Security Group for Internal Resources

# EC2 Resources
resource "aws_instance" "ec2_frontend" {
  count = length(var.public_subnets_cidr)
  ami = "ami-0036b4598ccd42565"
  instance_type = "t3.micro"
  availability_zone = aws_subnet.public_subnet[count.index].availability_zone
  subnet_id = aws_subnet.public_subnet[count.index].id
  associate_public_ip_address = true
  vpc_security_group_ids = [ "${aws_security_group.default.id}" ]

  tags = {
    Name ="${var.environment}-${element(var.availability_zones, count.index)}-EC2FrontEnd"
    Environment = "${var.environment}"
  }

  depends_on = [ aws_subnet.public_subnet, aws_security_group.default ]
}

resource "aws_instance" "ec2_backend" {
  count = length(var.private_subnets_cidr)
  ami = "ami-0036b4598ccd42565"
  instance_type = "t3.micro"
  availability_zone = aws_subnet.private_subnet[count.index].availability_zone
  subnet_id = aws_subnet.private_subnet[count.index].id
  associate_public_ip_address = true
  vpc_security_group_ids = [ "${aws_security_group.default.id}" ]

  tags = {
    Name ="${var.environment}-${element(var.availability_zones, count.index)}-EC2BackEnd"
    Environment = "${var.environment}"
  }

  depends_on = [ aws_subnet.private_subnet, aws_security_group.default ]
}

# RDS Resources
resource "aws_db_instance" "db_instance" {
  allocated_storage    = 10
  db_name              = "sql_db"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
