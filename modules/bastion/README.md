# Bastion module

This module will create two bastion server, one is standalone EC2 with elastic IP, one it create with Autoscaling group.

## Variables

| Name                                         | Type         | Required | Default                 | Description                                                   |
| -------------------------------------------- | ------------ | -------- | ----------------------- | ------------------------------------------------------------- |
| aws_account_id                               | string       | yes      |                         | AWS account ID                                                |
| env                                          | string       | yes      |                         | Project environment                                           |
| project                                      | string       | yes      |                         | Project name                                                  |
| ssh_key                                      | string       | yes      |                         | SSH Key which access to bastion                               |
| subnet_ids                                   | list(string) | yes      | `[]`                    | Subnet IDs for bastion, required public subnet                |
| vpc_id                                       | string       | yes      |                         | ID of VPC which bastion will be placed                        |
| additional_egress_sg_rules                   | list(object) |          | `[]`                    | Additional egress rules to add to the Bastion Security Group  |
| additional_egress_sg_rules.cidr_blocks       | list(string) |          |                         |                                                               |
| additional_egress_sg_rules.description       | string       |          |                         |                                                               |
| additional_egress_sg_rules.from_port         | number       |          |                         |                                                               |
| additional_egress_sg_rules.ipv6_cidr_blocks  | list(string) |          |                         |                                                               |
| additional_egress_sg_rules.protocol          | string       |          |                         |                                                               |
| additional_egress_sg_rules.security_groups   | list(string) |          |                         |                                                               |
| additional_egress_sg_rules.to_port           | number       |          |                         |                                                               |
| additional_ingress_sg_rules                  | list(object) |          | `[]`                    | Additional ingress rules to add to the Bastion Security Group |
| additional_ingress_sg_rules.cidr_blocks      | list(string) |          |                         |                                                               |
| additional_ingress_sg_rules.description      | string       |          |                         |                                                               |
| additional_ingress_sg_rules.from_port        | number       |          |                         |                                                               |
| additional_ingress_sg_rules.ipv6_cidr_blocks | list(string) |          |                         |                                                               |
| additional_ingress_sg_rules.protocol         | string       |          |                         |                                                               |
| additional_ingress_sg_rules.security_groups  | list(string) |          |                         |                                                               |
| additional_ingress_sg_rules.to_port          | number       |          |                         |                                                               |
| ami                                          | string       |          | `ami-07200fa04af91f087` | AMI ID, default use Ubuntu 22.04 LTS - Jammy                  |
| ec2_setting                                  | object       |          | `ap-northeast-1`        | Bastion instance configuration                                |
| ec2_setting.additional_sg_ids                | list(string) |          | `[]`                    | Additional security groups will attach on bastion             |
| ec2_setting.root_volume_size                 | number       |          | `8`                     | Bastion volume size                                           |
| ec2_setting.termination_protection           | bool         |          | `false`                 | Enable termination protection or not                          |
| instance_type                                | string       |          | `t3.micro`              | Instance type for bastion                                     |
| region                                       | string       |          | `ap-northeast-1`        | AWS region                                                    |

## Output

| Name                | Description                            |
| ------------------- | -------------------------------------- |
| iam_role_id         | Bastion IAM Role                       |
| instance_id         | Instance ID which is belong Elastic IP |
| public_ip           | Elastic IP                             |
| sg_id               | Bastion security group ID              |
| ssh_key             | SSH Key                                |
| ssh_key.fingerprint |                                        |
| ssh_key.key_name    |                                        |
| ssh_key.key_pair_id |                                        |
| ssh_key.key_type    |                                        |
