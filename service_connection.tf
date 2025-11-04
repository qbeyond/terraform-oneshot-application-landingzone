module "service_connection_application" {
  source               = "qbeyond/service-connection/azuredevops"
  version              = "2.0.1"
  subscription_id      = var.subscription_id
  subscription_name    = data.azurerm_subscription.this.display_name
  display_name         = data.azurerm_subscription.this.display_name
  azure_devops_project = data.azuredevops_project.this
  tenant_id            = var.tenant_id
}