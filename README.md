# terraform-aws-eks-ansible-infra
AWS infrastructure with Terraform and Ansible for provisioning a VPC, EKS cluster, and Nginx configuration.

## What This Deploys

- AWS VPC with public and private subnets
- Internet Gateway and NAT Gateway for private node egress
- Amazon EKS cluster with a managed node group
- Ansible playbook and nginx role for configuring Nginx on target hosts

## Authentication

Authenticate with AWS before running Terraform:

```powershell
aws configure
aws sts get-caller-identity
```
Authenticate Terraform with AWS:

```powershell


## Terraform Workflow

```powershell
terraform init
terraform workspace select dev
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

## Get EKS Credentials

```powershell
aws eks update-kubeconfig --name <cluster-name> --region <region>
kubectl get nodes
```

## Ansible

The Ansible folder includes a playbook that installs Nginx using the `nginx` role.

If you use the EC2 module, create your own AWS key pair and keep the private key only on your local machine. Do not commit `.pem` files to GitHub.

Set these values in your local tfvars file when needed:

- `key_name`
- `public_key_path`
- `ssh_private_key_path`

```powershell
ansible-playbook -i ansible/nginx/tests/inventory ansible/nginx-playbook.yaml
```
