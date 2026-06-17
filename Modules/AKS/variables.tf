variable "aks_name" {
  description = "Name of the AKS cluster."
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "system_subnet_id" {
  description = "Subnet ID for the AKS system node pool."
  type        = string
}

variable "acr_id" {
  description = "Azure Container Registry ID for AcrPull assignment."
  type        = string
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version. Null means Azure chooses the default supported version."
  type        = string
  default     = null
}

variable "system_node_count" {
  description = "Number of nodes in the system node pool."
  type        = number
  default     = 1
}

variable "system_node_vm_size" {
  description = "VM size for the system node pool."
  type        = string
  default     = "Standard_B2s"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
variable "log_analytics_workspace_id" {
  description = "Optional Log Analytics Workspace ID used by AKS Container Insights."
  type        = string
  default     = null
}