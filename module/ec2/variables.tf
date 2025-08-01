variable "private_instance_names" {
    description = "List of names for private EC2 instances"
    type        = list(string)
}
variable "public_instance_names" {
    description = "List of names for public EC2 instances"
    type        = list(string)
}

variable "ebs_volume_size" {
    description = "Size of the EBS volume in GB"
    type        = number
}


variable "instance_type" {
    description = "Instance type for the EC2 instance"
    type        = string  
}

variable "private_suibnet_id" {
    description = "ID of the private subnet for the EC2 instance"
    type        = string
  
}

variable "public_suibnet_id" {
    description = "ID of the public subnet for the EC2 instance"
    type        = string
  
}

variable "private_security_group" {
    description = "ID Security group for the private EC2 instance"
    type        = string
  
}

variable "public_security_group" {
    description = "ID Security group for the public EC2 instance"
    type        = string
  
}

# variable "tailscale_security_group" {
#     description = "Security group for Tailscale access"
#     type        = string
  
# }

variable "iam_instance_profile" {
    description = "IAM instance profile for the EC2 instance"
    type        = string
  
}

variable "key_name" {
    description = "Key pair name for SSH access to the EC2 instance"
    type        = string  
}

variable "availability_zone" {
    description = "Availability zone for the EBS volume"
    type        = string
}