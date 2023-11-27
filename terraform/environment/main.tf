terraform {
  required_providers {
    azurerm = {
      version = ">= 3.43"
    }
    random = {
      version = ">= 3.4"
    }
    http = {
      version = ">= 3.2"
    }
  }

  backend "azurerm" {
    container_name = "tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

data "azurerm_client_config" "current" {}

# Configure the Terraform remote state backend.
data "terraform_remote_state" "shared" {
  backend = "azurerm"

  config = {
    storage_account_name = var.storage_account
    resource_group_name  = var.resource_group
    container_name       = "tfstate"
    key                  = "shared.${var.location}.tfstate"
  }
}

# Get the public IP address
data "http" "public_ip" {
  url = "https://ifconfig.co/ip"
}

locals {
  # Lookup and set the location abbreviation, defaults to na (not available).
  location_abbreviation = try(var.location_abbreviation[var.location], "na")

  # Construct the name suffix.
  suffix = "${var.app}-${var.environment}-${local.location_abbreviation}"

  # Clean and set the public IP address
  public_ip = chomp(data.http.public_ip.response_body)

  # Set the authorized IP ranges for the Kubernetes cluster.
  authorized_ip_ranges = ["${local.public_ip}/32"]
}

# Create the resource group.
resource "azurerm_resource_group" "default" {
  name     = "rg-${local.suffix}"
  location = var.location
}

# Create the Log Analytics workspace.
resource "azurerm_log_analytics_workspace" "default" {
  name                = "log-${local.suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.default.name
  retention_in_days   = 30
}
