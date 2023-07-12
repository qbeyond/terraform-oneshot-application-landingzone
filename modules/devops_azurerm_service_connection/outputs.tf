output "service_principal_object_id" {
  value       = length(azuread_service_principal.this) == 1 ? azuread_service_principal.this[0].object_id : null
  description = "Object Id of created Service Principle"
}

output "service_endpoint" {
  value = azuredevops_serviceendpoint_azurerm.this
  description = "Service Endpoint for the created service connection"
}

output "application" {
  value = length(azuread_application.this) == 1 ? azuread_application.this[0] : null
  description = "Created azuread_application by this module for reuse in other service connections or null if already exists."
}