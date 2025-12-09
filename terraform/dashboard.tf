resource "azurerm_portal_dashboard" "main" {
  name                = "${var.dashboard_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = azurerm_resource_group.monitoring.location
  tags                = merge(var.tags, { 
    "hidden-title" = var.dashboard_title 
  })
  
  dashboard_properties = templatefile("${path.module}/templates/dashboard-template.json", {
    app_insights_id   = data.azurerm_application_insights.existing.id
    subscription_id   = data.azurerm_subscription.current.subscription_id
    resource_group    = var.app_insights_resource_group
    app_insights_name = var.app_insights_name
  })
}