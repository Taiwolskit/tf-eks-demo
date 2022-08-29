resource "aws_eks_addon" "adot" {
  cluster_name             = aws_eks_cluster.default.name
  addon_name               = "adot"
  addon_version            = data.aws_eks_addon_version.adot.version
  service_account_role_arn = var.eks_addons_arn

  tags = {
    App     = "adot"
    Service = "eks-addon"
  }

  depends_on = [
    aws_eks_cluster.default,
    data.aws_eks_addon_version.adot
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name             = aws_eks_cluster.default.name
  addon_name               = "kube-proxy"
  addon_version            = data.aws_eks_addon_version.kube_proxy.version
  service_account_role_arn = var.eks_addons_arn

  tags = {
    App     = "kube-proxy"
    Service = "eks-addon"
  }

  depends_on = [
    aws_eks_cluster.default,
    data.aws_eks_addon_version.kube_proxy
  ]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = aws_eks_cluster.default.name
  addon_name               = "vpc-cni"
  addon_version            = data.aws_eks_addon_version.vpc_cni.version
  service_account_role_arn = var.eks_addons_arn

  tags = {
    App     = "vpc-cni"
    Service = "eks-addon"
  }

  depends_on = [
    aws_eks_cluster.default,
    data.aws_eks_addon_version.vpc_cni
  ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name             = aws_eks_cluster.default.name
  addon_name               = "coredns"
  addon_version            = data.aws_eks_addon_version.coredns.version
  service_account_role_arn = var.eks_addons_arn

  tags = {
    App     = "coredns"
    Service = "eks-addon"
  }

  depends_on = [
    aws_eks_cluster.default,
    data.aws_eks_addon_version.coredns
  ]
}

resource "aws_eks_addon" "csi_driver" {
  cluster_name             = aws_eks_cluster.default.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = data.aws_eks_addon_version.csi_driver.version
  service_account_role_arn = var.eks_addons_arn

  tags = {
    App     = "ebs-csi-driver"
    Service = "eks-addon"
  }

  depends_on = [
    aws_eks_cluster.default,
    data.aws_eks_addon_version.csi_driver
  ]
}
