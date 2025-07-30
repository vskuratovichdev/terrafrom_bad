terraform {
  backend "azurerm" {
    resource_group_name  = "noteserve-terraform-state-rg-01"
    storage_account_name = "noteserveterraformstate"
    container_name       = "tfstate"
    key                  = "test.terraform.tfstate"
  }
}
