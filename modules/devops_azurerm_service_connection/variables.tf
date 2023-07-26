variable "azure_devops_project" {
  description = "Azure DevOps project to create the service connection in."
  type = object({
    name = string
    id   = string
  })
}

variable "display_name" {
  type = string
  description = "Display name of Service principal (prefix: `sp-`) and service connection (prefix: `sc-azurerm-`)."
}

variable "subscription_id" {
  type = string
  description = "ID of subscription to create service connection to."
}

variable "subscription_name" {
  type = string
  description = "Name of subscription to create service connection to."
}

variable "tenant_id" {
  type = string
  description = "Tenant of the service principal."
}

variable "application" {
  type = object({
    object_id = string
    application_id = string
  })
  default = null
  description = "Optional azuread_application if one already exists."
}

variable "application_permission" {
  type = string 
  default = "Contributor"
  description = "The permission the serviceprincipal gets on the target subscription."
}