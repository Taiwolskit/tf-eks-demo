resource "aws_eip" "nat" {
  count                = local.nat_numbers
  vpc                  = true
  network_border_group = var.region
  public_ipv4_pool     = "amazon"

  tags = {
    Name    = "${local.naming_prefix}-eip-nat"
    Service = "eip"
  }
}

resource "aws_nat_gateway" "nat" {
  count             = local.nat_numbers
  subnet_id         = aws_subnet.public[count.index].id
  allocation_id     = aws_eip.nat[count.index].id
  connectivity_type = "public"

  tags = {
    Name    = "${local.naming_prefix}-nat-${var.az[count.index]}"
    Service = "nat-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [
    aws_subnet.public,
    aws_eip.nat
  ]
}

resource "aws_egress_only_internet_gateway" "egress_igw" {
  count  = local.has_egress ? 1 : 0
  vpc_id = aws_vpc.default.id

  tags = {
    Name    = "${local.naming_prefix}-eigw"
    Service = "egress-only-internet-gateway"
  }

  depends_on = [
    aws_vpc.default
  ]
}

resource "aws_security_group" "endpoint" {
  name        = "${local.naming_prefix}-sg-vpce"
  description = "Security group for endpoints subnet managed by Terraform"
  vpc_id      = aws_vpc.default.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "${local.naming_prefix}-vpce"
    Service = "security-group"
  }

  depends_on = [
    aws_vpc.default
  ]
}

resource "aws_subnet" "private" {
  count                                          = length(var.subnet_indexes.private)
  assign_ipv6_address_on_creation                = true
  availability_zone                              = var.az[count.index]
  cidr_block                                     = cidrsubnet(var.vpc_cidr, var.subnet_newbits, var.subnet_indexes.private[count.index])
  enable_resource_name_dns_aaaa_record_on_launch = true
  enable_resource_name_dns_a_record_on_launch    = true
  ipv6_cidr_block                                = cidrsubnet(aws_vpc.default.ipv6_cidr_block, 8, var.subnet_indexes.private[count.index])
  vpc_id                                         = aws_vpc.default.id

  tags = {
    Name                              = "${local.naming_prefix}-subnet-private-${var.az[count.index]}"
    Service                           = "subnet"
    "kubernetes.io/role/internal-elb" = 1
  }

  depends_on = [
    aws_vpc.default
  ]
}

resource "aws_route_table" "private" {
  count  = local.nat_numbers
  vpc_id = aws_vpc.default.id

  # IPv4
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  # IPv6
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.egress_igw[0].id
  }

  tags = {
    Name    = "${local.naming_prefix}-rtb-private-${var.az[count.index]}"
    Service = "route-table"
  }

  depends_on = [
    aws_vpc.default,
    aws_nat_gateway.nat,
    aws_egress_only_internet_gateway.egress_igw
  ]
}

resource "aws_route_table_association" "private" {
  count          = length(var.subnet_indexes.private)
  route_table_id = element(aws_route_table.private.*.id, count.index)
  subnet_id      = aws_subnet.private[count.index].id

  depends_on = [
    aws_subnet.private,
    aws_route_table.private
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_endpoint" "gateway" {
  count       = length(local.gateway_endpoint_service_names)
  auto_accept = true
  route_table_ids = [
    element(aws_route_table.public.*.id, count.index),
    element(aws_route_table.private.*.id, count.index),
  ]
  service_name      = local.gateway_endpoint_service_names[count.index]
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.default.id

  tags = {
    Name    = "${local.naming_prefix}-vpce-${local.gateway_endpoint_display_names[count.index]}"
    Service = "vpce"
  }

  depends_on = [
    aws_vpc.default,
    aws_route_table.public,
    aws_route_table.private,
  ]
}

resource "aws_vpc_endpoint" "interface" {
  count               = length(local.interface_endpoint_service_names)
  auto_accept         = true
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoint.id]
  service_name        = local.interface_endpoint_service_names[count.index]
  subnet_ids          = aws_subnet.private.*.id
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.default.id

  tags = {
    Name    = "${local.naming_prefix}-vpce-${local.interface_endpoint_display_names[count.index]}"
    Service = "vpce"
  }

  depends_on = [
    aws_vpc.default,
    aws_subnet.private,
    aws_security_group.endpoint
  ]
}
