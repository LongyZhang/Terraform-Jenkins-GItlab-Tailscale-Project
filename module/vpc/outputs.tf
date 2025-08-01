
output "vpc_id" {
  description = "ID of the VPC where the resources are deployed"
  value       = aws_vpc.main.id
}

output "private_subnet_id" {
    description = "ID of the private subnet"
    value       = aws_subnet.private_subnet.id
  
}

output "public_subnet_id" {
    description = "ID of the public subnet"
    value       = aws_subnet.public_subnet.id
  
}