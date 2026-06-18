#checkov:skip=CKV_AZURE_160:HTTP port 80 is intentionally exposed for the public demo endpoint; TLS ingress and domain are planned for a later phase.
resource "azurerm_network_security_rule" "system_allow_http_80" {
  name                        = "Allow-NetFlix-Web-HTTP-80"
  priority                    = 299
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.system.name
}

resource "azurerm_network_security_rule" "system_allow_nodeport_30507" {
  name                        = "Allow-NetFlix-Web-NodePort"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "30507"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.system.name
}

resource "azurerm_network_security_rule" "system_allow_azure_load_balancer" {
  name                        = "Allow-AzureLoadBalancer"
  priority                    = 301
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.system.name
}