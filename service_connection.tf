# resource "azuread_application" "this" {
#   display_name = "sp-${data.azurerm_subscription.this.display_name}-devops-01"
# }

# resource "azuread_service_principal" "this" {
#   application_id               = azuread_application.this.application_id
#   app_role_assignment_required = false
# }

# resource "azuread_application_password" "this" {
#   application_object_id = azuread_application.this.object_id
#   display_name          = data.azuredevops_project.this.name
# }

# resource "azuredevops_serviceendpoint_azurerm" "this" {
#   project_id                = data.azuredevops_project.this.id
#   service_endpoint_name     = "sc-azurerm-${data.azurerm_subscription.this.display_name}"
#   azurerm_spn_tenantid      = var.tenant_id
#   azurerm_subscription_id   = data.azurerm_subscription.this.subscription_id
#   azurerm_subscription_name = data.azurerm_subscription.this.display_name
  
#   credentials {
#       serviceprincipalid  = azuread_application.this.application_id
#       serviceprincipalkey = azuread_application_password.this.value
#     }
# }

module "service_connection_application" {
    source = "./modules/devops_azurerm_service_connection"
    subscription_id = var.subscription_id
    subscription_name = data.azurerm_subscription.this.display_name
    display_name = data.azurerm_subscription.this.display_name
    azure_devops_project = data.azuredevops_project.this
    tenant_id = var.tenant_id
}

