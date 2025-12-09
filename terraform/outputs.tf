output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.monitoring.name
}

output "workbook_id" {
  description = "ID of the main workbook"
  value       = azurerm_application_insights_workbook.main.id
}

output "workbook_template_id" {
  description = "ID of the template workbook"
  value       = azurerm_application_insights_workbook.template.id
}

output "dashboard_id" {
  description = "ID of the dashboard"
  value       = azurerm_portal_dashboard.main.id
}

output "dashboard_url" {
  description = "URL to access the dashboard"
  value       = "https://portal.azure.com/#@${data.azurerm_client_config.current.tenant_id}/dashboard/arm${azurerm_portal_dashboard.main.id}"
}