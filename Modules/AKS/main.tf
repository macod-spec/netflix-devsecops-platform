resource "azurerm_kubernetes_cluster" "this" {
  #checkov:skip=CKV_AZURE_170:Paid AKS SLA is not used in this cost-controlled dev portfolio environment.
  #checkov:skip=CKV_AZURE_172:Secrets Store CSI Driver autorotation is a future Key Vault integration enhancement.
  #checkov:skip=CKV_AZURE_141:Local admin account hardening is planned with full Entra ID/RBAC integration in a later phase.
  #checkov:skip=CKV_AZURE_115:Private AKS cluster is a future production architecture enhancement; public API access is used for dev manageability.
  #checkov:skip=CKV_AZURE_117:Customer-managed disk encryption set is a production hardening item; current dev environment uses platform-managed encryption.
  #checkov:skip=CKV_AZURE_7:AKS network policy requires additional cluster networking design; planned for a later hardening phase.
  #checkov:skip=CKV_AZURE_232:Dedicated user node pools are a future scalability enhancement; this dev cluster currently uses a single small node pool.
  #checkov:skip=CKV_AZURE_226:Ephemeral OS disks depend on node SKU and sizing; accepted for current low-cost ARM dev node.
  #checkov:skip=CKV_AZURE_116:Azure Policy add-on is a future governance enhancement; current governance uses Terraform and Checkov.
  #checkov:skip=CKV_AZURE_6:API server authorized IP ranges are not enabled due to changing admin/GitHub access paths in the dev setup.
  #checkov:skip=CKV_AZURE_171:Automatic upgrade channel is not enabled to avoid unexpected version drift during portfolio build.
  #checkov:skip=CKV_AZURE_168:Current max pods setting is accepted for a small single-node dev cluster.
  #checkov:skip=CKV_AZURE_227:Host-based encryption for temporary disks/caches is a future production hardening item.

  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name           = "system"
    node_count     = var.system_node_count
    vm_size        = var.system_node_vm_size
    vnet_subnet_id = var.system_subnet_id

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = "10.100.0.0/16"
    dns_service_ip    = "10.100.0.10"
  }

  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_id != null && var.log_analytics_workspace_id != "" ? [1] : []

    content {
      log_analytics_workspace_id      = var.log_analytics_workspace_id
      msi_auth_for_monitoring_enabled = true
    }
  }

  role_based_access_control_enabled = true

  tags = var.tags
}