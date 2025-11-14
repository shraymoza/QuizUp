locals {
  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  # Prefer package path over source dir to avoid packaging all dependencies
  # Only use source dir if package path is not provided AND source dir is explicitly set
  lambda_source_dir = trimspace(var.lambda_package_path) == "" && trimspace(var.lambda_source_dir) != "" ? var.lambda_source_dir : ""
}

module "network" {
  source               = "./modules/network"
  environment          = var.environment
  project_name         = var.project_name
  tags                 = local.tags
  vpc_cidr             = var.network_vpc_cidr
  public_subnet_cidrs  = var.network_public_subnet_cidrs
  private_subnet_cidrs = var.network_private_subnet_cidrs
  enable_nat_gateway   = var.network_enable_nat_gateway
  single_nat_gateway   = var.network_single_nat_gateway
}

module "storage" {
  source            = "./modules/storage"
  environment       = var.environment
  project_name      = var.project_name
  tags              = local.tags
  raw_prefix        = var.storage_raw_prefix
  index_prefix      = var.storage_index_prefix
  outputs_prefix    = var.storage_outputs_prefix
  enable_versioning = var.storage_enable_versioning
  force_destroy     = var.storage_force_destroy
}

module "auth" {
  source       = "./modules/auth"
  environment  = var.environment
  project_name = var.project_name
  tags         = local.tags

  # Default callback/logout URLs (can be updated later with Amplify URL)
  # Note: Amplify URL will be added after deployment via Terraform update or manually in Cognito Console
  callback_urls = ["http://localhost:5173", "http://localhost:3000"]
  logout_urls   = ["http://localhost:5173", "http://localhost:3000"]
}

module "ml" {
  source              = "./modules/ml"
  environment         = var.environment
  project_name        = var.project_name
  tags                = local.tags
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.private_subnet_ids
  storage_bucket_name = module.storage.bucket_name
  storage_bucket_arn  = module.storage.bucket_arn
  storage_prefixes    = module.storage.prefixes
  model_artifact_s3_path = var.ml_model_artifact_s3_path
  embedding_model_id    = var.ml_embedding_model_id
}

module "api" {
  source                  = "./modules/api"
  environment             = var.environment
  project_name            = var.project_name
  tags                    = local.tags
  storage_bucket_name     = module.storage.bucket_name
  storage_bucket_arn      = module.storage.bucket_arn
  storage_prefixes        = module.storage.prefixes
  sagemaker_endpoint_name = module.ml.endpoint_name != null ? module.ml.endpoint_name : ""
  lambda_source_dir       = local.lambda_source_dir
  lambda_package_path     = var.lambda_package_path
  lambda_layers           = var.api_lambda_layers
  embedding_model         = var.lambda_embedding_model
  rag_top_k               = var.lambda_rag_top_k
}

module "monitoring" {
  source                  = "./modules/monitoring"
  environment             = var.environment
  project_name            = var.project_name
  tags                    = local.tags
  lambda_function_name    = module.api.lambda_function_name
  api_id                  = module.api.api_gateway_id
  api_stage_name          = module.api.api_stage_name
  sagemaker_endpoint_name = module.ml.endpoint_name != null ? module.ml.endpoint_name : ""
  alarm_topic_arn         = var.monitoring_alarm_topic_arn
}

# Amplify app for frontend hosting (optional - set amplify_repository_url to enable)
module "amplify" {
  count = var.amplify_repository_url != "" ? 1 : 0

  source = "./modules/amplify"

  project_name = var.project_name
  environment  = var.environment
  tags         = local.tags

  repository_url = var.amplify_repository_url
  oauth_token    = var.github_token
  branch_name    = var.amplify_branch_name

  environment_variables = {
    VITE_API_BASE_URL           = module.api.lambda_function_url
    VITE_COGNITO_USER_POOL_ID   = module.auth.user_pool_id
    VITE_COGNITO_CLIENT_ID      = module.auth.user_pool_client_id
    VITE_COGNITO_REGION         = var.aws_region
    VITE_COGNITO_DOMAIN         = module.auth.user_pool_domain
    VITE_COGNITO_HOSTED_UI_URL = module.auth.hosted_ui_url
  }

  depends_on = [module.api, module.auth]
}
