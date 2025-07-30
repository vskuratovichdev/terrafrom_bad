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

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "container_image" {
  description = "Container image name"
  type        = string
}

variable "container_image_version" {
  description = "Container image version"
  type        = string
}

variable "container_cpu" {
  description = "CPU allocation for container"
  type        = number
}

variable "container_memory" {
  description = "Memory allocation for container"
  type        = string
}

variable "target_port" {
  description = "Target port for the container"
  type        = number
}

variable "min_replicas" {
  description = "Minimum number of replicas"
  type        = number
}

variable "max_replicas" {
  description = "Maximum number of replicas"
  type        = number
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "app_insights_connection_string" {
  description = "Application Insights connection string"
  type        = string
}

variable "acr_registry_server" {
  description = "Azure Container Registry server"
  type        = string
  default     = null
}

variable "acr_registry_username" {
  description = "Azure Container Registry username"
  type        = string
  default     = null
}

variable "acr_registry_password" {
  description = "Azure Container Registry password"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "subnet_id" {
  description = "ID of the subnet for VNet integration"
  type        = string
  default     = null
}

variable "enable_vnet_integration" {
  description = "Enable VNet integration for Container App Environment"
  type        = bool
  default     = false
} 