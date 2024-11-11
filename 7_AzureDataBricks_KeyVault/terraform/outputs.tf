# Outputs of Databricks, Storage account and Key Vault

output "storage_account_name" {
  value = azurerm_storage_account.asa1.name
}

output "ad_all_outputs" {
  description = "All Azure Databricks outputs as a dictionary"
  value = {
    storage_account_name  = azurerm_storage_account.asa1.name
  }
}
