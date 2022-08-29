# Terraform for AWS EKS demo

## Variables

| Name                                      | Type         | Required | Default                                                     | Description         |
| ----------------------------------------- | ------------ | -------- | ----------------------------------------------------------- | ------------------- |
| aws_account_id                            | string       | yes      |                                                             | AWS Account ID      |
| bastion_ssh_key                           | string       | yes      |                                                             |                     |
| eks_ssh_key                               | string       | yes      |                                                             |                     |
| env                                       | string       | yes      |                                                             | Project environment |
| project                                   | string       | yes      |                                                             | Project name        |
| vpc_cidr                                  | string       | yes      |                                                             | VPC CIDR            |
| az                                        | list(string) |          | `["ap-northeast-1a", "ap-northeast-1b", "ap-northeast-1c"]` | AZ                  |
| bastion_setting                           | object       |          |                                                             |                     |
| bastion_setting.ami                       | string       |          | `ami-0b7546e839d7ace12`                                     |                     |
| bastion_setting.instance_type             | string       |          | `t3.micro`                                                  |                     |
| bastion_ssh_key                           | string       |          |                                                             |                     |
| eks_addons_arn                            | string       |          | `""`                                                        |                     |
| eks_ng_default                            | object       |          |                                                             |                     |
| eks_ng_default.ami_type                   | string       |          | `AL2_x86_64`                                                |                     |
| eks_ng_default.arns                       | list(string) |          | `[]`                                                        |                     |
| eks_ng_default.capacity_type              | string       |          | `ON_DEMAND`                                                 |                     |
| eks_ng_default.disk_size                  | number       |          | `20`                                                        |                     |
| eks_ng_default.instance_types             | list(string) |          | `["t3.medium"]`                                             |                     |
| eks_ng_default.max                        | number       |          | `6`                                                         |                     |
| eks_ng_default.max_unavailable_percentage | number       |          | `30`                                                        |                     |
| eks_ng_default.min                        | number       |          | `1`                                                         |                     |
| eks_setting                               | object       |          |                                                             |                     |
| eks_setting.arns                          | list(string) |          | `[]`                                                        |                     |
| eks_setting.cidr                          | string       |          | `172.20.0.0/16`                                             |                     |
| eks_setting.public_access                 | bool         |          | `true`                                                      |                     |
| eks_setting.version                       | string       |          | `1.23`                                                      |                     |
| region                                    | string       |          | `ap-northeast-1`                                            | AWS region          |

## Output

| Name                             | Description                              |
| -------------------------------- | ---------------------------------------- |
| bastion                          | Bastion server                           |
| bastion_ssh_key                  |                                          |
| bastion.iam_role_id              |                                          |
| bastion.id                       |                                          |
| bastion.public_ip                |                                          |
| bastion.sg_id                    |                                          |
| eip                              | Elastic IP for standalone bastion server |
| eip.allocation_id                |                                          |
| eip.carrier_ip                   |                                          |
| eip.domain                       |                                          |
| eip.id                           |                                          |
| eip.private                      |                                          |
| eip.private.dns                  |                                          |
| eip.private.ip                   |                                          |
| eip.public                       |                                          |
| eip.public.dns                   |                                          |
| eip.public.ip                    |                                          |
| eks_ca                           | EKS CA                                   |
| eks_endpoint                     | EKS endpoint                             |
| eks_identity                     | EKS OIDC identity                        |
| eks_ng_status                    | EKS Node group status                    |
| eks_oidc_arn                     | EKS OIDC ARN                             |
| eks_ssh_key                      | EKS Worker SSH Key                       |
| eks_status                       | EKS status                               |
| eks_vpc_config                   | EKS VPC config                           |
| flow_log                         | Elastic IP                               |
| nat                              | Network NAT gateway                      |
| nat.allocation_id                |                                          |
| nat.id                           |                                          |
| nat.network_interface_id         |                                          |
| nat.private_ip                   |                                          |
| nat.public                       |                                          |
| nat.subnet_id                    |                                          |
| private                          | Network private subnet                   |
| private_rtb_id                   |                                          |
| private_subnet_ids               |                                          |
| private.rtb                      |                                          |
| private.subnet                   |                                          |
| public                           | Network public subnet                    |
| public_rtb_id                    |                                          |
| public_subnet_ids                |                                          |
| public.rtb                       |                                          |
| public.subnet                    |                                          |
| subnet_ids                       | Subnet IDs                               |
| vpc_id                           | VPC ID                                   |
| vpce                             | VPC endpoints                            |
| vpce.gateway                     |                                          |
| vpce.gateway.cidr                |                                          |
| vpce.gateway.id                  |                                          |
| vpce.gateway.pl                  |                                          |
| vpce.gateway.requester_managed   |                                          |
| vpce.interface                   |                                          |
| vpce.interface.cidr              |                                          |
| vpce.interface.id                |                                          |
| vpce.interface.pl                |                                          |
| vpce.interface.requester_managed |                                          |
