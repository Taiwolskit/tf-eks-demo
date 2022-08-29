#############
#  Network  #
#############
output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_ids" {
  value = module.network.subnet_ids
}

output "flow_log" {
  value = module.network.flow_log
}

###################
#  Public subnet  #
###################
output "public" {
  value = module.network.public
}

output "nat" {
  value = module.network.nat
}

####################
#  Private subnet  #
####################
output "eip" {
  value = module.network.eip
}

output "private" {
  value = module.network.private
}

output "vpce" {
  value = module.network.vpce
}

#############
#  Bastion  #
#############
output "bastion" {
  value = {
    id          = module.bastion.instance_id,
    public_ip   = module.bastion.public_ip,
    iam_role_id = module.bastion.iam_role_id,
    sg_id       = module.bastion.sg_id,
  }
}

output "bastion_ssh_key" {
  value     = module.bastion.ssh_key
  sensitive = true
}

# #########
# #  EKS  #
# #########
output "eks_ssh_key" {
  sensitive = true
  value = {
    fingerprint = aws_key_pair.eks.fingerprint
    key_name    = aws_key_pair.eks.key_name
    key_pair_id = aws_key_pair.eks.key_pair_id
    key_type    = aws_key_pair.eks.key_type
  }
}

output "eks_status" {
  value = aws_eks_cluster.default.status
}

output "eks_ca" {
  value     = aws_eks_cluster.default.certificate_authority
  sensitive = true
}

output "eks_endpoint" {
  value = aws_eks_cluster.default.endpoint
}

output "eks_identity" {
  value     = aws_eks_cluster.default.identity
  sensitive = true
}

output "eks_vpc_config" {
  value = aws_eks_cluster.default.vpc_config
}

output "eks_ng_status" {
  value = {
    private_t3_medium = {
      status    = aws_eks_node_group.private_t3_medium.status
      resources = aws_eks_node_group.private_t3_medium.resources
    }
  }
}

output "eks_oidc_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}
