terraform {
  required_version = ">= 1.5, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
  tags = merge(var.tags, { environment = "production", course = "PRO2004" })
}

resource "azurerm_resource_group" "shop" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

module "store_api" {
  source = "../../modules/web-app"

  name                = var.app_name
  location            = azurerm_resource_group.shop.location
  resource_group_name = azurerm_resource_group.shop.name
  container_image     = var.container_image
  tags                = local.tags
}

output "app_id" {
  value = module.store_api.resource_id
}

output "app_name" {
  value = module.store_api.name
}

output "app_url" {
  value = module.store_api.url
}
