data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  # checkov:skip=CKV_AZURE_110:Public network access is temporarily allowed for this dev portfolio environment; private endpoint integration is a future production enhancement.
  # checkov:skip=CKV_AZURE_189:Purge protection is disabled for low-cost dev rebuild flexibility; production should enable purge protection.

  name                          = var.key_vault_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = var.sku_name
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  enable_rbac_authorization     = true
  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
}

resource "azurerm_user_assigned_identity" "fastapi" {
  name                = var.fastapi_identity_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_federated_identity_credential" "fastapi" {
  name                = var.fastapi_federated_credential_name
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.fastapi.id
  issuer              = var.aks_oidc_issuer_url
  audience            = ["api://AzureADTokenExchange"]
  subject             = "system:serviceaccount:${var.kubernetes_namespace}:${var.kubernetes_service_account_name}"
}

resource "azurerm_role_assignment" "fastapi_key_vault_secrets_user" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.fastapi.principal_id
}