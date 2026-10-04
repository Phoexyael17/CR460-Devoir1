terraform {
  cloud {
    organization = "CR460-Rubeni-PolyMTL"

    workspaces {
      name = "CR460-Devoir1"
    }
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Q7

resource "azurerm_resource_group" "rg" {
  name     = "gr-ressource-cr460-devoir1"
  location = "eastus"
}

# Q8

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-cr460-devoir1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}