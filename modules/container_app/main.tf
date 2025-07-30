# Container App Environment
resource "azurerm_container_app_environment" "container_app_env" {
  name                       = "${var.env_prefix}${var.company_name}env01"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tags                       = var.tags
  
  # VNet integration for Container App Environment
  infrastructure_subnet_id = var.enable_vnet_integration && var.subnet_id != null ? var.subnet_id : null
}

# Container App for Reporting Application
resource "azurerm_container_app" "reporting_app" {
  name                         = "${var.env_prefix}${var.company_name}reporting01"
  container_app_environment_id = azurerm_container_app_environment.container_app_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"



  template {
    container {
      name   = "reporting-app"
      image  = "${var.container_image}:${var.container_image_version}"
      cpu    = var.container_cpu
      memory = var.container_memory

      env {
        name  = "APP_INSIGHTS_CONNECTION_STRING"
        value = var.app_insights_connection_string
      }

      env {
        name  = "ENVIRONMENT"
        value = var.env_prefix
      }

      # Add more environment variables as needed
      dynamic "env" {
        for_each = var.environment_variables
        content {
          name  = env.key
          value = env.value
        }
      }
    }

    min_replicas = var.min_replicas
    max_replicas = var.max_replicas
  }

  ingress {
    allow_insecure_connections = false
    external_enabled          = true
    target_port               = var.target_port
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = var.tags
}

 