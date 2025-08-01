# Jenkins CI/CD with Private EC2 Access via VPN (Terraform + AWS + Tailscale)

## 📌 Overview

This project deploys a Jenkins GItlab CI/CD and docker pipeline on an EC2 instance in a **Private subnet**, and Tailsacle VPN server in **private subnets**, all within a custom VPC on AWS. Tailscale is used for secure access to private EC2 resources over a VPN tunnel. The infrastructure is fully provisioned using **Terraform**.


## 🗂️ Architecture

- **VPC** with public and private subnets
- **NAT Gateway** for outbound internet access from private subnets
- **Internet Gateway** for public subnet
- **EC2 (VPN Master)** in the public subnet
- **EC2 (jenkins Nodes)** in private subnets
- **EC2 (Gitlab Nodes)** in private subnets
- **EC2 (DOcker Nodes)** in private subnets 
- **Tailscale** advertise private subnet from VPN EC2 instance to securely access private nodes
- **Security Groups** managed in a separate Terraform module


# Your new directory structure should look like this:
#
# terraform-infrastructure/
# ├── main.tf
# ├── variables.tf
# ├── outputs.tf
# ├── terraform.tfvars (optional)
# ├── user_data/
# │   └── user_data.sh
# └── modules/
#     ├── vpc/
#     │   ├── main.tf
#     │   ├── variables.tf
#     │   └── outputs.tf
#     ├── security/
#     │   ├── main.tf
#     │   ├── variables.tf
#     │   └── outputs.tf
#     └── ec2/
#         ├── main.tf
#         ├── variables.tf
#         └── outputs.tf
