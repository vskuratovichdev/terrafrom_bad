terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.35.0"
    }
  }
}

provider "azurerm" {
  features {}
  # Use Service Principal authentication via environment variables
  # ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID
  # These are set by the AzureCLI@2 task in the pipeline
}

module "resource_group" {
  source       = "./modules/resource_group"
  env_prefix   = var.env_prefix
  company_name = var.company_name
  location     = var.location
  tags         = var.tags
}

module "vnet" {
  source            = "./modules/vnet"
  env_prefix        = var.env_prefix
  company_name      = var.company_name
  location          = var.location
  address_space     = var.vnet_address_space
  resource_group_name = module.resource_group.resource_group_name
  tags              = var.tags
}

module "nat_gateway" {
  source            = "./modules/nat_gateway"
  env_prefix        = var.env_prefix
  company_name      = var.company_name
  location          = var.location
  resource_group_name = module.resource_group.resource_group_name
  tags              = var.tags
}

module "subnet_app" {
  source               = "./modules/subnet"
  env_prefix           = var.env_prefix
  company_name         = var.company_name
  vnet_name            = module.vnet.vnet_name
  subnet_name          = "${var.env_prefix}-${var.company_name}-app-subnet-subnet-01"
  address_prefixes     = [var.app_subnet_prefix]
  resource_group_name  = module.resource_group.resource_group_name
  nat_gateway_id       = module.nat_gateway.nat_gateway_id
  enable_nat_gateway   = true
  enable_service_endpoints = true
  enable_delegation   = true
}

module "subnet_vnet_integration" {
  source               = "./modules/subnet"
  env_prefix           = var.env_prefix
  company_name         = var.company_name
  vnet_name            = module.vnet.vnet_name
  subnet_name          = "${var.env_prefix}-${var.company_name}-vnet-integration-subnet-02"
  address_prefixes     = [var.vnet_integration_subnet_prefix]
  resource_group_name  = module.resource_group.resource_group_name
  nat_gateway_id       = module.nat_gateway.nat_gateway_id
  enable_nat_gateway   = true
  enable_service_endpoints = true
  enable_delegation   = true
}

module "subnet_db" {
  source               = "./modules/subnet"
  env_prefix           = var.env_prefix
  company_name         = var.company_name
  vnet_name            = module.vnet.vnet_name
  subnet_name          = "${var.env_prefix}-${var.company_name}-db-subnet-subnet-02"
  address_prefixes     = [var.db_subnet_prefix]
  resource_group_name  = module.resource_group.resource_group_name
  nat_gateway_id       = module.nat_gateway.nat_gateway_id
  enable_nat_gateway   = true
  enable_service_endpoints = true
}

module "subnet_build" {
  source               = "./modules/subnet"
  env_prefix           = var.env_prefix
  company_name         = var.company_name
  vnet_name            = module.vnet.vnet_name
  subnet_name          = "${var.env_prefix}-${var.company_name}-build-subnet-subnet-03"
  address_prefixes     = [var.build_subnet_prefix]
  resource_group_name  = module.resource_group.resource_group_name
  nat_gateway_id       = module.nat_gateway.nat_gateway_id
  enable_nat_gateway   = true
  enable_service_endpoints = true
}

module "storage_account" {
  source               = "./modules/storage_account"
  env_prefix           = var.env_prefix
  company_name         = var.company_name
  location             = var.location
  storage_account_name = var.storage_account_name
  resource_group_name  = module.resource_group.resource_group_name
  tags                 = var.tags
  subnet_id            = module.subnet_app.subnet_id
  enable_vnet_integration = true
}

module "backend" {
  source               = "./modules/app_service"
  env_prefix           = var.env_prefix
  company_name         = var.company_name
  location             = var.location
  app_service_plan_sku = var.app_service_plan_sku
  resource_group_name  = module.resource_group.resource_group_name
  tags                 = var.tags
  app_insights_connection_string = module.application_insights.connection_string
  subnet_id            = module.subnet_vnet_integration.subnet_id
  allowed_subnet_ids   = [module.subnet_db.subnet_id, module.subnet_build.subnet_id]
}

module "key_vault" {
  source               = "./modules/key_vault"
  env_prefix           = var.env_prefix
  company_name         = var.company_name
  location             = var.location
  key_vault_sku        = var.key_vault_sku
  tenant_id            = var.tenant_id
  resource_group_name  = module.resource_group.resource_group_name
  tags                 = var.tags
  subnet_id            = module.subnet_app.subnet_id
  enable_vnet_integration = true
}

module "log_analytics" {
  source               = "./modules/log_analytics"
  env_prefix           = var.env_prefix
  company_name         = var.company_name
  location             = var.location
  log_analytics_workspace_sku = var.log_analytics_workspace_sku
  resource_group_name  = module.resource_group.resource_group_name
  tags                 = var.tags
}

module "application_insights" {
  source               = "./modules/application_insights"
  env_prefix           = var.env_prefix
  company_name         = var.company_name
  location             = var.location
  app_insights_type    = var.app_insights_type
  workspace_id         = module.log_analytics.workspace_id
  resource_group_name  = module.resource_group.resource_group_name
  tags                 = var.tags
}

module "frontend" {
  source               = "./modules/static_web_app"
  env_prefix           = var.env_prefix
  company_name         = var.company_name
  location             = var.location
  static_web_app_sku   = var.static_web_app_sku
  resource_group_name  = module.resource_group.resource_group_name
  static_web_app_location = "westus2"
  tags                 = var.tags
  app_insights_connection_string = module.application_insights.connection_string
}

module "sql_server" {
  source               = "./modules/sql_server"
  env_prefix           = var.env_prefix
  company_name         = var.company_name
  location             = var.location
  resource_group_name  = module.resource_group.resource_group_name
  admin_username       = var.sql_admin_username
  admin_password       = var.sql_admin_password
  database_name        = var.sql_database_name
  sku_name             = var.sql_sku_name
  max_size_gb          = var.sql_max_size_gb
  tags                 = var.tags
}

module "managed_identity" {
  source               = "./modules/managed_identity"
  env_prefix           = var.env_prefix
  company_name         = var.company_name
  location             = var.location
  resource_group_name  = module.resource_group.resource_group_name
  sql_server_id        = module.sql_server.sql_server_id
  key_vault_id         = module.key_vault.key_vault_id
  tags                 = var.tags
}

module "reporting_app" {
  source                      = "./modules/container_app"
  env_prefix                  = var.env_prefix
  company_name                = var.company_name
  location                    = var.location
  resource_group_name         = module.resource_group.resource_group_name
  container_image             = var.container_image
  container_image_version     = var.container_image_version
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  target_port                 = var.container_target_port
  min_replicas                = var.container_min_replicas
  max_replicas                = var.container_max_replicas
  environment_variables       = var.container_environment_variables
  app_insights_connection_string = module.application_insights.connection_string
  acr_registry_server         = var.acr_registry_server
  acr_registry_username       = var.acr_registry_username
  acr_registry_password       = var.acr_registry_password
  tags                        = var.tags
  subnet_id                   = null
  enable_vnet_integration     = false
}

# Commented out until SPN permissions are manually assigned
# module "spn_roles" {
#   source                      = "./modules/spn_roles"
#   subscription_id             = var.subscription_id
#   service_principal_object_id = var.service_principal_object_id
#   resource_group_id           = module.resource_group.resource_group_id
# }
