resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.address_prefixes
  
  # Service endpoints for Key Vault, Storage, and Web
  service_endpoints = var.enable_service_endpoints ? [
    "Microsoft.KeyVault",
    "Microsoft.Storage",
    "Microsoft.Web"
  ] : []
  
  # Delegation for App Service
  dynamic "delegation" {
    for_each = var.enable_delegation ? [1] : []
    content {
      name = "app-service-delegation"
      service_delegation {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  count          = var.enable_nat_gateway ? 1 : 0
  subnet_id      = azurerm_subnet.this.id
  nat_gateway_id = var.nat_gateway_id
}
