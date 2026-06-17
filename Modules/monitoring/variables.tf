variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace."
  type        = string
}

variable "location" {
  description = "Azure region for the Log Analytics Workspace."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the Log Analytics Workspace is created."
  type        = string
}

variable "retention_in_days" {
  description = "Log retention period in days."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags applied to the Log Analytics Workspace."
  type        = map(string)
  default     = {}
}

variable "alert_email" {
  description = "Email address used by the Azure Monitor Action Group."
  type        = string
  default     = ""
}
