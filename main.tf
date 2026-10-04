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
  location = "eastus2"
}

# Q8

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-cr460-devoir1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Q8 - Subnet pour la VM
resource "azurerm_subnet" "vm_subnet" {
  name                 = "snet-vm-cr460-devoir1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Q8 - Interface réseau de la VM
resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-vm-cr460-devoir1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Q9 - Machine virtuelle Linux
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-cr460-devoir1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"

  admin_username                  = "cr460admin"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id
  ]

  admin_ssh_key {
    username   = "cr460admin"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 32
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
