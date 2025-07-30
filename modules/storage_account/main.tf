resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# Network rules for Storage Account VNet integration
resource "azurerm_storage_account_network_rules" "this" {
  count = var.enable_vnet_integration ? 1 : 0
  
  storage_account_id = azurerm_storage_account.this.id
  
  default_action             = "Deny"
  bypass                     = ["AzureServices"]
  virtual_network_subnet_ids = var.subnet_id != null ? [var.subnet_id] : []
}
