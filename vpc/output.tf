output "public-subnet-1a-id" {
  value = aws_subnet.public_subnet[0].id
}

output "public-subnet-1b-id" {
  value = aws_subnet.public_subnet[1].id
}

/*
output "public_subnet_names" {
  value = aws_subnet.public_subnet[*].id
}
*/

output "vpc_id" {
  value = aws_vpc.vpc.id
}
