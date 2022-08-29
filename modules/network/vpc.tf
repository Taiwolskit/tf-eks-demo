resource "aws_vpc" "default" {
  cidr_block                       = var.vpc_cidr
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name    = "${local.naming_prefix}-vpc"
    Service = "vpc"
  }
}
