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

output "key_vault_name" {
  description = "Dev Key Vault name."
  value       = module.key_vault.key_vault_name
}

output "key_vault_uri" {
  description = "Dev Key Vault URI."
  value       = module.key_vault.key_vault_uri
}

output "fastapi_identity_client_id" {
  description = "FastAPI workload identity client ID used by Helm."
  value       = module.key_vault.fastapi_identity_client_id
}

output "fastapi_identity_principal_id" {
  description = "FastAPI workload identity principal ID."
  value       = module.key_vault.fastapi_identity_principal_id
}

output "tenant_id" {
  description = "Azure tenant ID used by workload identity."
  value       = module.key_vault.tenant_id
}

output "tmdb_secret_name" {
  description = "Name of the TMDB secret expected in Key Vault."
  value       = module.key_vault.tmdb_secret_name
}