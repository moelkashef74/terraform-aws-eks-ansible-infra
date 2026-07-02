# variable "user_data" {
#   description = "User data script to configure the EC2 instance"
#   type        = string
#   default     = <<-EOF
#               #!/bin/bash
#               apt update -y
#               apt install nginx -y
#               systemctl start nginx
#               systemctl enable nginx
#               echo "Hello from $(hostname)" > /var/www/html/index.html
#               EOF
# }

variable "vpc_id" {
  type        = string
}

variable "create_key_pair" {
  description = "Whether to create an AWS key pair from a local public key file"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "AWS key pair name to create or use"
  type        = string
}

variable "public_key_path" {
  description = "Path to the local public key file used when creating a key pair"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the local private key file used by Ansible"
  type        = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}
