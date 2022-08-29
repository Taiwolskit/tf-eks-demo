resource "aws_iam_role" "eks_cluster" {
  name                = "${local.naming_prefix}-eks-cluster"
  description         = "EKS Service Role for ${local.naming_prefix} Cluster managed by Terraform"
  assume_role_policy  = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
  managed_policy_arns = local.eks_master_arns

  tags = {
    App     = "eks-cluster"
    Service = "iam-role"
  }

  depends_on = [
    data.aws_iam_policy_document.eks_cluster_assume_role_policy
  ]
}

resource "aws_iam_role" "eks_node" {
  name                = "${local.naming_prefix}-eks-node"
  description         = "EKS Service Role for ${local.naming_prefix} Node managed by Terraform"
  assume_role_policy  = data.aws_iam_policy_document.eks_node_assume_role_policy.json
  managed_policy_arns = local.eks_node_arns

  tags = {
    App     = "eks-node"
    Service = "iam-role"
  }

  depends_on = [
    data.aws_iam_policy_document.eks_node_assume_role_policy
  ]
}
