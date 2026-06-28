output "key_vault_id" {
  description = "Azure Key Vault resource ID."
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "Azure Key Vault name."
  value       = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  description = "Azure Key Vault URI."
  value       = azurerm_key_vault.this.vault_uri
}

output "fastapi_identity_id" {
  description = "User-assigned managed identity ID for the FastAPI workload."
  value       = azurerm_user_assigned_identity.fastapi.id
}

output "fastapi_identity_client_id" {
  description = "Client ID of the FastAPI user-assigned managed identity."
  value       = azurerm_user_assigned_identity.fastapi.client_id
}

output "fastapi_identity_principal_id" {
  description = "Principal ID of the FastAPI user-assigned managed identity."
  value       = azurerm_user_assigned_identity.fastapi.principal_id
}

output "tenant_id" {
  description = "Azure tenant ID used by Key Vault and workload identity."
  value       = data.azurerm_client_config.current.tenant_id
}

output "tmdb_secret_name" {
  description = "Name of the TMDB API key secret expected in Azure Key Vault."
  value       = var.tmdb_secret_name
}
