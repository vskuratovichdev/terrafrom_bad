output "container_app_environment_id" {
  description = "The ID of the Container App Environment"
  value       = azurerm_container_app_environment.container_app_env.id
}

output "container_app_environment_name" {
  description = "The name of the Container App Environment"
  value       = azurerm_container_app_environment.container_app_env.name
}

output "container_app_id" {
  description = "The ID of the Container App"
  value       = azurerm_container_app.reporting_app.id
}

output "container_app_name" {
  description = "The name of the Container App"
  value       = azurerm_container_app.reporting_app.name
}

output "container_app_url" {
  description = "The URL of the Container App"
  value       = azurerm_container_app.reporting_app.latest_revision_fqdn
}

output "container_app_fqdn" {
  description = "The FQDN of the Container App"
  value       = azurerm_container_app.reporting_app.latest_revision_fqdn
} 