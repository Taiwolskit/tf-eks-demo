variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS region, default is ap-northeast-1 (Tokyo)"
}

variable "az" {
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1b", "ap-northeast-1c"]
  description = "Availability Zones"
}

variable "vpc_cidr" {
  type        = string
  description = "Suggest /16 as the primary solution to initiate a new VPC. Use lower CIDR if you wants more IP in individual subnets. (/16, Will give 256 address for every subnet.)"
}

variable "subnet_indexes" {
  type = object({
    public  = list(number)
    private = list(number)
  })
  default = {
    public  = [1, 2, 3]
    private = [4, 5, 6]
  }

  validation {
    # 240~255 reserved for endpoint subnets
    condition     = min(flatten(values(var.subnet_indexes))...) < 240
    error_message = "Reserve index 0~4 for the endpoint subnets."
  }
  validation {
    condition     = ceil(log(max(flatten(values(var.subnet_indexes))...), 2)) < 10
    error_message = "Too many subnet (max index value higher than 1023) will cause the available address in subnet less than 64. The maximum index should not more than 1023."
  }
}

variable "subnet_newbits" {
  type    = number
  default = 8
  validation {
    condition     = 4 <= var.subnet_newbits && var.subnet_newbits < 11
    error_message = "Subnet new bits must great or equal than 4 and less than 11."
  }
}

variable "multiple_nat_gateways" {
  type        = bool
  default     = false
  description = "Enable multiple NAT gateways for HA. If disable, only one NAT gateway for subnets in multiple az."
}

variable "enable_endpoints" {
  type        = bool
  description = "Create endpoints for the VPC. If disable, endpoints will not be created."
  default     = true
}

variable "gateway_endpoint_services" {
  type    = list(string)
  default = ["s3", "dynamodb"]
}

variable "interface_endpoint_services" {
  type = list(string)
  default = [
    "appmesh-envoy-management",
    "autoscaling",
    "ec2",
    "ec2messages",
    "ecr.api",
    "ecr.dkr",
    "elasticloadbalancing",
    "kms",
    "logs",
    "secretsmanager",
    "sns",
    "sqs",
    "ssm",
    "ssmmessages",
    "sts",
    "xray"
  ]
}

variable "gateway_endpoint_service_names" {
  type    = list(string)
  default = []
}

variable "interface_endpoint_service_names" {
  type    = list(string)
  default = []
}
