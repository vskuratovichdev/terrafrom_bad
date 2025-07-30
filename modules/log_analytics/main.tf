resource "azurerm_log_analytics_workspace" "this" {
  name                = "${var.env_prefix}-${var.company_name}-law-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_workspace_sku
  tags                = var.tags
}
