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
  type = string
}

variable "resource_group_name" {
  type    = string
  default = "rg-shop-existing"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "tags" {
  description = "Match the existing group's tags before planning import."
  type        = map(string)
  default     = {}
}

resource "azurerm_resource_group" "shop" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

import {
  to = azurerm_resource_group.shop
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
}

output "resource_group_id" {
  value = azurerm_resource_group.shop.id
}
