output "alb-dns"{
  value = aws_lb.alb.dns_name
}

output "tg-arn" {
  value = aws_lb_target_group.tg.arn
}

output "listener" {
  value = aws_lb_listener.front_end
}
