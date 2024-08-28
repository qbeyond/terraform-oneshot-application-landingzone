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

variable "terraform_version" {
  type        = string
  description = "Terraform version to install in the DevOps pipeline."
}

variable "vnet_config" {
  type = object({
    dns_server    = list(string)
    address_space = string
    subnets       = map(string)
    nsg           = bool
  })
  description = <<-DOC
  ```
  If you want to provide a virtual network, please provide the following values: 
    dns_server: DNS Servers that will be used in the network.
    address_space: Address space of the virtual network in CIDR notation.
    subnets: Subnets that will be created in the virtual network. Use 'Usecase' as the key and the address prefix as the value in CIDR notation.    
    nsg: Create NSG for all the subnets.
  ```
  DOC
  default     = null
}

variable "skip_provider_registration" {
  type        = bool
  description = "Allows you to skip the provider registration when initilizing the azurerm provider in this configuration and the created configuration. This is useful in development environments where not every provider can be registered."
  default     = false
}

variable "create_virtual_machine_template" {
  type        = bool
  description = "Set to true to create a template for creating a windows vm."
  default     = false
}

variable "vm_win_hostname" {
  type        = string
  description = "Set the hostnmae of vm."
  default     = ""
}

variable "vm_ux_hostname" {
  type        = string
  description = "Set the hostnmae of vm."
  default     = ""
}

variable "business_service_number" {
  type        = string
  description = "The `Business Service Number` tag of subscription."
  validation {
    condition     = length(regexall("^\\d+$", var.business_service_number)) == 1
    error_message = "The Business Service Number should only contain numbers."
  }

  validation {
    condition     = var.business_service_number != "12345"
    error_message = "The Business Service Number should be replaced with the actual Business Service Number. Sorry if you really have this number."
  }
}

variable "application_name" {
  type        = string
  description = "The `applicationname` tag of subscription."
  validation {
    condition     = var.application_name != "ApplicationName"
    error_message = "The Application Name should be replaced with the actual Application Name."
  }
}

variable "env" {
  type        = string
  description = "The `env` tag of the subscription . Can be `prd`, `dev`, `tst`, `qas`, `stg`, `int`, `lab` or `shr`."
  validation {
    condition     = contains(["prd", "dev", "tst", "qas", "stg", "int", "lab", "shr"], var.env)
    error_message = "The environment should be either `prd`, `dev`, `tst`, `qas`, `stg`, `int`, `lab` or `shr`"
  }
}

variable "iac" {
  type        = bool
  description = "The `iac` tag of subscription. Set to `true` if the subscription is managed by Infrastructure as Code (IaC) and `false` otherwise"
}

variable "managed_by" {
  type        = string
  description = "The `managedby` tag of the subscription. This should be the entity responsible for managing the infrastructure (e.g `q.beyond`)."
  validation {
    condition     = var.managed_by != "example.company"
    error_message = "The managed by should be replaced with the actual entity responsible for managing the infrastructure."
  }
}

variable "alerting" {
  type        = string
  description = "The `alerting` tag of the subscription. Can be `enabled` or `disabled`."

  validation {
    condition     = contains(["enabled", "disabled"], var.alerting)
    error_message = "The alerting tag should be either `enabled` or `disabled`"
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "A mapping of tags to add to the subscription in addition to the default tags."
  default     = {}
  validation {
    condition     = contains(keys(var.additional_tags), "tagname") != true
    error_message = "The key `tagname` is just an example. Please remove it from the additional tags."
  }
}