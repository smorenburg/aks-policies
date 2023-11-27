terraform {
  required_providers {
    azurerm = {
      version = ">= 3.43"
    }
    random = {
      version = ">= 3.4"
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

locals {
  # Lookup and set the location abbreviation, defaults to na (not available).
  location_abbreviation = try(var.location_abbreviation[var.location], "na")

  # Construct the name suffix.
  suffix = "${var.app}-shared-${local.location_abbreviation}"
}

# Generate a random suffix for the container registry.
resource "random_id" "container_registry" {
  byte_length = 3
}

# Create the resource group.
resource "azurerm_resource_group" "default" {
  name     = "rg-${local.suffix}"
  location = var.location
}

# Create the container registry.
resource "azurerm_container_registry" "default" {
  name                = "cr${var.app}${random_id.container_registry.hex}"
  resource_group_name = azurerm_resource_group.default.name
  location            = var.location
  sku                 = "Premium"
}
