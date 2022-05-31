terraform {
  backend "azurerm" {
    resource_group_name  = "neu-rg-terraformstates"
    storage_account_name = "neustterraformstates"
    container_name       = "states"
    key                  = "azmpolicies.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_management_group" "root" {
  #name="b267e754-ae0a-4daa-b217-c857813bf721"
  display_name = "Tenant Root Group"
}
