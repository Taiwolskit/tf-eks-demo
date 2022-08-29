output "vpc_id" {
  value = aws_vpc.default.id
}

output "flow_log" {
  value = {
    id  = aws_flow_log.flow_log.id,
    arn = aws_flow_log.flow_log.arn,
  }
}

output "subnet_ids" {
  value = concat(
    aws_subnet.public.*.id,
    aws_subnet.private.*.id,
  )
}

# #############
# #  Public  #
# #############
output "public" {
  value = {
    subnet = aws_subnet.public.*.id,
    rtb    = aws_route_table.public.id,
  }
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "public_rtb_id" {
  value = aws_route_table.public.id
}

output "nat" {
  value = {
    allocation_id : aws_nat_gateway.nat.*.allocation_id,
    id : aws_nat_gateway.nat.*.id,
    network_interface_id : aws_nat_gateway.nat.*.network_interface_id,
    private_ip : aws_nat_gateway.nat.*.private_ip,
    public : aws_nat_gateway.nat.*.public_ip,
    subnet_id : aws_nat_gateway.nat.*.subnet_id,
  }
}

# ############
# #  Private  #
# ############
output "eip" {
  value = {
    allocation_id : aws_eip.nat.*.allocation_id,
    carrier_ip : try(aws_eip.nat.*.carrier_ip, []),
    domain : aws_eip.nat.*.domain,
    id : aws_eip.nat.*.id,
    private : {
      ip : try(aws_eip.nat.*.private_ip, []),
      dns : try(aws_eip.nat.*.private_dns, []),
    },
    public : {
      ip : try(aws_eip.nat.*.public_ip, []),
      dns : try(aws_eip.nat.*.public_dns, []),
    }
  }
}

output "private" {
  value = {
    subnet = aws_subnet.private.*.id,
    rtb    = aws_route_table.private.*.id,
  }
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "private_rtb_ids" {
  value = aws_route_table.private.*.id
}

output "vpce" {
  value = {
    gateway = {
      id                = aws_vpc_endpoint.gateway.*.id,
      pl                = aws_vpc_endpoint.gateway.*.prefix_list_id,
      cidr              = aws_vpc_endpoint.gateway.*.cidr_blocks,
      requester_managed = aws_vpc_endpoint.gateway.*.requester_managed,
    },
    interface = {
      id                = aws_vpc_endpoint.interface.*.id,
      dns_entry         = aws_vpc_endpoint.interface.*.dns_entry,
      eni               = aws_vpc_endpoint.interface.*.network_interface_ids,
      requester_managed = aws_vpc_endpoint.interface.*.requester_managed,
    }
  }
}
