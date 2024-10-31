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

# Creation of resource group for ADF
resource "azurerm_resource_group" "adf_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Creation of ADF
resource "azurerm_data_factory" "adf1" {
  name                = var.adf_name
  location            = var.location
  resource_group_name = azurerm_resource_group.adf_rg.name

  identity {
    type = "SystemAssigned"
  }

  public_network_enabled = true  # Set to false if ADF should be in private network
}

# Local Variables
# locals {
#   extra_tag = "extra-tag"
# }
