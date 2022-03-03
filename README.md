## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azdo_agent_fargate"></a> [azdo\_agent\_fargate](#module\_azdo\_agent\_fargate) | ./modules/fargate | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_count"></a> [agent\_count](#input\_agent\_count) | The number of AZDO agents desired. | `number` | `1` | no |
| <a name="input_azp_pool"></a> [azp\_pool](#input\_azp\_pool) | Agent pool name (default value: Default). | `string` | `"Default"` | no |
| <a name="input_azp_token"></a> [azp\_token](#input\_azp\_token) | Personal Access Token (PAT) with Agent Pools (read, manage) scope, created by a user who has permission to configure agents, at AZP\_URL. | `string` | n/a | yes |
| <a name="input_azp_url"></a> [azp\_url](#input\_azp\_url) | The URL of the Azure DevOps or Azure DevOps Server instance. | `string` | n/a | yes |
| <a name="input_azp_work"></a> [azp\_work](#input\_azp\_work) | Work directory (default value: \_work). | `string` | `"_work"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | A prefix used for naming resources. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags (key-value pairs) passed to resources. | `map(string)` | `{}` | no |
| <a name="input_task_container_image"></a> [task\_container\_image](#input\_task\_container\_image) | The image used to start a container. | `string` | n/a | yes |
| <a name="input_task_definition_cpu"></a> [task\_definition\_cpu](#input\_task\_definition\_cpu) | Amount of CPU to reserve for the task. | `number` | `256` | no |
| <a name="input_task_definition_memory"></a> [task\_definition\_memory](#input\_task\_definition\_memory) | The soft limit (in MiB) of memory to reserve for the task. | `number` | `512` | no |
| <a name="input_vpc_azs"></a> [vpc\_azs](#input\_vpc\_azs) | List of availability zones to be used to provisions subnets. | `list(string)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1b"<br>]</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The VPC CIDR to be provisioned. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_enable_nat_gateway"></a> [vpc\_enable\_nat\_gateway](#input\_vpc\_enable\_nat\_gateway) | A flag to enable NAT Gateway | `bool` | `true` | no |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | A list of private subnets inside the VPC | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24"<br>]</pre> | no |
| <a name="input_vpc_public_subnets"></a> [vpc\_public\_subnets](#input\_vpc\_public\_subnets) | A list of public subnets inside the VPC | `list(string)` | <pre>[<br>  "10.0.101.0/24",<br>  "10.0.102.0/24"<br>]</pre> | no |

## Outputs

No outputs.
