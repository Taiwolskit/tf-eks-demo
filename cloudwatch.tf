resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${local.naming_prefix}/cluster"
  retention_in_days = 90
  tags = {
    Service = "cloudwatch-log-group"
  }
}
