## ami details

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"] # Amazon

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

## EC2 Instance Configuration

resource "aws_instance" "private_nodes" {
  count         = length(var.private_instance_names)
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.private_suibnet_id
  security_groups = [var.private_security_group]
  iam_instance_profile = var.iam_instance_profile
  key_name = var.key_name
  user_data = file("user_data/user_data.sh")
  tags = {
    Name = var.private_instance_names[count.index]
  }

}

resource "aws_instance" "public_nodes" {
  count         = length(var.public_instance_names)
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.public_suibnet_id
  security_groups = [var.public_security_group]
  iam_instance_profile = var.iam_instance_profile
  key_name = var.key_name
  user_data = file("user_data/user_data.sh")
  tags = {
    Name = var.public_instance_names[count.index]
  }
}

## EBS Volume Attachment 
## only private nodes have additional EBS volumes attached

resource "aws_ebs_volume" "private_volume" {
  count = length(var.private_instance_names)
  availability_zone = var.availability_zone
  size = var.ebs_volume_size # Size in GB
    type = "gp2"
    tags = {
      Name = "${var.private_instance_names[count.index]}-volume"
    }
  
}

resource "aws_volume_attachment" "ebs_attachment" {
  count = length((var.private_instance_names))
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.private_volume[count.index].id
  instance_id = aws_instance.private_nodes[count.index].id
   force_detach = true
}

