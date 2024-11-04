terraform {
  # backend "azurerm" {
  #   resource_group_name   = "your-resource-group"
  #   storage_account_name  = "yourstorageaccount"    # Storage account name (must be globally unique)
  #   container_name        = "terraform-state"       # Container name created in the storage account
  #   key                   = "04_variables_and_outputs/examples/terraform.tfstate"     # The path within the container where the state is stored
  # }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.7.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

# Creation of resource group for ASA
resource "azurerm_resource_group" "asa1" {
  name     = var.resource_group_name
  location = var.location
}

# Synapse requires a storage account to store data.
resource "azurerm_storage_account" "asa1" {
  name                     = var.asa_storage_name
  resource_group_name      = azurerm_resource_group.asa1.name
  location                 = azurerm_resource_group.asa1.location
  account_tier             = var.std_tier
  account_replication_type = var.lrs_replication
}

# Creation of ASA
resource "azurerm_synapse_workspace" "asa1" {
  name                                 = var.asa_ws_name
  resource_group_name                  = azurerm_resource_group.asa1.name
  location                             = azurerm_resource_group.asa1.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_account.asa1.primary_blob_endpoint
  sql_administrator_login              = var.asa_sql_admin_user
  sql_administrator_login_password     = var.asa_sql_admin_pw
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_synapse_sql_pool" "asa1" {
  name                  = var.asa_sql_pool_name
  storage_account_type  = azurerm_storage_account.asa1.account_replication_type
  sku_name              = "DW100c"
  synapse_workspace_id  = azurerm_synapse_workspace.asa1.id  
}


# Local Variables
# locals {
#   extra_tag = "extra-tag"
# }
