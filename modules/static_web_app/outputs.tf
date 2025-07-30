output "static_web_app_url" {
  value = azurerm_static_web_app.this.default_host_name
}