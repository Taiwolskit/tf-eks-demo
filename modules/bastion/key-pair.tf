resource "aws_key_pair" "bastion" {
  key_name   = "${local.naming_prefix}-bastion"
  public_key = var.ssh_key

  tags = {
    App     = "bastion"
    Service = "key-pair"
  }
}
