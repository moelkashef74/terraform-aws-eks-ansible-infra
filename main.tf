module "network" {
  source           = "./network"
  vpc_cidr_block   = var.vpc_cidr_block
  region           = var.region
  pub_cidr_blocks  = var.pub_cidr_blocks
  priv_cidr_blocks = var.priv_cidr_blocks
  azs              = var.azs
}

module "eks" {
  source                  = "./eks"
  cluster_name            = var.cluster_name
  kubernetes_version      = var.kubernetes_version
  vpc_id                  = module.network.vpc_id
  private_subnet_ids      = module.network.private_subnet_ids
  node_group_name         = var.node_group_name
  node_instance_types     = var.node_instance_types
  desired_size            = var.desired_size
  max_size                = var.max_size
  min_size                = var.min_size
  endpoint_public_access  = var.endpoint_public_access
  endpoint_private_access = var.endpoint_private_access
}
module "ec2" {
  source               = "./ec2"
  vpc_id               = module.network.vpc_id
  create_key_pair      = var.create_key_pair
  key_name             = var.key_name
  public_key_path      = var.public_key_path
  ssh_private_key_path = var.ssh_private_key_path
  public_subnet_ids    = module.network.public_subnet_ids
  private_subnet_ids   = module.network.private_subnet_ids
}
output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

