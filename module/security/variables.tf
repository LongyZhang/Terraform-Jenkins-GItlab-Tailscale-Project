variable "my_ip" {
    description = "My public IP address in CIDR notation"
    type        = string
  
}

variable "private_subnet_cidr" {
    description = "CIDR block for the private subnet"
    type        = string
  
}


variable "vpc_id" {
    description = "ID of the VPC where the resources will be deployed"
    type        = string
  
}

variable "public_subnet_cidr" {
    description = "CIDR block for the public subnet"
    type        = string
  
}



variable "tailscale_private_ip" {
  description = "Private IP of the VPN server"
  type        = string
}