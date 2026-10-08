variable "name" {
  description = "Globally unique Web App name; changing it replaces the app."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{0,58}[a-z0-9]$", var.name))
    error_message = "Use 2-60 lowercase letters, digits or hyphens; start and end with a letter or digit."
  }
}

variable "location" {
  description = "Azure region with Linux App Service and F1 capacity."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group managed by the caller."
  type        = string
}

variable "container_image" {
  description = "Existing public Docker Hub image: username/repository:tag or username/repository@sha256:digest."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9._-]*/[a-z0-9][a-z0-9._-]*(:[A-Za-z0-9_][A-Za-z0-9_.-]*|@sha256:[a-f0-9]{64})$", var.container_image))
    error_message = "Supply a public Docker Hub username/repository with an explicit tag or SHA-256 digest."
  }
}

variable "tags" {
  description = "Ownership and environment tags."
  type        = map(string)
  default     = {}
}
