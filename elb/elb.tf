resource "aws_lb" "alb" {
  name               = "tf-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.alb-sg}"]
  subnets            = [var.public_subnet-1a, var.public_subnet-1b]

  enable_deletion_protection = true
/*
  access_logs {
    bucket  = var.lb_logs_bkt
    prefix  = "tf-alb"
    enabled = true
  }
*/
  tags = {
    Environment = "Prod"
  }
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "ecs-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  # Alter the destination of the health check to be the login page.
  health_check {
    path = "/"
    port = 80
  }
}
