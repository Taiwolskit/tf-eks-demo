locals {
  naming_prefix = "${var.project}-${var.env}"
}

locals {
  has_egress  = length(var.subnet_indexes.private) > 0 ? true : false
  nat_numbers = local.has_egress ? (var.multiple_nat_gateways ? length(var.az) : 1) : 0
}

locals {
  max_amount_az_usage = min(
    length(var.az),
    max(
      length(var.subnet_indexes.public),
      length(var.subnet_indexes.private)
    )
  )
  endpoints_subnet_reversed_indexes = var.enable_endpoints ? [for idx in range(local.max_amount_az_usage) : idx] : []
  gateway_endpoint_service_names    = length(var.gateway_endpoint_service_names) > 0 ? var.gateway_endpoint_services : data.aws_vpc_endpoint_service.gateway.*.service_name
  gateway_endpoint_display_names    = [for name in local.gateway_endpoint_service_names : join("-", slice(split(".", name), 3, length(split(".", name))))]
  interface_endpoint_service_names  = length(var.interface_endpoint_service_names) > 0 ? var.interface_endpoint_services : data.aws_vpc_endpoint_service.interface.*.service_name
  interface_endpoint_display_names  = [for name in local.interface_endpoint_service_names : join("-", slice(split(".", name), 3, length(split(".", name))))]
}
