# Outputs of ASA

output "synapse_workspace_id" {
  value = azurerm_synapse_workspace.asa1.id
}

output "storage_account_name" {
  value = azurerm_storage_account.asa1.name
}

# output "synapse_sql_pool_name" {
#   value = azurerm_synapse_sql_pool.asa1.name
# }

output "asa_all_outputs" {
  description = "All Azure Synapse Analytics outputs as a dictionary"
  value = {
    synapse_workspace_id  = azurerm_synapse_workspace.asa1.id
    storage_account_name  = azurerm_storage_account.asa1.name
    # synapse_sql_pool_name = azurerm_synapse_sql_pool.asa1.name
  }
}
