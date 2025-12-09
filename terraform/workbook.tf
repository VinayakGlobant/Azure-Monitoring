 url=https://github.com/VinayakGlobant/Azure-Monitoring/blob/e2050d85c1ab7b4aaed32d3f61aca74374d32f3a/terraform/workbook.tf
# Azure Workbook with inline configuration
# Generate UUID names for the workbooks (Azure expects the workbook resource "name" to be a UUID)
resource "random_uuid" "main" {}

resource "random_uuid" "template" {}

resource "azurerm_application_insights_workbook" "main" {
  # Azure requires the workbook resource name to be a UUID; use random_uuid.result
  name                = random_uuid.main.result
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = azurerm_resource_group.monitoring.location
  display_name        = var.workbook_display_name
  source_id           = lower(data.azurerm_application_insights.existing.id)
  
  data_json = jsonencode({
    "version" = "Notebook/1.0",
    "items" = [
      {
        "type" = 1,
        "content" = {
          "json" = "## Application Performance Dashboard\n\nMonitoring metrics for ${var.app_insights_name}"
        },
        "name" = "header-text"
      },
      {
        "type" = 9,
        "content" = {
          "version" = "KqlParameterItem/1.0",
          "parameters" = [
            {
              "id" = "time-range-picker",
              "version" = "KqlParameterItem/1.0",
              "name" = "TimeRange",
              "label" = "Time Range",
              "type" = 4,
              "isRequired" = true,
              "value" = {
                "durationMs" = 86400000
              },
              "typeSettings" = {
                "selectableValues" = [
                  { "durationMs" = 3600000 },
                  { "durationMs" = 14400000 },
                  { "durationMs" = 43200000 },
                  { "durationMs" = 86400000 },
                  { "durationMs" = 172800000 },
                  { "durationMs" = 604800000 },
                  { "durationMs" = 2592000000 }
                ]
              }
            }
          ],
          "style" = "pills",
          "queryType" = 0,
          "resourceType" = "microsoft.insights/components"
        },
        "name" = "time-range-parameter"
      },
      {
        "type" = 3,
        "content" = {
          "version" = "KqlItem/1.0",
          "query" = "requests\n| where timestamp {TimeRange}\n| summarize TotalRequests = count(), FailedRequests = countif(success == false), SuccessRate = 100.0 - (countif(success == false) * 100.0 [...]
          "size" = 4,
          "title" = "Request Overview",
          "queryType" = 0,
          "resourceType" = "microsoft.insights/components",
          "visualization" = "tiles",
          "tileSettings" = {
            "showBorder" = false,
            "titleContent" = {
              "columnMatch" = "Column",
              "formatter" = 1
            },
            "leftContent" = {
              "columnMatch" = "Value",
              "formatter" = 12,
              "formatOptions" = {
                "palette" = "auto"
              }
            }
          }
        },
        "name" = "request-overview"
      },
      {
        "type" = 3,
        "content" = {
          "version" = "KqlItem/1.0",
          "query" = "requests\n| where timestamp {TimeRange}\n| summarize RequestCount = count() by bin(timestamp, 1h)\n| render timechart",
          "size" = 0,
          "title" = "Request Trend",
          "queryType" = 0,
          "resourceType" = "microsoft.insights/components",
          "visualization" = "linechart"
        },
        "name" = "request-trend"
      },
      {
        "type" = 3,
        "content" = {
          "version" = "KqlItem/1.0",
          "query" = "requests\n| where timestamp {TimeRange}\n| summarize Duration = avg(duration), Count = count() by name\n| top 10 by Count desc\n| project Operation = name, Count, AvgDuration = ro[...]
          "size" = 0,
          "title" = "Top 10 Operations",
          "queryType" = 0,
          "resourceType" = "microsoft.insights/components",
          "visualization" = "table",
          "gridSettings" = {
            "formatters" = [
              {
                "columnMatch" = "Count",
                "formatter" = 8,
                "formatOptions" = {
                  "palette" = "blue"
                }
              },
              {
                "columnMatch" = "AvgDuration",
                "formatter" = 8,
                "formatOptions" = {
                  "palette" = "yellow"
                }
              }
            ]
          }
        },
        "name" = "top-operations"
      },
      {
        "type" = 3,
        "content" = {
          "version" = "KqlItem/1.0",
          "query" = "exceptions\n| where timestamp {TimeRange}\n| summarize Count = count() by type, outerMessage\n| top 10 by Count desc",
          "size" = 0,
          "title" = "Top Exceptions",
          "queryType" = 0,
          "resourceType" = "microsoft.insights/components",
          "visualization" = "table"
        },
        "name" = "top-exceptions"
      }
    ],
    "$schema" = "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
  })
  
  tags = var.tags
}

# Workbook from template file
resource "azurerm_application_insights_workbook" "template" {
  # Azure requires the workbook resource name to be a UUID; use random_uuid.result
  name                = random_uuid.template.result
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = azurerm_resource_group.monitoring.location
  display_name        = "${var.workbook_display_name} - Advanced"
  source_id           = lower(data.azurerm_application_insights.existing.id)
  
  data_json = templatefile("${path.module}/templates/workbook-template.json", {
    app_insights_name = var.app_insights_name
    environment       = var.environment
  })
  
  tags = var.tags
}
