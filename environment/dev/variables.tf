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
