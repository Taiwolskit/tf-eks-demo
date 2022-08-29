data "aws_availability_zones" "current" {
  all_availability_zones = false
  filter {
    name   = "region-name"
    values = [var.region]
  }
  state = "available"
}

data "aws_eks_addon_version" "adot" {
  addon_name         = "adot"
  kubernetes_version = var.eks_setting.version
  most_recent        = true
}

data "aws_eks_addon_version" "kube_proxy" {
  addon_name         = "kube-proxy"
  kubernetes_version = var.eks_setting.version
  most_recent        = true
}

data "aws_eks_addon_version" "vpc_cni" {
  addon_name         = "vpc-cni"
  kubernetes_version = var.eks_setting.version
  most_recent        = true
}

data "aws_eks_addon_version" "coredns" {
  addon_name         = "coredns"
  kubernetes_version = var.eks_setting.version
  most_recent        = true
}

data "aws_eks_addon_version" "csi_driver" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = var.eks_setting.version
  most_recent        = true
}

data "aws_iam_role" "grafana" {
  name = "AmazonGrafanaServiceRole-k8ZX845w4"
}

data "aws_kms_key" "rds_kms_key" {
  key_id = "alias/aws/rds"
}
