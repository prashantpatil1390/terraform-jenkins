module "vpc" {
  source = "./vpc"
}

module "elb" {
  source = "./elb"
#  public_subnets = ["module.vpc.public_subnet_names[0].id", "module.vpc.public_subnet_names[1].id"]
  public_subnet-1a = module.vpc.public-subnet-1a-id
  public_subnet-1b = module.vpc.public-subnet-1b-id
  vpc_id = module.vpc.vpc_id
  alb-sg = module.network.alb-sg-id
#  lb_logs_bkt = module.s3.s3-state-name
}

module "network" {
  source = "./networking"
  vpc_id = module.vpc.vpc_id
}

module "ecr" {
  source = "./ecr"
}
/*
module "ecs" {
  source = "./ecs"
  alb-sg = module.network.alb-sg-id
  private_subnets = module.vpc.private_subnet
}
*/
