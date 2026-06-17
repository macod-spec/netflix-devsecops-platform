resource "azurerm_monitor_action_group" "ops" {
  count = var.alert_email != "" ? 1 : 0

  name                = "ag-netflix-dev-ops"
  resource_group_name = var.resource_group_name
  short_name          = "nfxdevops"

  email_receiver {
    name                    = "platform-owner"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }

  tags = var.tags
}