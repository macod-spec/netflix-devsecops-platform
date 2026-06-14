variable "acr_name" {
  description = "Name of the Azure Container Registry. Must be globally unique and contain only alphanumeric characters."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where ACR will be created."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "sku" {
  description = "ACR SKU."
  type        = string
  default     = "Basic"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
