variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS region, default is ap-northeast-1 (Tokyo)"
}

variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "aws_account_id" {
  type = string
}

variable "ec2_setting" {
  type = object({
    additional_sg_ids           = list(string)
    root_volume_size            = number
    termination_protection      = bool
  })
  description = "Bastion instance setting"
  default = {
    additional_sg_ids           = []
    root_volume_size            = 8
    termination_protection      = false
  }
}

variable "ssh_key" {
  type      = string
  sensitive = true
}

variable "ami" {
  type        = string
  description = "AMI ID, default use Ubuntu 22.04 LTS - Jammy"
  default     = "ami-07200fa04af91f087"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_ids" {
  type = list(string)
  description = "Required public subnet"
}

variable "addiational_arns" {
  type        = list(string)
  description = "Additional IAM Role ARNs to attach to the Bastion Role"
  default = [ ]
}

variable "additional_ingress_sg_rules" {
  type = list(object({
    cidr_blocks      = list(string)
    description      = string
    from_port        = number
    ipv6_cidr_blocks = list(string)
    protocol         = string
    security_groups  = list(string)
    to_port          = number
  }))
  description = "Additional ingress rules to add to the Bastion Security Group"
  default     = []
}

variable "additional_egress_sg_rules" {
  type = list(object({
    cidr_blocks      = list(string)
    description      = string
    from_port        = number
    ipv6_cidr_blocks = list(string)
    protocol         = string
    security_groups  = list(string)
    to_port          = number
  }))
  description = "Additional egress rules to add to the Bastion Security Group"
  default     = []
}
