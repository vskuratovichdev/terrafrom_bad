variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "env_prefix" {
  description = "Environment prefix for resource naming"
  type        = string
}

variable "company_name" {
  description = "Company name for resource naming"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "nat_gateway_id" {
  description = "The ID of the NAT Gateway to associate with this subnet"
  type        = string
  default     = null
}

variable "enable_nat_gateway" {
  description = "Whether to enable NAT Gateway association for this subnet"
  type        = bool
  default     = false
} 

variable "enable_service_endpoints" {
  description = "Enable service endpoints for Key Vault and Storage"
  type        = bool
  default     = false
}

variable "enable_delegation" {
  description = "Enable delegation for App Service"
  type        = bool
  default     = false
} 