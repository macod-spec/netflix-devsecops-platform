variable "resource_group_name" {
  description = "Resource group name to apply the budget to."
  type        = string
}

variable "monthly_budget_amount" {
  description = "Monthly budget amount in the subscription billing currency."
  type        = number
  default     = 100
}

variable "budget_alert_email" {
  description = "Email address used for budget alert notifications."
  type        = string
  default     = ""
}

variable "budget_start_date" {
  description = "Budget start date. Must be in RFC3339 format."
  type        = string
  default     = "2026-06-01T00:00:00Z"
}

variable "budget_end_date" {
  description = "Budget end date. Must be in RFC3339 format."
  type        = string
  default     = "2036-06-01T00:00:00Z"
}

variable "tags" {
  description = "Tags applied to FinOps resources."
  type        = map(string)
  default     = {}
}