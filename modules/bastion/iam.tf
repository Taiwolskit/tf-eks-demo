resource "aws_iam_role" "bastion" {
  name                = "${local.naming_prefix}-bastion"
  description         = "Bastion Role for ${local.naming_prefix} managed by Terraform"
  assume_role_policy  = data.aws_iam_policy_document.bastion_assume_role_policy.json
  managed_policy_arns = local.bastion_arns

  tags = {
    App     = "bastion"
    Service = "iam-role"
  }

  depends_on = [
    data.aws_iam_policy_document.bastion_assume_role_policy,
  ]
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${local.naming_prefix}-bastion"
  role = aws_iam_role.bastion.name

  depends_on = [
    aws_iam_role.bastion
  ]
}

resource "aws_iam_role_policy" "ssm_policy" {
  name   = "ssm-policy"
  role   = aws_iam_role.bastion.id
  policy = data.aws_iam_policy_document.ssm_policy.json

  depends_on = [
    aws_iam_role.bastion,
    data.aws_iam_policy_document.ssm_policy
  ]
}
