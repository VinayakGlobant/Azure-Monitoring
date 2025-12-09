terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0"
    }
  }
  
  backend "azurerm" {
    # Backend configuration will be provided during init
  }
}

provider "azurerm" {
  features {}

  # Prevent Terraform from trying provider registration (avoid unsupported arguments)
  skip_provider_registration = true
}
  }
}
