variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "task_container_image" {
  description = "The image used to start a container."
  type        = string
}

variable "task_definition_cpu" {
  description = "Amount of CPU to reserve for the task."
  type        = number
  default     = 256
}

variable "task_definition_memory" {
  description = "The soft limit (in MiB) of memory to reserve for the task."
  type        = number
  default     = 512
}

variable "agent_count" {
  description = "The number of AZDO agents desired."
  type        = number
  default     = 1
}

variable "azp_url" {
  description = "The URL of the Azure DevOps or Azure DevOps Server instance."
  type        = string
}

variable "azp_token" {
  description = "Personal Access Token (PAT) with Agent Pools (read, manage) scope, created by a user who has permission to configure agents, at AZP_URL."
  type        = string
  sensitive   = true
}

variable "azp_pool" {
  description = "Agent pool name (default value: Default)."
  type        = string
  default     = "Default"
}

variable "azp_work" {
  description = "Work directory (default value: _work)."
  type        = string
  default     = "_work"
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "The VPC CIDR to be provisioned."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "List of availability zones to be used to provisions subnets."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "A flag to enable NAT Gateway"
  type        = bool
  default     = true
}