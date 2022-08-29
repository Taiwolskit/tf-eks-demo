resource "aws_security_group" "eks_master" {
  name        = "${local.naming_prefix}-eks-cluster-sg"
  description = "EKS created security group applied to ENI that is attached to EKS Control Plane master nodes, as well as any managed workloads."
  vpc_id      = module.network.vpc_id

  revoke_rules_on_delete = true

  tags = {
    App     = "eks-cluster"
    Name    = "${local.naming_prefix}-eks-master-sg"
    Service = "security-group"
  }
}

resource "aws_security_group_rule" "eks_master_ingress_self" {
  description       = "Self"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.eks_master.id
  self              = true
  to_port           = 0
  type              = "ingress"

  depends_on = [
    aws_security_group.eks_master,
  ]
}

resource "aws_security_group_rule" "eks_master_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "-1"
  security_group_id = aws_security_group.eks_master.id
  to_port           = 0
  type              = "egress"

  depends_on = [
    aws_security_group.eks_master,
  ]
}

resource "aws_security_group_rule" "bastion_to_eks_master" {
  description              = "Bastion to EKS master"
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_master.id
  source_security_group_id = module.bastion.sg_id
  to_port                  = 22
  type                     = "ingress"

  depends_on = [
    aws_security_group.eks_master,
    module.bastion
  ]
}

resource "aws_security_group" "eks_node" {
  name        = "${local.naming_prefix}-eks-worker-sg"
  description = "Security group for all nodes in the nodeGroup to allow SSH access"
  vpc_id      = module.network.vpc_id

  revoke_rules_on_delete = false

  tags = {
    App     = "eks-ng"
    Name    = "${local.naming_prefix}-eks-worker-sg"
    Service = "security-group"
  }

  depends_on = [
    module.bastion,
    aws_security_group.eks_master
  ]
}

resource "aws_security_group_rule" "eks_node_ingress_self" {
  description       = "Self"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.eks_node.id
  self              = true
  to_port           = 0
  type              = "ingress"

  depends_on = [
    aws_security_group.eks_node,
  ]
}

resource "aws_security_group_rule" "eks_node_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "-1"
  security_group_id = aws_security_group.eks_node.id
  to_port           = 0
  type              = "egress"

  depends_on = [
    aws_security_group.eks_node,
  ]
}

resource "aws_security_group_rule" "eks_node_ingress_eks_master" {
  description              = "EKS master"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = aws_security_group.eks_master.id
  to_port                  = 443
  type                     = "ingress"

  depends_on = [
    aws_security_group.eks_node,
  ]
}

resource "aws_security_group_rule" "bastion_to_eks_node" {
  description              = "Bastion to EKS node"
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = module.bastion.sg_id
  to_port                  = 22
  type                     = "ingress"

  depends_on = [
    aws_security_group.eks_node,
    module.bastion
  ]
}
