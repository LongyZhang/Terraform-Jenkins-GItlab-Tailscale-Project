provider "aws" {
  region = var.aws_region
}

# Data Source for external IP
data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  private_instance_names = [
    "GITLAB-node",
    "JENKINS-node",
    "DOCKER-node"
  ]
  public_instance_names = [
    "VPN-node"
  ]
}


module "vpc" {
  source = "./module/vpc"
    vpc_cidr= var.vpc_cidr
    public_subnet_cidr = var.public_subnet_cidr
    availability_zone = var.availability_zone
    private_subnet_cidr = var.private_subnet_cidr
    
}


module "security" {
    source = "./module/security"    
    vpc_id = module.vpc.vpc_id
    tailscale_private_ip= module.ec2.private_ip_vpn_server
    private_subnet_cidr = var.private_subnet_cidr
    public_subnet_cidr = var.public_subnet_cidr
    my_ip = chomp(data.http.my_ip.body)

}

module "ec2" {
    source = "./module/ec2"
    private_instance_names = local.private_instance_names
    public_instance_names  = local.public_instance_names
    instance_type          = var.instance_type
    private_suibnet_id     = module.vpc.private_subnet_id
    public_suibnet_id      = module.vpc.public_subnet_id
    private_security_group = module.security.private_security_group
    public_security_group  = module.security.public_security_group
    iam_instance_profile     = module.security.iam_instance_profile
    key_name                 = module.security.key_pair_name
    ebs_volume_size          = var.ebs_volume_size
    availability_zone        = var.availability_zone
}