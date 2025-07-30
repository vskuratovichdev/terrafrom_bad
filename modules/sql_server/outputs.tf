output "sql_server_id" {
  description = "The ID of the SQL Server"
  value       = azurerm_mssql_server.this.id
}

output "sql_server_name" {
  description = "The name of the SQL Server"
  value       = azurerm_mssql_server.this.name
}

output "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "database_id" {
  description = "The ID of the database"
  value       = azurerm_mssql_database.this.id
}

output "database_name" {
  description = "The name of the database"
  value       = azurerm_mssql_database.this.name
}

output "connection_string" {
  description = "The connection string for the database"
  value       = "Server=tcp:${azurerm_mssql_server.this.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.this.name};Persist Security Info=False;User ID=${var.admin_username};Password=${var.admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = true
} 