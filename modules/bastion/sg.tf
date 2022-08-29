resource "aws_security_group" "bastion" {
  name        = "${local.naming_prefix}-sg-bastion"
  description = "Security group for bastion managed by Terraform"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.additional_ingress_sg_rules
    content {
      cidr_blocks      = ingress.cidr_blocks
      description      = ingress.description
      from_port        = ingress.from_port
      ipv6_cidr_blocks = ingress.ipv6_cidr_blocks
      protocol         = ingress.protocol
      security_groups  = ingress.security_groups
      to_port          = ingress.to_port
    }
  }

  dynamic "egress" {
    for_each = var.additional_egress_sg_rules
    content {
      cidr_blocks      = egress.cidr_blocks
      description      = egress.description
      from_port        = egress.from_port
      ipv6_cidr_blocks = egress.ipv6_cidr_blocks
      protocol         = egress.protocol
      security_groups  = egress.security_groups
      to_port          = egress.to_port
    }
  }

  tags = {
    App     = "bastion"
    Name    = "${local.naming_prefix}-bastion"
    Service = "security-group"
  }
}

resource "aws_security_group_rule" "bastion_ingress_allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_egress_allow_http" {
  type              = "egress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_egress_allow_https" {
  type              = "egress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_egress_allow_ntp" {
  type              = "egress"
  from_port         = "123"
  to_port           = "123"
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.bastion.id
}
