# Outputs of Azure Data Factory
output "data_factory_id" {
  description = "The ID of the Azure Data Factory instance"
  value       = azurerm_data_factory.adf1.id
}

output "data_factory_name" {
  description = "The name of the Azure Data Factory instance"
  value       = azurerm_data_factory.adf1.name
}

output "data_factory_location" {
  description = "The location of the Azure Data Factory instance"
  value       = azurerm_data_factory.adf1.location
}

output "data_factory_identity_principal_id" {
  description = "The Principal ID of the managed identity associated with the Data Factory"
  value       = azurerm_data_factory.adf1.identity[0].principal_id
}

output "data_factory_url" {
  description = "The URL of the Azure Data Factory instance in the Azure portal"
  value       = "https://portal.azure.com/#resource${azurerm_data_factory.adf1.id}"
}

output "data_factory_outputs" {
  description = "All Azure Data Factory outputs as a dictionary"
  value = {
    data_factory_id                  = azurerm_data_factory.adf1.id
    data_factory_name                = azurerm_data_factory.adf1.name
    data_factory_location            = azurerm_data_factory.adf1.location
    data_factory_identity_principal_id = azurerm_data_factory.adf1.identity[0].principal_id
    data_factory_url                 = "https://portal.azure.com/#resource${azurerm_data_factory.adf1.id}"
  }
}
