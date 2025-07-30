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
  default     = "westus2"
}

variable "static_web_app_sku" {
  description = "Static Web App SKU"
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

variable "static_web_app_location" {
  description = "Azure region for Static Web App (defaults to westus2 for compatibility)"
  type        = string
  default     = "westus2"
} 