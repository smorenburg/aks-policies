output "container_registry_id" {
  description = "The identifier of the container registry."
  value = azurerm_container_registry.default.id
}
