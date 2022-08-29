# Network module

This module will create a two-tier network architecture with flow log at AWS VPC.

## Variables

| Name                                         | Type         | Required | Default                                                                                                                                                                                | Description         |
| -------------------------------------------- | ------------ | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| env                                          | string       | yes      |                                                                                                                                                                                        | Project environment |
| project                                      | string       | yes      |                                                                                                                                                                                        | Project name        |
| vpc_cidr                                     | string       | yes      |                                                                                                                                                                                        | VPC CIDR            |
| az                                           | list(string) |          | `["ap-northeast-1a", "ap-northeast-1b", "ap-northeast-1c"]`                                                                                                                            | AWS region          |
| enable_endpoints                             | bool         |          | `true`                                                                                                                                                                                 |                     |
| gateway_endpoint_service_names               | list(object) |          | `[]`                                                                                                                                                                                   |                     |
| gateway_endpoint_services                    | list(string) |          | `["s3", "dynamodb"]`                                                                                                                                                                   |                     |
| interface_endpoint_service_names.cidr_blocks | list(string) |          | `[]`                                                                                                                                                                                   |                     |
| interface_endpoint_services                  | list(string) |          | `["appmesh-envoy-management","autoscaling","ec2","ec2messages","ecr.api","ecr.dkr","elasticloadbalancing","kms","logs","secretsmanager","sns","sqs","ssm","ssmmessages","sts","xray"]` |                     |
| multiple_nat_gateways                        | bool         |          | `false`                                                                                                                                                                                |                     |
| region                                       | string       |          | `ap-northeast-1`                                                                                                                                                                       | AWS region          |
| subnet_indexes                               | object       |          |                                                                                                                                                                                        |                     |
| subnet_indexes.private                       | list(number) |          | `[4, 5, 6]`                                                                                                                                                                            |                     |
| subnet_indexes.public                        | list(number) |          | `[1, 2, 3]`                                                                                                                                                                            |                     |
| subnet_newbits                               | number       |          | `8`                                                                                                                                                                                    |                     |

## Output

| Name                             | Description |
| -------------------------------- | ----------- |
| vpc_id                           | VPC ID      |
| flow_log                         | Elastic IP  |
| subnet_ids                       | Subnet IDs  |
| public                           |             |
| public.subnet                    |             |
| public.rtb                       |             |
| public_subnet_ids                |             |
| public_rtb_id                    |             |
| nat                              |             |
| nat.allocation_id                |             |
| nat.id                           |             |
| nat.network_interface_id         |             |
| nat.private_ip                   |             |
| nat.public                       |             |
| nat.subnet_id                    |             |
| eip                              |             |
| eip.allocation_id                |             |
| eip.carrier_ip                   |             |
| eip.domain                       |             |
| eip.id                           |             |
| eip.private                      |             |
| eip.private.ip                   |             |
| eip.private.dns                  |             |
| eip.public                       |             |
| eip.public.ip                    |             |
| eip.public.dns                   |             |
| private                          |             |
| private.subnet                   |             |
| private.rtb                      |             |
| private_subnet_ids               |             |
| private_rtb_id                   |             |
| vpce                             |             |
| vpce.gateway                     |             |
| vpce.gateway.id                  |             |
| vpce.gateway.pl                  |             |
| vpce.gateway.cidr                |             |
| vpce.gateway.requester_managed   |             |
| vpce.interface                   |             |
| vpce.interface.id                |             |
| vpce.interface.pl                |             |
| vpce.interface.cidr              |             |
| vpce.interface.requester_managed |             |
