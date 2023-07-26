variable "subscription_id" {
  type        = string
  description = "Subscription ID of the Landing Zone Subscription."
}

variable "devops_subscription_id" {
  type        = string
  description = "Subscription ID of the DevOps Subscription."
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID of the Customer."
}

variable "management_group_id" {
  type        = string
  default     = ""
  description = "Management Group ID where to move the subscription. Optional Parameter if association already done."
}

variable "personal_access_token" {
  type        = string
  description = "[Personal access token](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows#create-a-pat) used for authentication to the Azure DevOps organization. Is only used during the oneshot deployment. You require the following scopes: `Code`=`Full`, `Environment`=`Read & manage`, `Identity`=`Read & manage`, `Pipeline Resources`=`Use and manage`, `Project and Team`=`Read, write, & manage`, `Security`=`Manage`, `Service Connections`=`Read, query, & manage`,`Variable Groups`=`Read, create, & manage`"

  sensitive = true
}

variable "devops_service_url" {
  type        = string
  description = "Azure DevOps organization url."
}

variable "devops_project_name" {
  type        = string
  description = "Name of the DevOps Project to create the service connections for."
}

variable "terraform_state_config" {
  type = object({
    resource_group_name        = string
    storage_account_name       = string
    backend_service_connection = string
  })
  description = "The configuration of the Terraform state. The state will be saved in the given storage account in the DevOps subscription using the backend service connection."
}

variable "stage" {
  type        = string
  description = "Name of the current stage."
}

variable "location" {
  type        = string
  description = "The default location used for resources in this Landing Zone."
}

variable "vnet_config" {
  type = object({
    dns_server    = list(string)
    address_space = string
    subnets       = map(string)
  })
  description = <<-DOC
  ```
  If you want to provide a virtual network, please provide the following values: 
    dns_server: DNS Servers that will be used in the network.
    address_space: Address space of the virtual network in CIDR notation.
    subnets: Subnets that will be created in the virtual network. Use 'Usecase' as the key and the address prefix as the value in CIDR notation.    
  ```
  DOC
  default     = null
}

variable "skip_provider_registration" {
  type        = bool
  description = "Allows you to skip the provider registration when initilizing the azurerm provider. This is useful in development environments where not every provider can be registered."
  default     = false
}

variable "create_virtual_machine_template" {
  type        = bool
  description = "Set to true to create a template for creating a windows vm."
  default     = false
}
