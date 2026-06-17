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

module "acr" {
  source = "../../Modules/ACR"

  acr_name            = var.acr_name
  resource_group_name = module.resource_group.name
  location            = var.location
  sku                 = "Basic"
  tags                = local.common_tags
}
module "aks" {
  source = "../../Modules/AKS"

  aks_name            = var.aks_name
  dns_prefix          = var.aks_dns_prefix
  location            = var.location
  resource_group_name = module.resource_group.name
  system_subnet_id    = module.networking.system_subnet_id
  acr_id              = module.acr.id

  system_node_count   = var.aks_system_node_count
  system_node_vm_size = var.aks_system_node_vm_size

  tags = local.common_tags

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
}

module "monitoring" {
  source = "../../Modules/monitoring"

  log_analytics_workspace_name = "law-netflix-dev-uksouth"
  location                     = "uksouth"
  resource_group_name          = "rg-netflix-dev-uksouth"
  retention_in_days            = 30
  alert_email                  = var.alert_email

  tags = {
    environment = "dev"
    managed_by  = "terraform"
    owner       = "mac"
    project     = "netflix-devsecops-platform"
  }
}

module "finops" {
  source = "../../Modules/finops"

  resource_group_name   = "rg-netflix-dev-uksouth"
  monthly_budget_amount = 100
  budget_alert_email    = var.alert_email
  budget_start_date     = "2026-06-01T00:00:00Z"
  budget_end_date       = "2036-06-01T00:00:00Z"

  tags = {
    environment = "dev"
    managed_by  = "terraform"
    owner       = "mac"
    project     = "netflix-devsecops-platform"
  }
}