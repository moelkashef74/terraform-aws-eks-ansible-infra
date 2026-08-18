# Terraform AWS EKS + Ansible Infrastructure

This repository provisions a complete AWS-based Kubernetes platform using Terraform, configures a Jenkins automation server with Ansible, and includes Kubernetes manifests for a sample application stack.

## What this project deploys

- AWS VPC, subnets, gateways, and routing resources
- Amazon EKS cluster and managed node group
- EC2 instance for Ansible-based configuration management
- Jenkins automation server provisioned through Ansible
- Kubernetes deployment manifests for a Node.js app and supporting resources
- CI/CD pipeline examples using Jenkins and a Node.js application

## Repository structure

```text
.
├── main.tf                  # Root Terraform entry point
├── vars.tf                  # Shared Terraform variables
├── provider.tf              # AWS provider configuration
├── backend.tf               # S3 backend config for Terraform state
├── terraform.tfvars         # Default environment values
├── dev.tfvars               # Development configuration
├── prod.tfvars              # Production configuration
├── test.tfvars              # Test configuration
├── Jenkinsfile              # Jenkins pipeline for Terraform apply
├── ansible/                 # Ansible playbooks and roles
│   ├── site.yml
│   ├── ansible.cfg
│   └── roles/
│       └── jenkins/
├── aws/                     # AWS CLI installer bundle
├── CI-CD/                   # Sample Node.js app and Jenkins CD assets
├── ec2/                     # EC2 resources and SSH key setup
├── eks/                     # EKS cluster and node group resources
├── network/                 # VPC and networking resources
├── kubernetes/              # Kubernetes manifests
└── README.md                # Project documentation
```

## Architecture overview

The project is organized as a modular Terraform infrastructure repo:

- `network/` creates the VPC and public/private subnets.
- `eks/` creates the IAM roles, EKS cluster, and managed worker nodes.
- `ec2/` creates an EC2 instance and optional SSH key pair for remote configuration.
- `ansible/` configures a Jenkins server and related tooling using Ansible.
- `kubernetes/` contains deployment and service YAML for the workload running inside EKS.
- `CI-CD/` contains a sample application and Jenkins pipeline artifacts.

## Prerequisites

Before running this project, make sure you have:

- An AWS account with permissions to create VPC, EC2, EKS, IAM, and related resources
- Terraform installed
- Ansible installed
- AWS CLI configured with valid credentials
- SSH key pair available for EC2 access if needed
- A Terraform backend S3 bucket already created or updated in `backend.tf`

## Configuration

The root Terraform variables are defined in `vars.tf` and values are supplied through files like:

- `terraform.tfvars`
- `dev.tfvars`
- `test.tfvars`
- `prod.tfvars`

Example values include:

- AWS region
- VPC CIDR block
- Public/private subnet ranges
- EKS cluster name and version
- Node group sizing
- SSH key configuration

Edit these files before running Terraform for your target environment.

## Terraform workflow

From the project root:

```bash
terraform init
terraform workspace select dev   # or create a new workspace
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

This repo also includes a Jenkins pipeline in `Jenkinsfile` that automates workspace selection, plan review, and apply for `dev`, `test`, and `prod` environments.

## Ansible workflow

The EC2 instance created by Terraform runs an Ansible playbook located at `ansible/site.yml`.

```bash
ansible-playbook -i <ec2-public-ip>, ansible/site.yml \
  --private-key ~/.ssh/id_rsa \
  --user ubuntu
```

The Jenkins role installs and configures the required software for CI/CD automation, including:

- Java
- Docker
- AWS CLI
- Kubernetes tooling
- Helm
- Trivy
- Jenkins plugins

## Kubernetes manifests

The manifests under `kubernetes/` include resources such as:

- `nodejs-app.yaml` for the application deployment
- `nodejs-svc.yaml` for service exposure
- `sql-statefulset.yaml` for SQL stateful workloads
- `docker-cred.yaml` for image pull secrets
- `app-config.yaml` and `app-secrets.yaml` for configuration
- RBAC resources for Jenkins access
- Storage and quota definitions

These files are intended to support the application workload deployed to the EKS cluster.

## CI/CD sample app

The `CI-CD/` directory contains a small Node.js web app with a Docker build setup and a Jenkins pipeline example. It is used as a demonstration of a deployment workflow for application delivery.

## Important notes

- The Terraform state backend is configured in `backend.tf` and points to an S3 bucket. Update the bucket name and region to match your AWS account.
- Some values such as SSH paths and environment-specific variables should be adjusted to your local setup.
- The EC2 instance configuration supports SSH access and provisioning through Ansible after instance boot.

## Typical deployment flow

1. Configure AWS credentials and Terraform variables.
2. Run `terraform init` and `terraform apply` for the target environment.
3. Let the EC2 instance bootstrap through Ansible.
4. Configure Jenkins and Kubernetes access from the provisioned environment.
5. Deploy application manifests under `kubernetes/` to the EKS cluster.

## Cleanup

To destroy the infrastructure:

```bash
terraform destroy -var-file=dev.tfvars
```

## License

This repository does not currently declare an explicit license. Review the repository policies before using it in production or sharing it externally.
