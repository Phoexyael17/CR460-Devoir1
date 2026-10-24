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

# Q7 - Modifié
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Q8 - Modifié

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Q8 - Subnet pour la VM - Modifié
resource "azurerm_subnet" "vm_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Q8 - Interface réseau de la VM - Modifié
resource "azurerm_network_interface" "vm_nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Q9 - Machine virtuelle Linux - Modifié
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = var.vm_size

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

# Q10 - Azure Docker Container - Modifié
resource "azurerm_container_group" "docker_container" {
  name                = var.container_group_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  os_type         = "Linux"
  ip_address_type = "Public"
  restart_policy  = "Always"
  sku             = "Standard"

  container {
    name   = "aci-helloworld"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld"
    cpu    = 1
    memory = 1

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}

# Q12 - Identite utilisee par Terraform
data "azurerm_client_config" "current" {}

# Q12 - Azure Key Vault
resource "azurerm_key_vault" "cr460_kv" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = "standard"

  rbac_authorization_enabled = false

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  public_network_access_enabled = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
    ]
  }
}

# Q12 - Secret stocke dans Azure Key Vault
resource "azurerm_key_vault_secret" "q12_secret" {
  name         = var.key_vault_secret_name
  value        = var.q12_secret_value
  key_vault_id = azurerm_key_vault.cr460_kv.id
}

# Q12 - Referencement du secret depuis Azure Key Vault
data "azurerm_key_vault_secret" "q12_secret_reference" {
  name         = azurerm_key_vault_secret.q12_secret.name
  key_vault_id = azurerm_key_vault.cr460_kv.id

  depends_on = [
    azurerm_key_vault_secret.q12_secret
  ]
}

output "key_vault_name" {
  value = azurerm_key_vault.cr460_kv.name
}

output "key_vault_secret_reference" {
  value = data.azurerm_key_vault_secret.q12_secret_reference.versionless_id
}