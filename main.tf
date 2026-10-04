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

resource "azurerm_resource_group" "rg" {
  name     = "gr-ressource-cr460-devoir1"
  location = "eastus"
}