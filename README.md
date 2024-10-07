# Oneshot deployment for application landingzone

## Introduction

This module is intended for one-shot deployments only!

This module provides a oneshot deployment for a new application landing zone.
It creates the service connection, optionally moves the subscription to a new management group, creates a build validation policy and creates a new repository with the first pipeline settings and terraform files.

## Prerequisites

You need:

- Personal Access Token for the DevOps Organization to create service connections and repositories
- Project Admin on DevOps Project
- Admin User to create the service principal in the Customer Tenant. If you want to move the subscription into a new management group you need an admin user directly in the tenant. AOBO will not work.
<!-- BEGIN_TF_DOCS -->
## Usage

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >=2.36.0 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | >=0.4.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.46.0 |
| <a name="requirement_http-full"></a> [http-full](#requirement\_http-full) | 1.3.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alerting"></a> [alerting](#input\_alerting) | The `alerting` tag of the subscription. Can be `enabled` or `disabled`. | `string` | n/a | yes |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | The `applicationname` tag of subscription. | `string` | n/a | yes |
| <a name="input_business_service_number"></a> [business\_service\_number](#input\_business\_service\_number) | The `Business Service Number` tag of subscription. | `string` | n/a | yes |
| <a name="input_devops_project_name"></a> [devops\_project\_name](#input\_devops\_project\_name) | Name of the DevOps Project to create the service connections for. | `string` | n/a | yes |
| <a name="input_devops_service_url"></a> [devops\_service\_url](#input\_devops\_service\_url) | Azure DevOps organization url. | `string` | n/a | yes |
| <a name="input_devops_subscription_id"></a> [devops\_subscription\_id](#input\_devops\_subscription\_id) | Subscription ID of the DevOps Subscription. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | The `env` tag of the subscription . Can be `prd`, `dev`, `tst`, `qas`, `stg`, `int`, `lab` or `shr`. | `string` | n/a | yes |
| <a name="input_iac"></a> [iac](#input\_iac) | The `iac` tag of subscription. Set to `true` if the subscription is managed by Infrastructure as Code (IaC) and `false` otherwise | `bool` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The default location used for resources in this Landing Zone. | `string` | n/a | yes |
| <a name="input_managed_by"></a> [managed\_by](#input\_managed\_by) | The `managedby` tag of the subscription. This should be the entity responsible for managing the infrastructure (e.g `q.beyond`). | `string` | n/a | yes |
| <a name="input_personal_access_token"></a> [personal\_access\_token](#input\_personal\_access\_token) | [Personal access token](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows#create-a-pat) used for authentication to the Azure DevOps organization. Is only used during the oneshot deployment. You require the following scopes: `Code`=`Full`, `Environment`=`Read & manage`, `Identity`=`Read & manage`, `Pipeline Resources`=`Use and manage`, `Project and Team`=`Read, write, & manage`, `Security`=`Manage`, `Service Connections`=`Read, query, & manage`,`Variable Groups`=`Read, create, & manage` | `string` | n/a | yes |
| <a name="input_rg_config"></a> [rg\_config](#input\_rg\_config) | Resources groups to create. Use 'rg' as the key and resources group name as the value. | `map(string)` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | Name of the current stage. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Subscription ID of the Landing Zone Subscription. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenant ID of the Customer. | `string` | n/a | yes |
| <a name="input_terraform_state_config"></a> [terraform\_state\_config](#input\_terraform\_state\_config) | The configuration of the Terraform state. The state will be saved in the given storage account in the DevOps subscription using the backend service connection. | <pre>object({<br>    resource_group_name        = string<br>    storage_account_name       = string<br>    backend_service_connection = string<br>  })</pre> | n/a | yes |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | Terraform version to install. | `string` | n/a | yes |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | A mapping of tags to add to the subscription in addition to the default tags. | `map(string)` | `{}` | no |
| <a name="input_create_virtual_machine_template"></a> [create\_virtual\_machine\_template](#input\_create\_virtual\_machine\_template) | Set to true to create a template for creating a windows vm. | `bool` | `false` | no |
| <a name="input_management_group_id"></a> [management\_group\_id](#input\_management\_group\_id) | Management Group ID where to move the subscription. Optional Parameter if association already done. | `string` | `""` | no |
| <a name="input_vm_ux_hostname"></a> [vm\_ux\_hostname](#input\_vm\_ux\_hostname) | Set the hostnmae of vm. | `string` | `""` | no |
| <a name="input_vm_ux_public_key_name"></a> [vm\_ux\_public\_key\_name](#input\_vm\_ux\_public\_key\_name) | Set the public key file name. | `string` | `""` | no |
| <a name="input_vm_win_hostname"></a> [vm\_win\_hostname](#input\_vm\_win\_hostname) | Set the hostnmae of vm. | `string` | `""` | no |
| <a name="input_vnet_config"></a> [vnet\_config](#input\_vnet\_config) | <pre>If you want to provide a virtual network, please provide the following values: <br>  dns_server: DNS Servers that will be used in the network.<br>  address_space: Address space of the virtual network in CIDR notation.<br>  subnets: Subnets that will be created in the virtual network. Use 'Usecase' as the key and the address prefix as the value in CIDR notation.    <br>  nsg: Create NSG for all the subnets.</pre> | <pre>object({<br>    dns_server    = list(string)<br>    address_space = string<br>    subnets       = map(string)<br>    nsg           = bool<br>  })</pre> | `null` | no |
## Outputs

No outputs.

      ## Resource types
      | Type | Used |
      |------|-------|
        | [azuredevops_branch_policy_build_validation](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/branch_policy_build_validation) | 1 |
        | [azuredevops_build_definition](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/build_definition) | 1 |
        | [azuredevops_environment](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/environment) | 1 |
        | [azuredevops_git_repository](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository) | 1 |
        | [azuredevops_git_repository_branch](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_branch) | 1 |
        | [azuredevops_git_repository_file](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | 11 |
        | [azuredevops_resource_authorization](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/resource_authorization) | 1 |
        | [azurerm_management_group_subscription_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_subscription_association) | 1 |
        | [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | 1 |
      **`Used` only includes resource blocks.** `for_each` and `count` meta arguments, as well as resource blocks of modules are not considered.
    
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_service_connection_application"></a> [service\_connection\_application](#module\_service\_connection\_application) | qbeyond/service-connection/azuredevops | 1.0.0 |

        ## Resources by Files
            ### build_validation.tf
            | Name | Type |
            |------|------|
                  | [azuredevops_branch_policy_build_validation.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/branch_policy_build_validation) | resource |
            ### main.tf
            | Name | Type |
            |------|------|
                  | [azurerm_management_group_subscription_association.target](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_subscription_association) | resource |
                  | [azurerm_storage_container.landing_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
                  | [azurerm_management_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
                  | [azurerm_storage_account.terraform_state](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
            ### pipeline-permissions.tf
            | Name | Type |
            |------|------|
                  | [azuredevops_resource_authorization.service_connection_permission_alz](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/resource_authorization) | resource |
                  | [azuredevops_team.default](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/team) | data source |
                  | [http-full_http.approval_and_check_alz](https://registry.terraform.io/providers/salrashid123/http-full/1.3.1/docs/data-sources/http) | data source |
                  | [http-full_http.environment_permission_alz](https://registry.terraform.io/providers/salrashid123/http-full/1.3.1/docs/data-sources/http) | data source |
                  | [http-full_http.environment_user_permission_alz](https://registry.terraform.io/providers/salrashid123/http-full/1.3.1/docs/data-sources/http) | data source |
            ### pipeline.tf
            | Name | Type |
            |------|------|
                  | [azuredevops_build_definition.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/build_definition) | resource |
                  | [azuredevops_environment.alz](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/environment) | resource |
            ### repository.tf
            | Name | Type |
            |------|------|
                  | [azuredevops_git_repository.landing_zone](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository) | resource |
                  | [azuredevops_git_repository_branch.init](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_branch) | resource |
                  | [azuredevops_git_repository_file.gitignore](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
                  | [azuredevops_git_repository_file.locals](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
                  | [azuredevops_git_repository_file.main](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
                  | [azuredevops_git_repository_file.network](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
                  | [azuredevops_git_repository_file.nsg](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
                  | [azuredevops_git_repository_file.nsgyaml](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
                  | [azuredevops_git_repository_file.pipeline](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
                  | [azuredevops_git_repository_file.tags](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
                  | [azuredevops_git_repository_file.terraform](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
                  | [azuredevops_git_repository_file.variables](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
                  | [azuredevops_git_repository_file.virtual_machine](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
            ### terraform.tf
            | Name | Type |
            |------|------|
                  | [azuredevops_project.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |
                  | [azurerm_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
    
<!-- END_TF_DOCS -->