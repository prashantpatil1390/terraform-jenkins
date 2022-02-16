variable "aws_account_no"{
  default = 053688395719
}

variable "ecs_task_execution_role" {
  default     = "myECcsTaskExecutionRole"
  description = "ECS task execution role name"
}

variable "aws_region" {
  default     = "us-east-1"
  description = "aws region where our resources going to create choose"
}

variable "private_subnet-1a" { }

variable "private_subnet-1b" { }

variable "alb-sg" { }

variable "ecs_task_execution_role_arn" { }

variable "tg-arn" { }
variable "listener" {}
variable "app_image" {
  default     = "nginx:latest"
  description = "docker image to run in this ECS cluster"
}

variable "app_port" {
  default     = "80"
  description = "portexposed on the docker image"
}

variable "app_count" {
  default     = "2" #choose 2 bcz i have choosen 2 AZ
  description = "numer of docker containers to run"
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  default     = "1024"
  description = "fargate instacne CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "fargate_memory" {
  default     = "2048"
  description = "Fargate instance memory to provision (in MiB) not MB"
}
