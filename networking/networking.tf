resource aws_security_group "alb-sg" {
 name        = "allow_80"
 description = "Allow http inbound traffic"
 vpc_id      = var.vpc_id

 ingress {
 description      = "http from VPC"
 from_port        = 80
 to_port          = 80
 protocol         = "TCP"
 cidr_blocks      = ["0.0.0.0/0"]
 }

 egress {
 from_port        = 0
 to_port          = 0
 protocol         = "-1"
 cidr_blocks      = ["0.0.0.0/0"]
 ipv6_cidr_blocks = ["::/0"]
 }

 tags = {
   Name = "allow_http"
 }
}
