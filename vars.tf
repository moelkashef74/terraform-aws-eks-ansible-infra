variable "region" {
  description = "AWS region for infrastructure"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "pub_cidr_blocks" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "priv_cidr_blocks" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "azs" {
  description = "Availability zones for subnets"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS"
  type        = string
}

variable "node_group_name" {
  description = "EKS managed node group name"
  type        = string
}

variable "node_instance_types" {
  description = "EC2 instance types for EKS worker nodes"
  type        = list(string)
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "endpoint_public_access" {
  description = "Whether the EKS API endpoint is public"
  type        = bool
}

variable "endpoint_private_access" {
  description = "Whether the EKS API endpoint is private"
  type        = bool
}

variable "create_key_pair" {
  description = "Whether to create a new SSH key pair"
  type        = bool
}

variable "key_name" {
  description = "Name of the existing SSH key pair"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public key file for the SSH key pair"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the private key file for SSH access"
  type        = string
}

