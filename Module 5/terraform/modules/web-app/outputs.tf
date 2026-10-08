output "resource_id" {
  value = azurerm_linux_web_app.this.id
}

output "name" {
  value = azurerm_linux_web_app.this.name
}

output "url" {
  value = "https://${azurerm_linux_web_app.this.default_hostname}"
}

output "service_plan_id" {
  value = azurerm_service_plan.this.id
}
