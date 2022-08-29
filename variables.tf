variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS region, default is ap-northeast-1 (Tokyo)"
}

variable "az" {
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1b", "ap-northeast-1c"]
  description = "Availability Zones"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for VPC"
}

#############
#  Bastion  #
#############
variable "bastion_setting" {
  type = object({
    ami           = string
    instance_type = string
  })
  default = {
    ami           = "ami-0b7546e839d7ace12"
    instance_type = "t3.micro"
  }
}

variable "bastion_ssh_key" {
  type      = string
  sensitive = true
}

#########
#  EKS  #
#########
variable "eks_ssh_key" {
  type      = string
  sensitive = true
}

variable "eks_setting" {
  type = object({
    arns          = list(string)
    cidr          = string
    public_access = bool
    version       = string
  })
  description = "EKS setting"
  default = {
    arns          = [],
    cidr          = "172.20.0.0/16"
    public_access = true
    version       = "1.23"
  }
}

variable "eks_addons_arn" {
  type = string
  description = "EKS addons arn"
  default = ""
}

####################
#  EKS Node Group  #
####################
variable "eks_ng_default" {
  type = object({
    ami_type                   = string
    arns                       = list(string)
    capacity_type              = string
    disk_size                  = number
    instance_types             = list(string)
    max                        = number
    max_unavailable_percentage = number
    min                        = number
  })
  description = "EKS node group default setting"
  default = {
    ami_type                   = "AL2_x86_64"
    arns                       = []
    capacity_type              = "ON_DEMAND"
    disk_size                  = 20
    instance_types             = ["t3.medium"]
    max                        = 6
    max_unavailable_percentage = 30
    min                        = 1
  }
}
