locals {
  naming_prefix = "${var.project}-${var.env}"
  bastion_arns = concat(
    [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    ],
    var.addiational_arns
  )
  tag_resources = [
    "instance",
    "network-interface",
    "volume",
  ]
}
