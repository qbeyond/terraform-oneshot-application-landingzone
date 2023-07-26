module "service_connection_application" {
  source               = "./modules/devops_azurerm_service_connection"
  subscription_id      = var.subscription_id
  subscription_name    = data.azurerm_subscription.this.display_name
  display_name         = data.azurerm_subscription.this.display_name
  azure_devops_project = data.azuredevops_project.this
  tenant_id            = var.tenant_id
}

