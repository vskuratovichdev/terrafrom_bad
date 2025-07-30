resource "azurerm_static_web_app" "this" {
  name                = "${var.env_prefix}-sw-${var.company_name}-fe-01"
  resource_group_name = var.resource_group_name
  location            = var.static_web_app_location
  sku_tier            = var.static_web_app_sku

  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_connection_string
  }
  tags = var.tags
}
