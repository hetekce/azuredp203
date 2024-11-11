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
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

data "azurerm_client_config" "current" {}

# 1. Resource Group for ASA
resource "azurerm_resource_group" "asa1" {
  name     = var.resource_group_name
  location = var.location
}

# 2. Storage for ASA
resource "azurerm_storage_account" "asa1" {
  name                      = var.asa_storage_name
  resource_group_name       = azurerm_resource_group.asa1.name
  location                  = azurerm_resource_group.asa1.location
  account_tier              = var.std_tier
  account_replication_type  = var.lrs_replication
  account_kind             = "StorageV2"

  # Enable hierarchical namespace for Data Lake Storage Gen2
  is_hns_enabled            = true
}

# Create DFS in storage account
resource "azurerm_storage_data_lake_gen2_filesystem" "asa1" {
  name               = "storagedfs"
  storage_account_id = azurerm_storage_account.asa1.id
}

# 3. Azure Key Vault
resource "azurerm_key_vault" "adb1" {
  name                        = "dbricks-keyvault"
  location                    = azurerm_resource_group.asa1.location
  resource_group_name         = azurerm_resource_group.asa1.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"

  # Optional network rules for restricting access
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  # Optional soft delete and purge protection
  soft_delete_retention_days  = 90
  purge_protection_enabled = false

  # Access policy example for a specific user or application
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    
    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]
    
    key_permissions    = [
      "Get", "List", "Create", "Delete"
    ]
    
    storage_permissions = [
      "Get",
    ]
  }
}
