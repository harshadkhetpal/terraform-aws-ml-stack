# Author: Harshad Khetpal <harshadkhetpal@gmail.com>
# Terraform — SageMaker Studio Domain + Feature Store

resource "aws_sagemaker_domain" "ml_domain" {
  domain_name             = var.domain_name
  auth_mode               = "IAM"
  vpc_id                  = var.vpc_id
  subnet_ids              = var.private_subnet_ids
  app_network_access_type = "VpcOnly"

  default_user_settings {
    execution_role = aws_iam_role.sagemaker_execution.arn

    jupyter_server_app_settings {
      default_resource_spec {
        instance_type       = "system"
        sagemaker_image_arn = data.aws_sagemaker_prebuilt_ecr_image.jupyter.registry_path
      }
    }

    kernel_gateway_app_settings {
      default_resource_spec {
        instance_type = "ml.t3.medium"
      }
      lifecycle_config_arns = [aws_sagemaker_studio_lifecycle_config.auto_shutdown.arn]
    }
  }

  tags = var.tags
}

resource "aws_sagemaker_feature_group" "ml_features" {
  feature_group_name             = "${var.project}-features"
  record_identifier_feature_name = "entity_id"
  event_time_feature_name        = "event_time"
  role_arn                       = aws_iam_role.sagemaker_execution.arn

  online_store_config  { enable_online_store = true }
  offline_store_config {
    s3_storage_config { s3_uri = "s3://${var.data_bucket}/feature-store/" }
    disable_glue_table_creation = false
  }

  dynamic "feature_definition" {
    for_each = var.feature_definitions
    content {
      feature_name = feature_definition.value.name
      feature_type = feature_definition.value.type
    }
  }

  tags = var.tags
}

resource "aws_iam_role" "sagemaker_execution" {
  name = "${var.project}-sagemaker-execution"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "sagemaker.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  ]
  tags = var.tags
}

resource "aws_sagemaker_studio_lifecycle_config" "auto_shutdown" {
  studio_lifecycle_config_name     = "${var.project}-auto-shutdown"
  studio_lifecycle_config_app_type = "KernelGateway"
  studio_lifecycle_config_content  = base64encode(file("${path.module}/scripts/auto_shutdown.sh"))
}
