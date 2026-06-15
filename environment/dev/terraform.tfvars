location            = "uksouth"
resource_group_name = "rg-netflix-dev-uksouth"

vnet_name                      = "vnet-netflix-dev-uksouth"
vnet_address_space             = ["10.0.0.0/16"]
system_subnet_prefix           = "10.0.1.0/24"
app_subnet_prefix              = "10.0.2.0/24"
ingress_subnet_prefix          = "10.0.3.0/24"
private_endpoint_subnet_prefix = "10.0.4.0/24"

acr_name                = "acrnetflixdevmac01"
aks_name                = "aks-netflix-dev-uksouth"
aks_dns_prefix          = "aks-netflix-dev-mac"
aks_system_node_count   = 1
aks_system_node_vm_size = "standard_d2ps_v6"
