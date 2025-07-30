resource "azurerm_resource_group" "this" {
  name     = "${var.env_prefix}-sw-${var.company_name}-rg-01"
  location = var.location
  tags     = var.tags
} 