resource "aws_eks_cluster" "default" {
  name     = "${local.naming_prefix}-eks"
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = var.eks_setting.public_access
    subnet_ids              = module.network.subnet_ids
    security_group_ids      = [aws_security_group.eks_master.id]
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  kubernetes_network_config {
    service_ipv4_cidr = var.eks_setting.cidr
    ip_family         = "ipv4"
  }

  version = var.eks_setting.version

  tags = {
    Service = "eks-cluster"
  }

  depends_on = [
    aws_iam_role.eks_cluster,
    aws_security_group.eks_master,
    module.network,
  ]
}

resource "aws_eks_node_group" "private_t3_medium" {
  cluster_name    = aws_eks_cluster.default.name
  node_group_name = "${local.naming_prefix}-ng-private-t3-medium"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = module.network.private_subnet_ids
  ami_type        = var.eks_ng_default.ami_type
  capacity_type   = var.eks_ng_default.capacity_type
  disk_size       = var.eks_ng_default.disk_size
  instance_types  = var.eks_ng_default.instance_types

  remote_access {
    ec2_ssh_key               = "${local.naming_prefix}-eks"
    source_security_group_ids = [module.bastion.sg_id]
  }

  scaling_config {
    desired_size = 3
    max_size     = var.eks_ng_default.max
    min_size     = var.eks_ng_default.min
  }

  update_config {
    max_unavailable_percentage = var.eks_ng_default.max_unavailable_percentage
  }

  labels = {
    capacity_type = var.eks_ng_default.capacity_type
    instance_type = var.eks_ng_default.instance_types[0]
    subnet        = "private"
  }

  tags = {
    Service = "eks-node-group"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  depends_on = [
    aws_iam_role.eks_node,
    aws_eks_cluster.default,
    module.bastion,
  ]
}
