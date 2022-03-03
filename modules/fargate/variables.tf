variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "sg_name_prefix" {
  description = "A prefix used for Security group name."
  type        = string
  default     = ""
}

variable "container_name" {
  description = "Optional name for the container to be used instead of name_prefix."
  default     = ""
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}

variable "cluster_id" {
  description = "The Amazon Resource Name (ARN) that identifies the cluster."
  type        = string
}

variable "platform_version" {
  description = "The platform version on which to run your service. Only applicable for launch_type set to FARGATE."
  default     = "LATEST"
}

variable "task_container_image" {
  description = "The image used to start a container."
  type        = string
}

variable "desired_count" {
  description = "The number of instances of the task definitions to place and keep running."
  default     = 1
  type        = number
}

variable "task_definition_cpu" {
  description = "Amount of CPU to reserve for the task."
  default     = 256
  type        = number
}

variable "task_definition_memory" {
  description = "The soft limit (in MiB) of memory to reserve for the task."
  default     = 512
  type        = number
}

variable "task_definition_ephemeral_storage" {
  description = "The total amount, in GiB, of ephemeral storage to set for the task."
  default     = 0
  type        = number
}

variable "task_container_command" {
  description = "The command that is passed to the container."
  default     = []
  type        = list(string)
}

variable "task_container_environment" {
  description = "The environment variables to pass to a container."
  default     = {}
  type        = map(string)
}

variable "task_container_secrets" {
  description = "The secrets variables to pass to a container."
  default     = null
  type        = list(map(string))
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "deployment_minimum_healthy_percent" {
  default     = 50
  description = "The lower limit of the number of running tasks that must remain running and healthy in a service during a deployment"
  type        = number
}

variable "deployment_maximum_percent" {
  default     = 200
  description = "The upper limit of the number of running tasks that can be running in a service during a deployment"
  type        = number
}

variable "deployment_controller_type" {
  default     = "ECS"
  type        = string
  description = "Type of deployment controller. Valid values: CODE_DEPLOY, ECS, EXTERNAL. Default: ECS."
}

variable "create_repository_credentials_iam_policy" {
  default     = false
  description = "Set to true if you are specifying `repository_credentials` variable, it will attach IAM policy with necessary permissions to task role."
}

variable "propogate_tags" {
  type        = string
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION."
  default     = "TASK_DEFINITION"
}

variable "volume" {
  description = "(Optional) A set of volume blocks that containers in your task may use. This is a list of maps, where each map should contain \"name\", \"host_path\", \"docker_volume_configuration\" and \"efs_volume_configuration\". Full set of options can be found at https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html"
  default     = []
}

variable "task_container_cpu" {
  description = "Amount of CPU to reserve for the container."
  default     = null
  type        = number
}

variable "task_container_memory" {
  description = "The hard limit (in MiB) of memory for the container."
  default     = null
  type        = number
}

variable "task_container_memory_reservation" {
  description = "The soft limit (in MiB) of memory to reserve for the container."
  default     = null
  type        = number
}

variable "task_container_working_directory" {
  description = "The working directory to run commands inside the container."
  default     = ""
  type        = string
}

variable "task_start_timeout" {
  type        = number
  description = "Time duration (in seconds) to wait before giving up on resolving dependencies for a container. If this parameter is not specified, the default value of 3 minutes is used (fargate)."
  default     = null
}

variable "task_stop_timeout" {
  type        = number
  description = "Time duration (in seconds) to wait before the container is forcefully killed if it doesn't exit normally on its own. The max stop timeout value is 120 seconds and if the parameter is not specified, the default value of 30 seconds is used."
  default     = null
}

variable "task_mount_points" {
  description = "The mount points for data volumes in your container. Each object inside the list requires \"sourceVolume\", \"containerPath\" and \"readOnly\". For more information see https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html "
  type        = list(object({ sourceVolume = string, containerPath = string, readOnly = bool }))
  default     = null
}

variable "task_pseudo_terminal" {
  type        = bool
  description = "Allocate TTY in the container"
  default     = null
}

variable "force_new_deployment" {
  type        = bool
  description = "Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g. myimage:latest), roll Fargate tasks onto a newer platform version."
  default     = false
}

variable "wait_for_steady_state" {
  type        = bool
  description = "If true, Terraform will wait for the service to reach a steady state (like aws ecs wait services-stable) before continuing."
  default     = false
}

variable "enable_execute_command" {
  type        = bool
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service."
  default     = true
}