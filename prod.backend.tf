terraform {
  backend "azurerm" {
    resource_group_name  = "prd-terraform-state-rg-01"
    storage_account_name = "prdfstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
