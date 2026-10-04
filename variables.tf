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
