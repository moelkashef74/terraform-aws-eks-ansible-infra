resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ansible_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = var.public_subnet_ids[1]
  key_name      = var.create_key_pair ? aws_key_pair.my_key[0].key_name : var.key_name
  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]


  tags = {
    Name = "Ansible-EC2"
    Role = "Ansible-Managed"
  }
}
resource "null_resource" "configure" {

  depends_on = [
    aws_instance.ansible_ec2
  ]

  provisioner "local-exec" {
  interpreter = ["/bin/bash", "-c"]

  command = <<-EOT
    until nc -z ${aws_instance.ansible_ec2.public_ip} 22; do
      echo "Waiting for SSH on ${aws_instance.ansible_ec2.public_ip}..."
      sleep 10
    done

    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
      -i '${aws_instance.ansible_ec2.public_ip},' \
      --private-key='${pathexpand(var.ssh_private_key_path)}' \
      --user ubuntu \
      '${path.root}/ansible/nginx-playbook.yaml'
  EOT
}
}