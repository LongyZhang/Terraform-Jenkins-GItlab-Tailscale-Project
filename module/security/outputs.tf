output "private_security_group" {
  description = "Security group allowing access from the public subnet"
  value       = aws_security_group.allow_access_from_private_subnet.id  
}

output "public_security_group" {
  description = "Security group allowing access from the private subnet"
  value       = aws_security_group.allow_access_from_public_subnet.id  
  
}

output "key_pair_name" {
  description = "Name of the key pair used for SSH access"
  value       = aws_key_pair.my_key.key_name
  
}

output "iam_instance_profile" {
  description = "IAM instance profile for the EC2 instances"
  value       = aws_iam_instance_profile.ssm_profile.name
  
}

output "allow_access_from_vpn_node" {
  description = "Security group allowing access from home IP"
  value       = aws_security_group.allow_access_from_vpn_node.id
  
}