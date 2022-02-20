resource "aws_cloudwatch_log_group" "log_group" {
  name = "MyWeb-Cluster-log-group"
}

resource "aws_ecs_cluster" "web-cluster" {
  name = "MyWeb-Cluster"

  configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.log_group.name
      }
    }
  }
}

resource "aws_ecs_task_definition" "task_def" {
  family                   = "nginxapp-task"
  execution_role_arn       = var.ecs_task_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = <<EOF
  [
    {
      "name": "nginx-container",
      "image": "${var.aws_account_no}.dkr.ecr.us-east-1.amazonaws.com/demo-ecr:latest",
      "memory": 1024,
      "cpu": 512,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ]
    }
  ]
  EOF
}

resource "aws_ecs_service" "ecs_service" {
  name            = "nginxapp-service"
  cluster         = aws_ecs_cluster.web-cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"
  force_new_deployment = "true"

  network_configuration {
    security_groups  = [var.alb-sg]
    subnets          = [var.private_subnet-1a, var.private_subnet-1b]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.tg-arn
    container_name   = "nginx-container"
    container_port   = var.app_port
  }

//  depends_on = [aws_alb_listener.testapp, aws_iam_role_policy_attachment.ecs_task_execution_role]
//  depends_on = [module.alb.aws_lb_listener.front_end, module.iam.aws_iam_role.ecs_task_execution_role]
  depends_on = [aws_ecs_task_definition.task_def]
}


resource "aws_appautoscaling_target" "auto_scale_target" {
  max_capacity = 4
  min_capacity = 2
  resource_id = "service/${aws_ecs_cluster.web-cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "memory_check" {
  name               = "memory_check"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.auto_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.auto_scale_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.auto_scale_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
  }
}

resource "aws_appautoscaling_policy" "cpu_check" {
  name = "cpu_check"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.auto_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.auto_scale_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.auto_scale_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}
