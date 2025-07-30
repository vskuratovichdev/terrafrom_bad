output "vnet_name" { value = module.vnet.vnet_name }
output "app_subnet_name" { value = module.subnet_app.subnet_name }
output "db_subnet_name" { value = module.subnet_db.subnet_name }
output "build_subnet_name" { value = module.subnet_build.subnet_name }
output "storage_account_name" { value = module.storage_account.storage_account_name }
output "backend_url" { value = module.backend.app_service_url }
output "key_vault_name" { value = module.key_vault.key_vault_name }
output "log_analytics_workspace_id" { value = module.log_analytics.workspace_id }
output "app_insights_connection_string" { 
  value     = module.application_insights.connection_string
  sensitive = true
}
output "frontend_url" { value = module.frontend.static_web_app_url }
output "reporting_app_url" { value = module.reporting_app.container_app_url }
output "reporting_app_fqdn" { value = module.reporting_app.container_app_fqdn }
