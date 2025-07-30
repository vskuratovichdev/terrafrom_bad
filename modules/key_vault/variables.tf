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

variable "key_vault_sku" {
  description = "SKU for Key Vault"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
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
  description = "ID of the subnet for VNet integration"
  type        = string
  default     = null
}

variable "enable_vnet_integration" {
  description = "Enable VNet integration for Key Vault"
  type        = bool
  default     = false
} 