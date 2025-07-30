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

variable "storage_account_name" {
  description = "Name of the storage account"
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
  description = "Enable VNet integration for Storage Account"
  type        = bool
  default     = false
} 