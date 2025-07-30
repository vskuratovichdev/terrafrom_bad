output "user_access_admin_assignment_id" {
  description = "The ID of the User Access Administrator role assignment"
  value       = azurerm_role_assignment.spn_user_access_admin.id
}

output "contributor_assignment_id" {
  description = "The ID of the Contributor role assignment"
  value       = azurerm_role_assignment.spn_contributor.id
} 