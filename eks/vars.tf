variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster is deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for EKS cluster and node group"
  type        = list(string)
}

variable "node_group_name" {
  description = "Managed node group name"
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
  description = "Whether EKS API endpoint is publicly accessible"
  type        = bool
}

variable "endpoint_private_access" {
  description = "Whether EKS API endpoint is privately accessible"
  type        = bool
}
