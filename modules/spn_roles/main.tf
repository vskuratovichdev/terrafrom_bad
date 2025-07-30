# Grant User Access Administrator role to the Service Principal at subscription level
# This allows the SPN to assign roles to resources
resource "azurerm_role_assignment" "spn_user_access_admin" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "User Access Administrator"
  principal_id         = var.service_principal_object_id
}

# Grant Contributor role to the Service Principal at resource group level
# This allows the SPN to manage resources in the resource group
resource "azurerm_role_assignment" "spn_contributor" {
  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = var.service_principal_object_id
} 