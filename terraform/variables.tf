variable "resource_group_name" {
  description = "Name of the resource group for monitoring resources"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "app_insights_name" {
  description = "Name of existing Application Insights"
  type        = string
}

variable "app_insights_resource_group" {
  description = "Resource Group of existing Application Insights"
  type        = string
}

variable "workbook_name" {
  description = "Name of the Azure Workbook"
  type        = string
}

variable "workbook_display_name" {
  description = "Display name of the Azure Workbook"
  type        = string
}

variable "dashboard_name" {
  description = "Name of the Azure Dashboard"
  type        = string
}

variable "dashboard_title" {
  description = "Title of the Azure Dashboard"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}