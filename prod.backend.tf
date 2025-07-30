terraform {
  backend "azurerm" {
    resource_group_name  = "prd-sw-noteserve-terraform-state-rg-01"
    storage_account_name = "prdnoteservetfstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
