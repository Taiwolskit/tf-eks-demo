module "network" {
  source   = "./modules/network"
  az       = data.aws_availability_zones.current.names
  env      = terraform.workspace
  project  = local.project_name
  region   = var.region
  vpc_cidr = var.vpc_cidr
}

module "bastion" {
  source         = "./modules/bastion"
  ami            = var.bastion_setting.ami
  aws_account_id = var.aws_account_id
  env            = terraform.workspace
  instance_type  = var.bastion_setting.instance_type
  project        = local.project_name
  region         = var.region
  ssh_key        = var.bastion_ssh_key
  subnet_ids     = module.network.public_subnet_ids
  vpc_id         = module.network.vpc_id
  addiational_arns = [
    "arn:aws:iam::${var.aws_account_id}:policy/AmazonEKSAdminPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
  ]

  depends_on = [
    module.network
  ]
}
