output "app_service_url" { value = azurerm_windows_web_app.this.default_hostname }

output "app_service_id" {
  description = "ID of the App Service"
  value       = azurerm_windows_web_app.this.id
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_windows_web_app.this.name
}

output "app_service_plan_id" {
  description = "ID of the App Service Plan"
  value       = azurerm_service_plan.this.id
}