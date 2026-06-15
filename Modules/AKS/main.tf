resource "azurerm_kubernetes_cluster" "this" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name           = "system"
    node_count     = var.system_node_count
    vm_size        = "standard_d2ps_v6"
    vnet_subnet_id = var.system_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
  network_plugin     = "azure"
  load_balancer_sku  = "standard"
  service_cidr       = "10.100.0.0/16"
  dns_service_ip     = "10.100.0.10"
}

  role_based_access_control_enabled = true

  tags = var.tags
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}