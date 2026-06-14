output "resource_group_name" {
  description = "Dev resource group name."
  value       = module.resource_group.name
}

output "resource_group_location" {
  description = "Dev resource group location."
  value       = module.resource_group.location
}

output "resource_group_id" {
  description = "Dev resource group ID."
  value       = module.resource_group.id
}

