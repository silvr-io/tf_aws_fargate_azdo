output "service_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the ECS service."
  value       = aws_ecs_service.service.id
}

output "task_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the ECS service role."
  value       = aws_iam_role.task.arn
}

output "task_role_name" {
  description = "The name of the Fargate task service role."
  value       = aws_iam_role.task.name
}

output "service_sg_id" {
  description = "The Amazon Resource Name (ARN) that identifies the service security group."
  value       = aws_security_group.ecs_service.id
}

output "service_name" {
  description = "The name of the service."
  value       = aws_ecs_service.service.name
}

output "execution_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the ECS execution role."
  value       = aws_iam_role.execution.arn
}

output "execution_role_name" {
  description = "The name of the ECS execution role."
  value       = aws_iam_role.execution.name
}

output "task_definition_arn" {
  description = "The Amazon Resource Name (ARN) of the task definition created"
  value       = aws_ecs_task_definition.task.arn
}

output "task_definition_name" {
  description = "The name of the task definition created"
  value       = aws_ecs_task_definition.task.arn
}