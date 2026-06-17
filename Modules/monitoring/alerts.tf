resource "azurerm_monitor_scheduled_query_rules_alert_v2" "netflix_dev_pods_not_running" {
  name                = "alert-netflix-dev-pods-not-running"
  resource_group_name = var.resource_group_name
  location            = var.location

  scopes      = [azurerm_log_analytics_workspace.this.id]
  description = "Alert when pods in the netflix-dev namespace are not Running or Succeeded."
  severity    = 2
  enabled     = true

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"

  criteria {
    query = <<-KQL
      KubePodInventory
      | where TimeGenerated > ago(5m)
      | where Namespace == "netflix-dev"
      | where PodStatus !in ("Running", "Succeeded")
      | summarize AggregatedValue = count()
    KQL

    time_aggregation_method = "Total"
    operator                = "GreaterThan"
    threshold               = 0
    metric_measure_column   = "AggregatedValue"
  }

  dynamic "action" {
    for_each = var.alert_email != "" ? [1] : []

    content {
      action_groups = [azurerm_monitor_action_group.ops[0].id]
    }
  }

  tags = var.tags
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "netflix_dev_pod_restarts" {
  name                = "alert-netflix-dev-pod-restarts"
  resource_group_name = var.resource_group_name
  location            = var.location

  scopes      = [azurerm_log_analytics_workspace.this.id]
  description = "Alert when pods in the netflix-dev namespace report restarts."
  severity    = 3
  enabled     = true

  evaluation_frequency = "PT5M"
  window_duration      = "PT15M"

  criteria {
    query = <<-KQL
      KubePodInventory
      | where TimeGenerated > ago(15m)
      | where Namespace == "netflix-dev"
      | summarize LatestRestartCount = max(PodRestartCount) by PodUid, Name
      | where LatestRestartCount > 0
      | summarize AggregatedValue = count()
    KQL

    time_aggregation_method = "Total"
    operator                = "GreaterThan"
    threshold               = 0
    metric_measure_column   = "AggregatedValue"
  }

  dynamic "action" {
    for_each = var.alert_email != "" ? [1] : []

    content {
      action_groups = [azurerm_monitor_action_group.ops[0].id]
    }
  }

  tags = var.tags
}