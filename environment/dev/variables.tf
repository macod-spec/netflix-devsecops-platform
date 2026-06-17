variable "location" {
  description = "Azure region for the dev environment."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the dev resource group."
  type        = string
}

variable "vnet_name" {
  description = "Name of the dev virtual network."
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the dev virtual network."
  type        = list(string)
}

variable "system_subnet_prefix" {
  description = "CIDR block for the system subnet."
  type        = string
}

variable "app_subnet_prefix" {
  description = "CIDR block for the app subnet."
  type        = string
}

variable "ingress_subnet_prefix" {
  description = "CIDR block for the ingress subnet."
  type        = string
}

variable "private_endpoint_subnet_prefix" {
  description = "CIDR block for the private endpoint subnet."
  type        = string
}

variable "aks_name" {
  description = "Name of the dev AKS cluster."
  type        = string
}

variable "aks_dns_prefix" {
  description = "DNS prefix for the dev AKS cluster."
  type        = string
}

variable "aks_system_node_count" {
  description = "Number of AKS system nodes."
  type        = number
  default     = 1
}

variable "aks_system_node_vm_size" {
  description = "VM size for the AKS system node pool."
  type        = string
  default     = "Standard_B2s"
}

variable "acr_name" {
  description = "Name of the dev Azure Container Registry."
  type        = string
}

variable "alert_email" {
  description = "Email address used by the Azure Monitor Action Group."
  type        = string
  default     = ""
}