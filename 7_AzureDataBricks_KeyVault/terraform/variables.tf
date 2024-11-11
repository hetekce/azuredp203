# Variables for Main Account
variable "account_object_id" {
  description = "Main account object id"
  type      = string
  sensitive = true  # Hides the value in output and state file display
}

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
################################################################################
# 1. Resource Group for ASA
variable "resource_group_name" {
  description = "The resource group where the ASA instance will reside"
  type        = string
}

variable "location" {
  description = "The Azure region where the ASA instance will be created"
  type        = string
}

################################################################################
# 2. Storage for ASA
variable "asa_storage_name" {
  description = "The name of the storage account needed for Azure Synapse Analytics instance"
  type        = string
}

variable "std_tier" {
  description = "Storage account tier needed for Azure Synapse Analytics instance"
  type        = string
}

variable "lrs_replication" {
  description = "Storage account replication type needed for Azure Synapse Analytics instance"
  type        = string
}
