resource "aws_ecs_cluster" "web-cluster" {
  name = "MyWeb-Cluster"
}

data "template_file" "myapp" {
  template = file("./ecs/templates/image/image.json")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "task_def" {
  family                   = "nginxapp-task"
  execution_role_arn       = var.ecs_task_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.myapp.rendered
}

resource "aws_ecs_service" "test-service" {
  name            = "nginxapp-service"
  cluster         = aws_ecs_cluster.web-cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.alb-sg]
    subnets          = [var.private_subnet-1a, var.private_subnet-1b]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.tg-arn
    container_name   = "nginxapp"
    container_port   = var.app_port
  }

//  depends_on = [aws_alb_listener.testapp, aws_iam_role_policy_attachment.ecs_task_execution_role]
//  depends_on = [module.alb.aws_lb_listener.front_end, module.iam.aws_iam_role.ecs_task_execution_role]
}
