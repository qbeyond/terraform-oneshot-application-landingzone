variable "subscription_id" {
    type = string 
    description = "Subscription ID of the Landing Zone Subscription"
}

variable "management_subscription_id" {
  type = string
  description = "Subscription ID of the Management Subscription"
}

variable "tenant_id" {
    type = string  
    description = "Tenant of the Customer"
}

variable "management_group_id" {
    type = string
    default = ""
    description = "Management Group ID. Optional Parameter if association already done."
}

variable "personal_access_token" {
  type        = string
  description = "PAT to use."
  sensitive   = true
}

variable "devops_service_url" {
  type = string
  description = "Azure DevOps organization url."
}

variable "devops_project_name" {
  type = string
  description = "Name of the DevOps Project to create the service connections for."
} 

variable "terraform_state_config" {
  type = object({
    resource_group_name = string
    storage_account_name = string
    backend_service_connection = string
  })
}

variable "location" {
  type = string
  description = "Name of the current location"
}

variable "stage" {
  type = string
  description = "Name of the current stage"
}

variable "vnet_config" {
  type = object({
    dns_server = list(string)
    subnets = list(object({
      address_prefix = string
      usecase = string
    }))
    address_space   = string
  })
}