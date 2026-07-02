data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

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
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.elb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  count         = 4
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = element(var.public_subnet_ids, count.index % length(var.public_subnet_ids))
  key_name      = var.create_key_pair ? aws_key_pair.my_key[0].key_name : var.key_name
  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]
  # user_data = var.user_data

  tags = {
    Name = "web-${count.index + 1}"
    Role = "web"
  }
resource "null_resource" "configure" {

  depends_on = [
    aws_instance.web
  ]

  provisioner "local-exec" {

    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${join(",", aws_instance.web[*].public_ip)},' --private-key=${pathexpand(var.ssh_private_key_path)} --user ubuntu ${path.root}/ansible/nginx-playbook.yaml"
  }
}
