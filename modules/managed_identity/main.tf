resource "azurerm_user_assigned_identity" "this" {
  name                = "${var.env_prefix}-${var.company_name}-mi-01"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# Contributor role for SQL Server
resource "azurerm_role_assignment" "sql_contributor" {
  scope                = var.sql_server_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}

# Key Vault Reader role
resource "azurerm_role_assignment" "key_vault_reader" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Reader"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}

# Key Vault Crypto User role
resource "azurerm_role_assignment" "key_vault_crypto_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}

# Key Vault Secrets User role
resource "azurerm_role_assignment" "key_vault_secrets_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
} 