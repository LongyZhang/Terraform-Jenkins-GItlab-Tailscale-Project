resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")  # adjust path as needed
} 

resource "aws_security_group" "allow_access_from_public_subnet" {
  name        = "allow_access_from_public_subnet"
  description = "Allow access from public subnet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidr]
  }
    ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "allow_access_from_vpn_node" {

  ## allow the traffic from the VPN node to the private nodes
  ## why do we need this?
  ## because tailscale treats the VPN node as a subnet route
  ## we adviertise the private subnet on vpn node
  ## my lcoal machine accetp subnet route from vpn node.connection 
  ## how make this autehntication is safe? we have admin dashboard to approve the subnet route.connection {
  
  
  name        = "allow_access_from_tailscale_vpn_node"
  description = "allow_access_from_home_ip"
  vpc_id      = var.vpc_id

  
  ingress {
    description = "SSH from my tailscale VPN server"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.tailscale_private_ip}/32"]
  }

  ingress {
    description = "Jenkins port from my tailscale VPN server"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.tailscale_private_ip}/32"]
  }

    ingress {
    description = "Gitlab port from my tailscale VPN server"
    from_port   = 2224
    to_port     = 2224
    protocol    = "tcp"
    cidr_blocks = ["${var.tailscale_private_ip}/32"]
  }


  ingress {
    description = "Gitlab port from my tailscale VPN server"
    from_port   = 8929
    to_port     = 8929
    protocol    = "tcp"
    cidr_blocks = ["${var.tailscale_private_ip}/32"]
  }
    ingress {
    description = "Gitlab port from my tailscale VPN server"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.tailscale_private_ip}/32"]
  }
}



resource "aws_security_group" "allow_access_from_private_subnet" {
  name_prefix = "allow_ssh_"
  vpc_id      = var.vpc_id

  
  ingress {
    description = "HTTP from private subnet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr]
  }
  ingress {
    description = "Allow the GItlab talk to Jenkins from private subnet"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr]
  }
  ingress {
    description = "Allow the GItlab talk to Jenkins from private subnet"
    from_port   = 8929
    to_port     = 8929
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr]
  }
  
  
  ingress {
    description = "HTTPS from private subnet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr]
  }
  
  ingress {
    description = "SSH from private subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr]
  }
  
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}


resource "aws_iam_role" "ssm_role" {
  name = "ssm-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
  
  tags = {
    Name = "ssm-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm-profile"
  role = aws_iam_role.ssm_role.name
  
}