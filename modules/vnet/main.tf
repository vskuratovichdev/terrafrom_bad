resource "azurerm_virtual_network" "this" {
  name                = "${var.env_prefix}-${var.company_name}-vnet-network-01"
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
