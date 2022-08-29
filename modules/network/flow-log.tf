resource "aws_iam_role" "flow_log" {
  name               = "${local.naming_prefix}-role-flow-log"
  description        = "Flow Log Role for ${local.naming_prefix} VPC managed by Terraform"
  assume_role_policy = data.aws_iam_policy_document.flow_log_assume_role_policy.json

  tags = {
    App     = "${local.naming_prefix}-flow-log"
    Service = "iam-role"
  }

  depends_on = [
    data.aws_iam_policy_document.flow_log_assume_role_policy,
  ]
}

resource "aws_iam_role_policy" "flow_log" {
  name   = "${local.naming_prefix}-role-flow-log"
  role   = aws_iam_role.flow_log.id
  policy = data.aws_iam_policy_document.flow_log_role_policy.json

  depends_on = [
    aws_iam_role.flow_log,
    data.aws_iam_policy_document.flow_log_role_policy,
  ]
}

resource "aws_cloudwatch_log_group" "flow_log" {
  name = "/aws/vpc/${local.naming_prefix}/flow-log"

  retention_in_days = 90
  tags = {
    App     = "${local.naming_prefix}-flow-log"
    Service = "cloudwatch-log-group"
  }
}

resource "aws_flow_log" "flow_log" {
  iam_role_arn    = aws_iam_role.flow_log.arn
  log_destination = aws_cloudwatch_log_group.flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.default.id

  tags = {
    Name    = "${local.naming_prefix}-vpc"
    Service = "flow-log"
  }

  depends_on = [
    aws_iam_role.flow_log,
    aws_cloudwatch_log_group.flow_log,
    aws_vpc.default,
  ]
}
