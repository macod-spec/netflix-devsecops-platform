output "vnet_id" {
  description = "Virtual network ID."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Virtual network name."
  value       = azurerm_virtual_network.this.name
}

output "system_subnet_id" {
  description = "System subnet ID."
  value       = azurerm_subnet.system.id
}

output "app_subnet_id" {
  description = "App subnet ID."
  value       = azurerm_subnet.app.id
}

output "ingress_subnet_id" {
  description = "Ingress subnet ID."
  value       = azurerm_subnet.ingress.id
}

output "private_endpoint_subnet_id" {
  description = "Private endpoint subnet ID."
  value       = azurerm_subnet.private_endpoints.id
}
