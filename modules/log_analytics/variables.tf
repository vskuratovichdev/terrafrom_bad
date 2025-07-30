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

variable "log_analytics_workspace_sku" {
  description = "Log Analytics workspace SKU"
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