variable "env_prefix" { type = string }
variable "company_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }
variable "vnet_address_space" { type = list(string) }
variable "app_subnet_prefix" { type = string }
variable "db_subnet_prefix" { type = string }
variable "build_subnet_prefix" { type = string }
variable "vnet_integration_subnet_prefix" { type = string }
variable "key_vault_name_suffix" { type = string }
variable "storage_account_name" { type = string }
variable "app_service_plan_sku" { type = string }
variable "key_vault_sku" { type = string }
variable "log_analytics_workspace_sku" { type = string }
variable "static_web_app_sku" { type = string }
variable "tenant_id" { type = string }
variable "app_insights_type" { type = string }

# SQL Server variables
variable "sql_admin_username" { 
  type = string
  description = "Administrator username for SQL Server"
}

variable "sql_admin_password" { 
  type = string
  description = "Administrator password for SQL Server"
  sensitive = true
}

variable "sql_database_name" { 
  type = string
  description = "Name of the database"
  default = "noteserve_db"
}

variable "sql_sku_name" { 
  type = string
  description = "SKU name for the database (e.g., S2, S3, P1, etc.)"
  default = "S2"
}

variable "sql_max_size_gb" { 
  type = number
  description = "Maximum size of the database in GB"
  default = 2
}

# Service Principal variables for role assignments
variable "subscription_id" { 
  type = string
  description = "The Azure subscription ID"
}

variable "service_principal_object_id" { 
  type = string
  description = "The Object ID of the Service Principal"
}

# Container App variables
variable "container_image" {
  type        = string
  description = "Container image to deploy for the reporting app"
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "container_image_version" {
  type        = string
  description = "Version tag for the container image"
  default     = "latest"
}

variable "container_cpu" {
  type        = number
  description = "CPU allocation for container"
  default     = 0.5
}

variable "container_memory" {
  type        = string
  description = "Memory allocation for container"
  default     = "1Gi"
}

variable "container_target_port" {
  type        = number
  description = "Target port for the container app"
  default     = 80
}

variable "container_min_replicas" {
  type        = number
  description = "Minimum number of replicas for container app"
  default     = 0
}

variable "container_max_replicas" {
  type        = number
  description = "Maximum number of replicas for container app"
  default     = 3
}

variable "container_environment_variables" {
  type        = map(string)
  description = "Additional environment variables for the container app"
  default     = {}
}

# ACR variables for container app
variable "acr_registry_server" {
  type        = string
  description = "Azure Container Registry server URL"
  default     = ""
}

variable "acr_registry_username" {
  type        = string
  description = "Azure Container Registry username"
  default     = ""
}

variable "acr_registry_password" {
  type        = string
  description = "Azure Container Registry password"
  sensitive   = true
  default     = "tAnR1J4XPtfj-jH+>+bwZ@Q:}@_76QA7H.nuj%=xQYXBsQ=xBU0kLC4PoPH"
}
