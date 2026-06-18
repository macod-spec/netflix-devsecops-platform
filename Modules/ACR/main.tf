resource "azurerm_container_registry" "this" {
  #checkov:skip=CKV_AZURE_237:Dedicated data endpoints require higher-cost ACR configuration; accepted for dev portfolio environment. Production roadmap item.
  #checkov:skip=CKV_AZURE_233:Zone redundant ACR requires premium production-grade registry; not used in cost-controlled dev environment.
  #checkov:skip=CKV_AZURE_167:ACR retention policy is planned as a future optimisation; current image lifecycle is controlled through versioned tags.
  #checkov:skip=CKV_AZURE_164:Trusted image signing is a future enhancement; current pipeline uses Trivy scanning before deployment.
  #checkov:skip=CKV_AZURE_165:Geo-replication is not required for a single-region dev platform; production multi-region design would enable it.
  #checkov:skip=CKV_AZURE_166:ACR quarantine and verified image promotion are production controls; current dev pipeline uses CI security gates.
  #checkov:skip=CKV_AZURE_163:Image vulnerability scanning is handled in GitHub Actions with Trivy; Defender for Containers is a future enhancement.
  #checkov:skip=CKV_AZURE_139:Private ACR networking is a future enhancement; public access is currently required for a low-cost dev setup.

  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = false
  tags                = var.tags
}