output "private_ip_vpn_server" {
  value = [for i in aws_instance.public_nodes : i.private_ip if i.tags["Name"] == "VPN-node"][0]
}
