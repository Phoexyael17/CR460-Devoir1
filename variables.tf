variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "tenant_id" {
  type = string
}

variable "ssh_public_key" {
  type        = string
  description = "Cle SSH publique pour VM Azure"
}

# Q11 - Parametrisation du deploiement

variable "location" {
  type        = string
  description = "Region Azure utilisee pour le deploiement"
  default     = "eastus2"
}

variable "resource_group_name" {
  type        = string
  description = "Nom du groupe de ressources Azure"
  default     = "gr-ressource-cr460-devoir1"
}

variable "vnet_name" {
  type        = string
  description = "Nom du reseau virtuel Azure"
  default     = "vnet-cr460-devoir1"
}

variable "subnet_name" {
  type        = string
  description = "Nom du sous-reseau utilise par la VM"
  default     = "snet-vm-cr460-devoir1"
}

variable "nic_name" {
  type        = string
  description = "Nom de l'interface reseau de la VM"
  default     = "nic-vm-cr460-devoir1"
}

variable "vm_name" {
  type        = string
  description = "Nom de la machine virtuelle Azure"
  default     = "vm-cr460-devoir1"
}

variable "vm_size" {
  type        = string
  description = "Taille de la machine virtuelle Azure"
  default     = "Standard_B1s"
}

variable "container_group_name" {
  type        = string
  description = "Nom du groupe de conteneurs Azure"
  default     = "docker-cr460-devoir1"
}