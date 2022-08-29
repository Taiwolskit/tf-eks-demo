locals {
  project_name  = "demo"
  naming_prefix = "${local.project_name}-${terraform.workspace}"
}

locals {
  node_group_resources = [
    "elastic-gpu",
    "instance",
    "network-interface",
    "spot-instances-request",
    "volume",
  ]
  eks_master_arns = concat(
    var.eks_setting.arns,
    [
      "arn:aws:iam::${var.aws_account_id}:policy/AmazonEKSAdminPolicy",
      "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
      # "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    ]
  )
  eks_node_arns = concat(
    var.eks_ng_default.arns,
    [
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",    # ECR
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",                  # Addon VPC-CNI
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",             # EKS worker
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",          # SSM
      "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy", # Addon EBS-CSI
    ]
  )
}
