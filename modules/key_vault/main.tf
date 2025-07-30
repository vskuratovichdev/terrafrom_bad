resource "azurerm_key_vault" "this" {
  name                        = "${var.env_prefix}${var.company_name}kv"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = var.key_vault_sku
  tags                        = var.tags
  
  # Network rules for VNet integration
  network_acls {
    default_action = var.enable_vnet_integration ? "Deny" : "Allow"
    bypass         = "AzureServices"
    
    # Allow access from the specified subnet
    virtual_network_subnet_ids = var.enable_vnet_integration && var.subnet_id != null ? [var.subnet_id] : []
  }
}
