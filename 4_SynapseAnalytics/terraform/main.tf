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

# Create DFS
resource "azurerm_storage_data_lake_gen2_filesystem" "asa1" {
  name               = "storagedfs"
  storage_account_id = azurerm_storage_account.asa1.id
}

# 3. Azure Synapse Analytics(ASA) Workspace
resource "azurerm_synapse_workspace" "asa1" {
  name                                 = var.asa_ws_name
  resource_group_name                  = azurerm_resource_group.asa1.name
  location                             = azurerm_resource_group.asa1.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.asa1.id
  sql_administrator_login              = var.asa_sql_admin_user
  sql_administrator_login_password     = var.asa_sql_admin_pw
  identity {
    type = "SystemAssigned"
  }
  tags = {
    Env = "development"
  }
}

# Adding firewall rule to ASA
resource "azurerm_synapse_firewall_rule" "asa1" {
  name                 = "AllowAll"
  synapse_workspace_id = azurerm_synapse_workspace.asa1.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "255.255.255.255"
}

# # Role assignments for access roles to Storage Account  (admin account needed)
# resource "azurerm_role_assignment" "role1" {
#   scope                = azurerm_storage_account.asa1.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = azurerm_synapse_workspace.asa1.identity[0].principal_id
# }

# resource "azurerm_role_assignment" "role2" {
#   scope                = azurerm_storage_account.asa1.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = var.account_object_id
# }

# 4. Azure Synapse Analytics(ASA) SQL Pool, 1,57 USD/Hour
# resource "azurerm_synapse_sql_pool" "asa1" {
#   name                      = var.asa_sql_pool_name
#   storage_account_type      = azurerm_storage_account.asa1.account_replication_type
#   sku_name                  = "DW100c"
#   synapse_workspace_id      = azurerm_synapse_workspace.asa1.id  
#   geo_backup_policy_enabled = false # must set to false if storage account type is LRS
# }

resource "azurerm_synapse_role_assignment" "asa1" {
  synapse_workspace_id = azurerm_synapse_workspace.asa1.id
  role_name            = "Synapse Administrator"
  principal_id         = var.account_object_id

  depends_on = [azurerm_synapse_firewall_rule.asa1]
}