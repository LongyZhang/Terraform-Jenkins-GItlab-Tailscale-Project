variable "instance_type" {
    description = "Instance type for the EC2 instance"
    type        = string
    default     = "m4.large"
  
}

variable "aws_region" {
    description = "AWS region to deploy the EC2 instances"
    type        = string
    default     = "us-east-1"
  
}

variable "availability_zone" {
    description = "Availability zone for the resources"
    type        = string
    default     = "us-east-1a"
  
}

variable "ebs_volume_size" {
    description = "Size of the EBS volume in GB"
    type        = number
    default     = 50
  
}


variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
  
}

variable "public_subnet_cidr" {
    description = "CIDR block for the public subnet"
    type        = string
    default     = "10.0.1.0/24"
  
}

variable "private_subnet_cidr" {
   description = "CIDR block for the public subnet"
    type        = string
    default     = "10.0.5.0/24"
}
