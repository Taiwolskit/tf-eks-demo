resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name    = "${local.naming_prefix}-igw"
    Service = "internet-gateway"
  }

  depends_on = [
    aws_vpc.default
  ]
}

resource "aws_subnet" "public" {
  count                                          = length(var.subnet_indexes.public)
  assign_ipv6_address_on_creation                = true
  availability_zone                              = var.az[count.index]
  cidr_block                                     = cidrsubnet(var.vpc_cidr, var.subnet_newbits, var.subnet_indexes.public[count.index])
  enable_resource_name_dns_aaaa_record_on_launch = true
  enable_resource_name_dns_a_record_on_launch    = true
  ipv6_cidr_block                                = cidrsubnet(aws_vpc.default.ipv6_cidr_block, 8, var.subnet_indexes.public[count.index])
  vpc_id                                         = aws_vpc.default.id

  tags = {
    Name                     = "${local.naming_prefix}-subnet-public-${var.az[count.index]}"
    Service                  = "subnet"
    "kubernetes.io/role/elb" = 1
  }

  depends_on = [
    aws_vpc.default
  ]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  # IPv4
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  # IPv6
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "${local.naming_prefix}-rtb-public"
    Service = "route-table"
  }

  depends_on = [
    aws_vpc.default,
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table_association" "public" {
  count          = length(var.subnet_indexes.public)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id

  depends_on = [
    aws_subnet.public,
    aws_route_table.public
  ]

  lifecycle {
    create_before_destroy = true
  }
}
