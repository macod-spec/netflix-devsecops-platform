output "monthly_budget_name" {
  description = "Name of the monthly resource group budget."
  value       = azurerm_consumption_budget_resource_group.monthly.name
}

output "monthly_budget_id" {
  description = "ID of the monthly resource group budget."
  value       = azurerm_consumption_budget_resource_group.monthly.id
}