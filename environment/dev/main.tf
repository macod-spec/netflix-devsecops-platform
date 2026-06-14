terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}

  resource_provider_registrations = "none"
}

locals {
  common_tags = {
    project     = "netflix-devsecops-platform"
    environment = "dev"
    owner       = "mac"
    managed_by  = "terraform"
  }
}

module "resource_group" {
  source = "../../Modules/resource-group"

  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

module "networking" {
  source = "../../Modules/networking"

  vnet_name                      = var.vnet_name
  location                       = var.location
  resource_group_name            = module.resource_group.name
  address_space                  = var.vnet_address_space
  system_subnet_prefix           = var.system_subnet_prefix
  app_subnet_prefix              = var.app_subnet_prefix
  ingress_subnet_prefix          = var.ingress_subnet_prefix
  private_endpoint_subnet_prefix = var.private_endpoint_subnet_prefix
  tags                           = local.common_tags
}