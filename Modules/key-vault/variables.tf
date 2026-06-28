variable "key_vault_name" {
  description = "Name of the Azure Key Vault."
  type        = string
}

variable "location" {
  description = "Azure region for the Key Vault."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where Key Vault and identity resources are created."
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU name."
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain deleted Key Vault objects."
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled for Key Vault."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the dev Key Vault."
  type        = bool
  default     = true
}

variable "fastapi_identity_name" {
  description = "Name of the user-assigned managed identity used by the FastAPI workload."
  type        = string
}

variable "fastapi_federated_credential_name" {
  description = "Name of the federated identity credential for AKS workload identity."
  type        = string
  default     = "fic-netflix-api-dev"
}

variable "aks_oidc_issuer_url" {
  description = "OIDC issuer URL from AKS used for workload identity federation."
  type        = string
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace containing the FastAPI workload."
  type        = string
  default     = "netflix-dev"
}

variable "kubernetes_service_account_name" {
  description = "Kubernetes service account name used by the FastAPI workload."
  type        = string
  default     = "netflix-api"
}

variable "tmdb_secret_name" {
  description = "Name of the TMDB API key secret expected to exist in Azure Key Vault."
  type        = string
  default     = "tmdb-api-key"
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}