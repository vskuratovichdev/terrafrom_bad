variable "env_prefix" {
  description = "Environment prefix for resource naming"
  type        = string
}

variable "company_name" {
  description = "Company name for resource naming"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "app_service_plan_sku" {
  description = "SKU size for the App Service Plan"
  type        = string
}

variable "app_insights_connection_string" {
  description = "Application Insights connection string"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for network access control"
  type        = string
  default     = null
}

variable "allowed_subnet_ids" {
  description = "List of subnet IDs allowed to access the App Service"
  type        = list(string)
  default     = []
}

variable "enable_public_network_access" {
  description = "Enable public network access for the App Service"
  type        = bool
  default     = true
} 