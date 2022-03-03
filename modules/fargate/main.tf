resource "aws_iam_role" "execution" {
  name               = "${var.name_prefix}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume.json

  tags = var.tags
}

resource "aws_iam_role_policy" "task_execution" {
  name   = "${var.name_prefix}-task-execution"
  role   = aws_iam_role.execution.id
  policy = data.aws_iam_policy_document.task_execution_permissions.json
}

resource "aws_iam_role" "task" {
  name               = "${var.name_prefix}-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume.json

  tags = var.tags
}

resource "aws_iam_role_policy" "ecs_exec_inline_policy" {
  count = var.enable_execute_command ? 1 : 0

  name   = "${var.name_prefix}-ecs-exec-permissions"
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.task_ecs_exec_policy[0].json
}

resource "aws_security_group" "ecs_service" {
  vpc_id      = var.vpc_id
  name_prefix = var.sg_name_prefix == "" ? "${var.name_prefix}-ecs-service-sg-" : "${var.sg_name_prefix}-"
  description = "Fargate service security group"
  tags = merge(
    var.tags,
    {
      Name = var.sg_name_prefix == "" ? "${var.name_prefix}-ecs-service-sg" : var.sg_name_prefix
    },
  )

  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "egress_service" {
  security_group_id = aws_security_group.ecs_service.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

locals {
  task_environment = [
    for k, v in var.task_container_environment : {
      name  = k
      value = v
    }
  ]
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.name_prefix
  execution_role_arn       = aws_iam_role.execution.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_definition_cpu
  memory                   = var.task_definition_memory
  task_role_arn            = aws_iam_role.task.arn

  dynamic "ephemeral_storage" {
    for_each = var.task_definition_ephemeral_storage == 0 ? [] : [var.task_definition_ephemeral_storage]
    content {
      size_in_gib = var.task_definition_ephemeral_storage
    }
  }

  container_definitions = <<EOF
[{
  "name": "${var.container_name != "" ? var.container_name : var.name_prefix}",
  "image": "${var.task_container_image}",
  "essential": true,
  "command": ${jsonencode(var.task_container_command)},
  %{if var.task_container_working_directory != ""~}
  "workingDirectory": ${var.task_container_working_directory},
  %{~endif}
  %{if var.task_container_memory != null~}
  "memory": ${var.task_container_memory},
  %{~endif}
  %{if var.task_container_memory_reservation != null~}
  "memoryReservation": ${var.task_container_memory_reservation},
  %{~endif}
  %{if var.task_container_cpu != null~}
  "cpu": ${var.task_container_cpu},
  %{~endif}
  %{if var.task_start_timeout != null~}
  "startTimeout": ${var.task_start_timeout},
  %{~endif}
  %{if var.task_stop_timeout != null~}
  "stopTimeout": ${var.task_stop_timeout},
  %{~endif}
  %{if var.task_mount_points != null~}
  "mountPoints": ${jsonencode(var.task_mount_points)},
  %{~endif}
  %{if var.task_container_secrets != null~}
  "secrets": ${jsonencode(var.task_container_secrets)},
  %{~endif}
  %{if var.task_pseudo_terminal != null~}
  "pseudoTerminal": ${var.task_pseudo_terminal},
  %{~endif}
  "environment": ${jsonencode(local.task_environment)}
}]
EOF

  dynamic "volume" {
    for_each = var.volume
    content {
      name      = volume.value.name
      host_path = lookup(volume.value, "host_path", null)

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])
        content {
          scope         = lookup(docker_volume_configuration.value, "scope", null)
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
        }
      }
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.container_name != "" ? var.container_name : var.name_prefix
    },
  )
}

resource "aws_ecs_service" "service" {
  name = var.name_prefix

  cluster         = var.cluster_id
  task_definition = "${aws_ecs_task_definition.task.family}:${max(aws_ecs_task_definition.task.revision, data.aws_ecs_task_definition.task.revision)}"

  desired_count  = var.desired_count
  propagate_tags = var.propogate_tags

  platform_version = var.platform_version
  launch_type      = "FARGATE"

  force_new_deployment   = var.force_new_deployment
  wait_for_steady_state  = var.wait_for_steady_state
  enable_execute_command = var.enable_execute_command

  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = false
  }

  deployment_controller {
    type = var.deployment_controller_type
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-service"
    },
  )
}