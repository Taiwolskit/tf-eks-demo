resource "aws_key_pair" "eks" {
  key_name   = "${local.naming_prefix}-eks"
  public_key = var.eks_ssh_key

  tags = {
    App     = "eks"
    Service = "key-pair"
  }
}
