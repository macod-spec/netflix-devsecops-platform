variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "address_space" {
  description = "Address space for the VNet."
  type        = list(string)
}

variable "system_subnet_prefix" {
  description = "CIDR block for the AKS system subnet."
  type        = string
}

variable "app_subnet_prefix" {
  description = "CIDR block for the AKS app subnet."
  type        = string
}

variable "ingress_subnet_prefix" {
  description = "CIDR block for ingress resources."
  type        = string
}

variable "private_endpoint_subnet_prefix" {
  description = "CIDR block for private endpoints."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
