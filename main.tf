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
  public_subnet_ids      = module.network.public_subnet_ids
  node_group_name         = var.node_group_name
  node_instance_types     = var.node_instance_types
  desired_size            = var.desired_size
  max_size                = var.max_size
  min_size                = var.min_size
  endpoint_public_access  = var.endpoint_public_access
  endpoint_private_access = var.endpoint_private_access
}
# module "sns" {
#   source = "./sns"
#   topic_name          = "s3-upload-notifier"
#   email_endpoint      = "mhmdalsyd2015@gmail.com"
#   bucket_name         = "s3-upload-notifier-bucket"
#   lambda_role_name    = "s3-upload-lambda-role"
#   lambda_function_name = "s3-upload-lambda-function"
# }
output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

