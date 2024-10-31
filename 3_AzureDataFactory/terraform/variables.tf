# Variables for Service Principle
variable "client_id" {
  description = "Service principle app id"
  type      = string
  sensitive = true  # Hides the value in output and state file display
}

variable "client_secret" {
  description = "Service principle app password"
  type      = string
  sensitive = true  # Hides the value in output and state file display
}

variable "tenant_id" {
  description = "Service principle tenant id"
  type      = string
  sensitive = true  # Hides the value in output and state file display
}

variable "subscription_id" {
  description = "The subscription ID for Azure"
  type      = string
  sensitive = true  # Hides the value in output and state file display
}

# variables for azure data factory
variable "adf_name" {
  description = "The name of the Azure Data Factory instance"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group where the ADF instance will reside"
  type        = string
}

variable "location" {
  description = "The Azure region where the ADF instance will be created"
  type        = string
}


# Defining secrets in azure key vault
# data "azurerm_key_vault_secret" "example" {
#   name         = "secret-key"
#   key_vault_id = azurerm_key_vault.example.id
# }

# variable "secret_key" {
#   type      = string
#   sensitive = true
#   default   = data.azurerm_key_vault_secret.example.value
# }

# variable "db_user" {
#   description = "username for database"
#   type        = string
#   default     = "foo"
# }

# variable "db_pass" {
#   description = "password for database"
#   type        = string
#   sensitive   = true
# }
