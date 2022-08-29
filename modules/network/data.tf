data "aws_iam_policy_document" "flow_log_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "flow_log_role_policy" {
  statement {
    sid = "FlowLogPolicy"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_vpc_endpoint_service" "gateway" {
  count        = length(var.gateway_endpoint_services)
  service      = var.gateway_endpoint_services[count.index]
  service_type = "Gateway"
}

data "aws_vpc_endpoint_service" "interface" {
  count        = length(var.interface_endpoint_services)
  service      = var.interface_endpoint_services[count.index]
  service_type = "Interface"
}
