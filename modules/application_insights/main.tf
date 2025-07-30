resource "azurerm_application_insights" "this" {
  name                = "${var.env_prefix}-${var.company_name}-appinsights-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = var.workspace_id
  application_type    = var.app_insights_type
  tags                = var.tags
}
