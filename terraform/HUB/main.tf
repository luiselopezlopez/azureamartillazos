terraform {
  backend "azurerm" {
    resource_group_name  = "neu-rg-terraformstates"
    storage_account_name = "neustterraformstates"
    container_name       = "hub"
    key                  = "azmhub.tfstate"
  }
}
 
provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
}
 
data "azurerm_client_config" "current" {}
 
#Create Resource Group
resource "azurerm_resource_group" "rg-neu-networking" {
  name     = "rg-neu-networking"
  location = "northeurope"
}
 
#Create Virtual Network
resource "azurerm_virtual_network" "vnet-neu-hub" {
  name                = "vnet-neu-hub"
  address_space       = ["172.16.0.0/16"]
  location            = "northeurope"
  resource_group_name = azurerm_resource_group.rg-neu-networking.name
}
 
# Create Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "snet-neu-azfirewall"
  resource_group_name  = azurerm_resource_group.rg-neu-networking.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "192.168.0.0/24"
}