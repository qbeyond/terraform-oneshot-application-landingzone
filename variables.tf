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

variable "application_name" {
  type        = string
  description = "The `applicationname` tag of subscription."

  validation {
    condition     = var.application_name != "ApplicationName"
    error_message = "The Application Name should be replaced with the actual Application Name."
  }
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

variable "create_virtual_machine_template" {
  type        = bool
  description = "Set to true to create a template for creating a windows vm."
  default     = false
}

variable "devops_project_name" {
  type        = string
  description = "Name of the DevOps Project to create the service connections for."
}

variable "devops_service_url" {
  type        = string
  description = "Azure DevOps organization url."
}

variable "devops_subscription_id" {
  type        = string
  description = "Subscription ID of the DevOps Subscription."
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

variable "location" {
  type        = string
  description = "The default location used for resources in this Landing Zone."
}

variable "managed_by" {
  type        = string
  description = "The `managedby` tag of the subscription. This should be the entity responsible for managing the infrastructure (e.g `q.beyond`)."

  validation {
    condition     = var.managed_by != "example.company"
    error_message = "The managed by should be replaced with the actual entity responsible for managing the infrastructure."
  }
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

variable "rg_config" {
  type        = map(string)
  description = "Resources groups to create. Use 'rg' as the key and resources group name as the value."
  nullable    = false
  default     = {}
  
  validation {
    condition     = contains(keys(var.rg_config), "network") && (contains(keys(var.rg_config), "application") || contains(keys(var.rg_config), "database"))
    error_message = "Keys 'network' and 'application' or 'database' must be defined in the map."
  }
}

variable "sql" {
  type = object({
    create         = bool
    cust           = string
    rg             = string      # Same name as vnet_config subnets key name and rg_config key.
    type           = string
    subnet         = string
    ip_server      = string
    database_name  = string
    collation      = string
    sku_name       = string
    max_size_gb    = number
    tags           = map(string)
  })
  description = "SQL configuration."

  validation {
    condition     = var.sql.create == false || (var.sql.create == true && contains(["server", "managed"], var.sql.type))
    error_message = "The SQL type should be either `server` for SQL Server, or `managed` for SQL Managed Instance."
  }
  validation {
    condition     = var.sql.type == "server" || (var.sql.type == "managed" && var.sql.sku_name != "ElasticPool")
    error_message = "Managed instances can not be ElasticPool sku."
  }
  validation {
    condition     = contains(keys(var.sql.tags), "tagname") != true
    error_message = "The key `tagname` is just an example. Please remove it from the additional tags."
  }
  validation {
    condition = var.sql.type == "managed" || (var.sql.type == "server" && contains([
      "Free", "Basic", "ElasticPool", "S0", "S1", "S2", "S3", "S4", "S6", "S7", "S9", "S12", "P1", "P2", "P4", "P6", "P11", "P15", "DW100c", "DW200c",
      "DW300c", "DW400c", "DW500c", "DW1000c", "DW1500c", "DW2000c", "DW2500c", "DW3000c", "DW5000c", "DW6000c", "DW7500c", "DW10000c", "DW15000c", 
      "DW30000c", "DS100", "DS200", "DS300", "DS400", "DS500", "DS600", "DS1000", "DS1200", "DS1500", "DS2000", "GP_S_Gen5_1", "GP_Gen5_2", "GP_S_Gen5_2", 
      "GP_DC_2", "GP_Gen5_4", "GP_S_Gen5_4", "GP_DC_4", "GP_Gen5_6", "GP_S_Gen5_6", "GP_DC_6", "GP_Gen5_8", "GP_S_Gen5_8", "GP_DC_8", "GP_Fsv2_8", "GP_Gen5_10", 
      "GP_S_Gen5_10", "GP_DC_10", "GP_Fsv2_10", "GP_Gen5_12", "GP_S_Gen5_12", "GP_DC_12", "GP_Fsv2_12", "GP_Gen5_14", "GP_S_Gen5_14", "GP_DC_14", "GP_Fsv2_14", 
      "GP_Gen5_16", "GP_S_Gen5_16", "GP_DC_16", "GP_Fsv2_16", "GP_Gen5_18", "GP_S_Gen5_18", "GP_DC_18", "GP_Fsv2_18", "GP_Gen5_20", "GP_S_Gen5_20", "GP_DC_20", 
      "GP_Fsv2_20", "GP_Gen5_24", "GP_S_Gen5_24", "GP_Fsv2_24", "GP_Gen5_32", "GP_S_Gen5_32", "GP_DC_32", "GP_Fsv2_32", "GP_Fsv2_36", "GP_Gen5_40", "GP_S_Gen5_40", 
      "GP_DC_40", "GP_Fsv2_72", "GP_Gen5_80", "GP_S_Gen5_80", "GP_Gen5_128", "BC_Gen5_2", "BC_DC_2", "BC_Gen5_4", "BC_DC_4", "BC_Gen5_6", "BC_DC_6", "BC_Gen5_8", 
      "BC_DC_8", "BC_Gen5_10", "BC_DC_10", "BC_Gen5_12", "BC_DC_12", "BC_Gen5_14", "BC_DC_14", "BC_Gen5_16", "BC_DC_16", "BC_Gen5_18", "BC_DC_18", "BC_Gen5_20", 
      "BC_DC_20", "BC_Gen5_24", "BC_Gen5_32", "BC_DC_32", "BC_Gen5_40", "BC_DC_40", "BC_Gen5_80", "BC_Gen5_128", "HS_Gen5_2", "HS_S_Gen5_2", "HS_PRMS_2", 
      "HS_MOPRMS_2", "HS_DC_2", "HS_Gen5_4", "HS_S_Gen5_4", "HS_PRMS_4", "HS_MOPRMS_4", "HS_DC_4", "HS_Gen5_6", "HS_S_Gen5_6", "HS_PRMS_6", "HS_MOPRMS_6", 
      "HS_DC_6", "HS_Gen5_8", "HS_S_Gen5_8", "HS_PRMS_8", "HS_MOPRMS_8", "HS_DC_8", "HS_Gen5_10", "HS_S_Gen5_10", "HS_PRMS_10", "HS_MOPRMS_10", "HS_DC_10", 
      "HS_Gen5_12", "HS_S_Gen5_12", "HS_PRMS_12", "HS_MOPRMS_12", "HS_DC_12", "HS_Gen5_14", "HS_S_Gen5_14", "HS_PRMS_14", "HS_MOPRMS_14", "HS_DC_14", 
      "HS_Gen5_16", "HS_S_Gen5_16", "HS_PRMS_16", "HS_MOPRMS_16", "HS_DC_16", "HS_Gen5_18", "HS_S_Gen5_18", "HS_PRMS_18", "HS_MOPRMS_18", "HS_DC_18", 
      "HS_Gen5_20", "HS_S_Gen5_20", "HS_PRMS_20", "HS_MOPRMS_20", "HS_DC_20", "HS_Gen5_24", "HS_S_Gen5_24", "HS_PRMS_24", "HS_MOPRMS_24", "HS_Gen5_32", 
      "HS_S_Gen5_32", "HS_PRMS_32", "HS_MOPRMS_32", "HS_DC_32", "HS_Gen5_40", "HS_S_Gen5_40", "HS_PRMS_40", "HS_MOPRMS_40", "HS_DC_40", "HS_PRMS_64", 
      "HS_MOPRMS_64", "HS_Gen5_80", "HS_S_Gen5_80", "HS_PRMS_80", "HS_MOPRMS_80", "HS_PRMS_128"], var.sql.sku_name))
    error_message = "The SKU name for SQL Server should be on of this: 'Free', 'Basic', 'ElasticPool', 'S0', 'S1', 'S2', 'S3', 'S4', 'S6', 'S7', 'S9', 'S12', 'P1', 'P2', 'P4', 'P6', 'P11', 'P15', 'DW100c', 'DW200c', 'DW300c', 'DW400c', 'DW500c', 'DW1000c', 'DW1500c', 'DW2000c', 'DW2500c', 'DW3000c', 'DW5000c', 'DW6000c', 'DW7500c', 'DW10000c', 'DW15000c', 'DW30000c', 'DS100', 'DS200', 'DS300', 'DS400', 'DS500', 'DS600', 'DS1000', 'DS1200', 'DS1500', 'DS2000', 'GP_S_Gen5_1', 'GP_Gen5_2', 'GP_S_Gen5_2', 'GP_DC_2', 'GP_Gen5_4', 'GP_S_Gen5_4', 'GP_DC_4', 'GP_Gen5_6', 'GP_S_Gen5_6', 'GP_DC_6', 'GP_Gen5_8', 'GP_S_Gen5_8', 'GP_DC_8', 'GP_Fsv2_8', 'GP_Gen5_10', 'GP_S_Gen5_10', 'GP_DC_10', 'GP_Fsv2_10', 'GP_Gen5_12', 'GP_S_Gen5_12', 'GP_DC_12', 'GP_Fsv2_12', 'GP_Gen5_14', 'GP_S_Gen5_14', 'GP_DC_14', 'GP_Fsv2_14', 'GP_Gen5_16', 'GP_S_Gen5_16', 'GP_DC_16', 'GP_Fsv2_16', 'GP_Gen5_18', 'GP_S_Gen5_18', 'GP_DC_18', 'GP_Fsv2_18', 'GP_Gen5_20', 'GP_S_Gen5_20', 'GP_DC_20', 'GP_Fsv2_20', 'GP_Gen5_24', 'GP_S_Gen5_24', 'GP_Fsv2_24', 'GP_Gen5_32', 'GP_S_Gen5_32', 'GP_DC_32', 'GP_Fsv2_32', 'GP_Fsv2_36', 'GP_Gen5_40', 'GP_S_Gen5_40', 'GP_DC_40', 'GP_Fsv2_72', 'GP_Gen5_80', 'GP_S_Gen5_80', 'GP_Gen5_128', 'BC_Gen5_2', 'BC_DC_2', 'BC_Gen5_4', 'BC_DC_4', 'BC_Gen5_6', 'BC_DC_6', 'BC_Gen5_8', 'BC_DC_8', 'BC_Gen5_10', 'BC_DC_10', 'BC_Gen5_12', 'BC_DC_12', 'BC_Gen5_14', 'BC_DC_14', 'BC_Gen5_16', 'BC_DC_16', 'BC_Gen5_18', 'BC_DC_18', 'BC_Gen5_20', 'BC_DC_20', 'BC_Gen5_24', 'BC_Gen5_32', 'BC_DC_32', 'BC_Gen5_40', 'BC_DC_40', 'BC_Gen5_80', 'BC_Gen5_128', 'HS_Gen5_2', 'HS_S_Gen5_2', 'HS_PRMS_2', 'HS_MOPRMS_2', 'HS_DC_2', 'HS_Gen5_4', 'HS_S_Gen5_4', 'HS_PRMS_4', 'HS_MOPRMS_4', 'HS_DC_4', 'HS_Gen5_6', 'HS_S_Gen5_6', 'HS_PRMS_6', 'HS_MOPRMS_6', 'HS_DC_6', 'HS_Gen5_8', 'HS_S_Gen5_8', 'HS_PRMS_8', 'HS_MOPRMS_8', 'HS_DC_8', 'HS_Gen5_10', 'HS_S_Gen5_10', 'HS_PRMS_10', 'HS_MOPRMS_10', 'HS_DC_10', 'HS_Gen5_12', 'HS_S_Gen5_12', 'HS_PRMS_12', 'HS_MOPRMS_12', 'HS_DC_12', 'HS_Gen5_14', 'HS_S_Gen5_14', 'HS_PRMS_14', 'HS_MOPRMS_14', 'HS_DC_14', 'HS_Gen5_16', 'HS_S_Gen5_16', 'HS_PRMS_16', 'HS_MOPRMS_16', 'HS_DC_16', 'HS_Gen5_18', 'HS_S_Gen5_18', 'HS_PRMS_18', 'HS_MOPRMS_18', 'HS_DC_18', 'HS_Gen5_20', 'HS_S_Gen5_20', 'HS_PRMS_20', 'HS_MOPRMS_20', 'HS_DC_20', 'HS_Gen5_24', 'HS_S_Gen5_24', 'HS_PRMS_24', 'HS_MOPRMS_24', 'HS_Gen5_32', 'HS_S_Gen5_32', 'HS_PRMS_32', 'HS_MOPRMS_32', 'HS_DC_32', 'HS_Gen5_40', 'HS_S_Gen5_40', 'HS_PRMS_40', 'HS_MOPRMS_40', 'HS_DC_40', 'HS_PRMS_64', 'HS_MOPRMS_64', 'HS_Gen5_80', 'HS_S_Gen5_80', 'HS_PRMS_80', 'HS_MOPRMS_80', 'HS_PRMS_128'"
  }
  validation {
    condition = var.sql.type == "server" || (var.sql.type == "managed" && contains([
      "GP_Gen4", "GP_Gen5", "GP_Gen8IM", "GP_Gen8IH", "BC_Gen4", "BC_Gen5", "BC_Gen8IM", "BC_Gen8IH"], var.sql.sku_name))
    error_message = "The SKU name for SQL Management Instances should be on of this: 'GP_Gen4', 'GP_Gen5', 'GP_Gen8IM', 'GP_Gen8IH', 'BC_Gen4', 'BC_Gen5', 'BC_Gen8IM', 'BC_Gen8IH'"
  }
}

variable "stage" {
  type        = string
  description = "Name of the current stage."
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID of the Landing Zone Subscription."
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID of the Customer."
}

variable "terraform_state_config" {
  type = object({
    resource_group_name        = string
    storage_account_name       = string
    backend_service_connection = string
  })
  description = "The configuration of the Terraform state. The state will be saved in the given storage account in the DevOps subscription using the backend service connection."
}

variable "terraform_version" {
  type        = string
  description = "Terraform version to install in the DevOps pipeline."
  validation {
    error_message = "Must be valid semantic version."
    condition     = can(regex("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)", var.terraform_version))
  }
}

variable "vm_ux" {
  type = object({
    version         = string
    hostname        = string
    rg_key          = string
    subnet          = string
    public_key_name = optional(string)
  })
  description = <<-DOC
  ```
  To provide a Linux virtual machine, please provide the following values: 
    version: Linux module version that provide vm resource.
    hostname: VM hostname.
    rg_key: Resource group key name of resource defined in rg_config variable.
    subnet: Subnet key name defined in vnet_config.subnets map.
  ```
  DOC
  default     = null

  validation {
    condition     = var.vm_ux.hostname == "" || (var.vm_ux.hostname != "" && can(regex("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)", var.vm_ux.version)))
    error_message = "UX VM must has valid semantic version."
  }
  validation {
    condition     = var.create_virtual_machine_template == false || (var.create_virtual_machine_template == true && var.vm_ux.hostname == "") || ( var.create_virtual_machine_template == true && var.vm_ux.hostname != "" && contains(keys(var.rg_config), var.vm_ux.rg_key))
    error_message = "Resource group key name must be defined as in rg_config variable"
  }
  validation {
    condition     = var.create_virtual_machine_template == false || (var.create_virtual_machine_template == true && var.vm_ux.hostname == "") || ( var.create_virtual_machine_template == true && var.vm_ux.hostname != "" && contains(keys(var.vnet_config.subnets), var.vm_ux.subnet))
    error_message = "Subnet key name must be defined as in vnet_config.subnets variable"
  }
}

variable "vm_win" {
  type = object({
    version  = string
    hostname = string
    rg_key   = string
    subnet   = string
  })
  description = <<-DOC
  ```
  To provide a Windows virtual machine, please provide the following values: 
    version: Windows module version that provide vm resource.
    hostname: VM hostname.
    rg_key: Resource group key name of resource defined in rg_config variable.
    subnet: Subnet key name defined in vnet_config.subnets map.
  ```
  DOC
  default     = null

  validation {
    condition     = var.vm_win.hostname == "" || (var.vm_win.hostname != "" && can(regex("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)", var.vm_win.version)))
    error_message = "WIN VM must has valid semantic version."
  }
  validation {
    condition     = var.create_virtual_machine_template == false || (var.create_virtual_machine_template == true && var.vm_win.hostname == "") || ( var.create_virtual_machine_template == true && var.vm_win.hostname != "" && contains(keys(var.rg_config), var.vm_win.rg_key))
    error_message = "Resource group key name must be defined as in rg_config variable"
  }
  validation {
    condition     = var.create_virtual_machine_template == false || (var.create_virtual_machine_template == true && var.vm_win.hostname == "") || ( var.create_virtual_machine_template == true && var.vm_win.hostname != "" && contains(keys(var.vnet_config.subnets), var.vm_win.subnet))
    error_message = "Subnet key name must be defined as in vnet_config.subnets variable"
  }
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
  default = null
}