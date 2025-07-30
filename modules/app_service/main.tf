resource "azurerm_service_plan" "this" {
  name                = "${var.env_prefix}${var.company_name}asp01"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.app_service_plan_sku
  os_type             = "Windows"
  tags                = var.tags
}

resource "azurerm_windows_web_app" "this" {
  name                = "${var.env_prefix}${var.company_name}-api-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id
  app_settings = {
    "APPINSIGHTS_CONNECTION_STRING" = var.app_insights_connection_string
  }
  
  site_config {
    # Network access restrictions - only add if subnet_id is provided
    dynamic "ip_restriction" {
      for_each = var.subnet_id != null ? [1] : []
      content {
        action                    = "Allow"
        virtual_network_subnet_id = var.subnet_id
        name                      = "App Subnet Access"
        priority                  = 100
      }
    }
    
    # Allow access from DB and Build subnets
    dynamic "ip_restriction" {
      for_each = var.allowed_subnet_ids
      content {
        action                    = "Allow"
        virtual_network_subnet_id = ip_restriction.value
        name                      = "Subnet Access ${index(var.allowed_subnet_ids, ip_restriction.value) + 1}"
        priority                  = 200 + index(var.allowed_subnet_ids, ip_restriction.value)
      }
    }
    
    # Set unmatched rule action to Deny
    ip_restriction_default_action = "Deny"
  }
  
  tags = var.tags
  
  # Network access configuration - enable public access
  public_network_access_enabled = true
}

# VNet Integration for App Service
resource "azurerm_app_service_virtual_network_swift_connection" "this" {
  app_service_id = azurerm_windows_web_app.this.id
  subnet_id      = var.subnet_id
}
