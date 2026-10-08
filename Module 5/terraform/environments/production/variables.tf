variable "subscription_id" {
  description = "Explicit target subscription for this environment."
  type        = string
}

variable "resource_group_name" {
  type    = string
  default = "rg-shop-production"
}

variable "app_name" {
  description = "Globally unique app name for the production exercise."
  type        = string
}

variable "container_image" {
  description = "Initial public Docker Hub image, already published."
  type        = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "tags" {
  type    = map(string)
  default = {}
}
