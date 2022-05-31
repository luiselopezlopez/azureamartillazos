terraform {
  backend "azurerm" {
    resource_group_name  = "neu-rg-terraformstates"
    storage_account_name = "neustterraformstates"
    container_name       = "states"
    key                  = "azmhub.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

#Create Resource Group
resource "azurerm_resource_group" "rg-neu-networking" {
  name     = "rg-neu-networking"
  location = "northeurope"
}

resource "azurerm_resource_group" "RG-NEU-FIREWALL" {
  name     = "RG-NEU-FIREWALL"
  location = "northeurope"
}

#Create Virtual Network
resource "azurerm_virtual_network" "vnet-neu-hub" {
  name                = "vnet-neu-hub"
  address_space       = ["172.16.0.0/16"]
  location            = azurerm_resource_group.rg-neu-networking.location
  resource_group_name = azurerm_resource_group.rg-neu-networking.name
}

# Create Subnet
resource "azurerm_subnet" "subnetfw" {
  name                 = "snet-neu-azfirewall"
  resource_group_name  = azurerm_resource_group.rg-neu-networking.name
  virtual_network_name = azurerm_virtual_network.vnet-neu-hub.name
  address_prefixes     = ["172.16.0.0/24"]
}

# Create Subnet
resource "azurerm_subnet" "subnetAAD" {
  name                 = "snet-neu-AAD"
  resource_group_name  = azurerm_resource_group.rg-neu-networking.name
  virtual_network_name = azurerm_virtual_network.vnet-neu-hub.name
  address_prefixes     = ["172.16.1.0/24"]
}