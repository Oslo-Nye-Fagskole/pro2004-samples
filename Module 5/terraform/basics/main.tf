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

variable "subscription_id" {
  description = "Azure subscription to manage."
  type        = string
}

variable "resource_group_name" {
  description = "Dedicated shop API exercise group. Choose one managing tool."
  type        = string
  default     = "rg-shop"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "tags" {
  type = map(string)
  default = {
    environment = "development"
    course      = "PRO2004"
  }
}

resource "azurerm_resource_group" "shop" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

output "resource_group_id" {
  value = azurerm_resource_group.shop.id
}
