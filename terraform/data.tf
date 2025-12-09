# Reference to existing Application Insights
data "azurerm_application_insights" "existing" {
  name                = var.app_insights_name
  resource_group_name = var.app_insights_resource_group
}

# Get current subscription
data "azurerm_subscription" "current" {}

# Get current client config
data "azurerm_client_config" "current" {}