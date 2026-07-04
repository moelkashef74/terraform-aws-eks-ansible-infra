output "ec2_public_ips" {
  value = aws_instance.ansible_ec2.public_ip
}