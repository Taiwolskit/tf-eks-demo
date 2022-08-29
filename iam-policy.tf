resource "aws_iam_policy" "eks_external_dns" {
  name = "${local.naming_prefix}-eks-external-dns"
  path = "/"

  policy = jsonencode({
    "Statement" = [
      {
        "Action" = [
          "route53:ChangeResourceRecordSets",
        ]
        "Effect" = "Allow"
        "Resource" = [
          "arn:aws:route53:::hostedzone/*",
        ]
      },
      {
        "Action" = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
        ]
        "Effect" = "Allow"
        "Resource" = [
          "*",
        ]
      },
    ]
    "Version" = "2012-10-17"
  })
}
