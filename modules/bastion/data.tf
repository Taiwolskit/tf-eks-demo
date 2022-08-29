data "aws_kms_key" "ebs" {
  key_id = "alias/aws/ebs"
}

data "aws_iam_policy_document" "bastion_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ssm_policy" {
  statement {
    actions = [
      "ssm:StartSession",
      "ssm:SendCommand"
    ]

    resources = [
      "arn:aws:ec2:${var.region}:${var.aws_account_id}:instance/*",
      "arn:aws:ssm:${var.region}:${var.aws_account_id}:document/SSM-SessionManagerRunShell"
    ]
  }

  statement {
    actions = [
      "ssm:DescribeSessions",
      "ssm:GetConnectionStatus",
      "ssm:DescribeInstanceInformation",
      "ssm:DescribeInstanceProperties",
      "ec2:DescribeInstances"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ssm:TerminateSession",
      "ssm:ResumeSession"
    ]

    resources = [
      "arn:aws:ssm:*:*:session/*",
      "arn:aws:ssm:*:*:session/\u0024\u007baws:username\u007d-*"
    ]
  }
}
