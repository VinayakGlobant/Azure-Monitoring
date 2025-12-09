var.resource_group_name          = "monitoring-prod-rg"
location                     = "East US"
app_insights_name            = "myapp-prod-insights"
app_insights_resource_group  = "myapp-prod-rg"
workbook_name               = "app-workbook"
workbook_display_name       = "Application Monitoring Workbook - Production"
dashboard_name              = "app-dashboard"
dashboard_title             = "Application Monitoring Dashboard - Production"
environment                 = "prod"

tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
  Project     = "Monitoring"
  CostCenter  = "IT"
}
