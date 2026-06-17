data "azurerm_resource_group" "target" {
  name = var.resource_group_name
}

locals {
  budget_notifications = var.budget_alert_email != "" ? {
    actual_50 = {
      threshold      = 50
      threshold_type = "Actual"
    }

    actual_80 = {
      threshold      = 80
      threshold_type = "Actual"
    }

    actual_100 = {
      threshold      = 100
      threshold_type = "Actual"
    }

    forecasted_100 = {
      threshold      = 100
      threshold_type = "Forecasted"
    }
  } : {}
}

resource "azurerm_consumption_budget_resource_group" "monthly" {
  name              = "budget-netflix-dev-monthly"
  resource_group_id = data.azurerm_resource_group.target.id

  amount     = var.monthly_budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = var.budget_start_date
    end_date   = var.budget_end_date
  }

  dynamic "notification" {
    for_each = local.budget_notifications

    content {
      enabled        = true
      operator       = "GreaterThan"
      threshold      = notification.value.threshold
      threshold_type = notification.value.threshold_type
      contact_emails = [var.budget_alert_email]
    }
  }
}