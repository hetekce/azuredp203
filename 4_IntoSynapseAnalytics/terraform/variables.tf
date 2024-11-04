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

################################################################################
# 3. Azure Synapse Analytics(ASA) Workspace
variable "asa_ws_name" {
  description = "The workspace name of the Azure Synapse Analytics instance"
  type        = string
}

variable "asa_sql_admin_user" {
  description = "ASA sql admin username"
  type      = string
  sensitive = true  # Hides the value in output and state file display
}

variable "asa_sql_admin_pw" {
  description = "ASA sql admin password"
  type      = string
  sensitive = true  # Hides the value in output and state file display
}

################################################################################
# 4. Azure Synapse Analytics(ASA) SQL Pool
variable "asa_sql_pool_name" {
  description = "SQL Pool name of the Azure Synapse Analytics instance"
  type        = string
}