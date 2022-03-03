module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name               = "${var.name_prefix}-vpc"
  cidr               = var.vpc_cidr
  azs                = var.vpc_azs
  private_subnets    = var.vpc_private_subnets
  public_subnets     = var.vpc_public_subnets
  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.tags
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.name_prefix}-ecs-cluster"
  tags = var.tags
}

resource "aws_ecs_cluster_capacity_providers" "cluster" {
  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

module "azdo_agent_fargate" {
  source = "./modules/fargate"

  name_prefix            = var.name_prefix
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnets
  desired_count          = var.agent_count
  cluster_id             = aws_ecs_cluster.cluster.id
  task_container_image   = var.task_container_image
  task_definition_cpu    = var.task_definition_cpu
  task_definition_memory = var.task_definition_memory

  task_container_environment = {
    AZP_URL   = var.azp_url
    AZP_TOKEN = var.azp_token
    AZP_POOL  = var.azp_pool
    AZP_WORK  = var.azp_work
  }

  tags = var.tags
}