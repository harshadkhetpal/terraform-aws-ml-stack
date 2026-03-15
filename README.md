# 🏗️ Terraform AWS ML Stack — IaC for ML Infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-1.8-7B42BC?style=flat-square&logo=terraform&logoColor=white)](https://terraform.io)
[![AWS](https://img.shields.io/badge/AWS-Multi--Service-FF9900?style=flat-square&logo=amazonaws&logoColor=white)](https://aws.amazon.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![Checkov](https://img.shields.io/badge/Checkov-Security_Scan-blue?style=flat-square)](https://checkov.io)

> Complete AWS ML infrastructure as code — EKS cluster, SageMaker domain, MLflow on ECS, S3 data lake, VPC with private subnets, IAM roles, and CloudWatch dashboards. Deploy a full ML platform in 15 minutes.

## 🏗 What Gets Deployed
- **Networking**: VPC, 3 AZs, private/public subnets, NAT gateway, VPC endpoints
- **Compute**: EKS cluster (g4dn GPU nodegroup + on-demand CPU nodegroup)
- **ML Platform**: SageMaker Studio domain, Feature Store, Model Registry
- **MLflow**: ECS Fargate service + RDS PostgreSQL + S3 artifact store
- **Storage**: S3 data lake with lifecycle policies + KMS encryption
- **Monitoring**: CloudWatch dashboards + SNS alerts + Cost anomaly detector

## 🚀 Deploy
```bash
git clone https://github.com/harshadkhetpal/terraform-aws-ml-stack
cd terraform-aws-ml-stack/environments/prod
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -auto-approve
```
