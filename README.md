<!-- BEGIN_TF_DOCS -->

## Usage

# Introduction

This module is intended for one-shot deployments only!

This module provides a bootstrap deployment for a new application landing zone.
It creates the service connection, optionally moves the subscription, creates a build validation policy and creates a new repository with the first pipeline settings and terraform files.

## Prerequisites

You need:

- Personal Access Token for the DevOps Organization to create service connections and repositories
- Rights to create the service principal
- Project Admin on Customer DevOps Project

## Authentication

To authenticate yourself you need a service principal or an invited user. CSP AOBO Permissions will not work.
The Service Principal needs Owner permission on the management group and application admin in the AAD.
Follow the instructions on how to set the environment varibles for the service principal [here](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_client_secret).

## Approvals

On the first run of the pipeline, permissions are needed for the service connections and environment.
This can only be done with the user which pat was used in this deployment.

## Examples

### Basic

This is a basic terraform.tfvars template to use

```hcl
subscription_id = "<application subscription id>"
management_subscription_id = "<management subscription id>"
tenant_id = "<customer tenant id>"
management_group_id = "msp-lz-prd" #optional parameter
personal_access_token = "<your pat>"
devops_service_url = "https://dev.azure.com/<customer>"
devops_project_name = "ALZ - q.beyond AG"
terraform_state_config = {
    resource_group_name = "rg-TerraformState-prd-01"
    storage_account_name = "stter<customer>tfstate01"
    backend_service_connection = "sc-azurerm-prd-Management-01-backend"
}
location = "westeurope"
stage = "prd"
vnet_config = {
    dns_server = ["0.0.0.0","1.1.1.1"]
    address_space = "10.0.0.0/16"
    subnets = {
      subnet1 = {
        address_prefix = "10.0.0.0/24"
        usecase = "storage"
      },
      subnet2 = {
        address_prefix = "10.0.1.0/24"
        usecase = "coolerusecase"
      }
    }
}
```

## Requirements

| Name                                                                           | Version  |
| ------------------------------------------------------------------------------ | -------- |
| <a name="requirement_azuread"></a> [azuread](#requirement_azuread)             | >=2.36.0 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement_azuredevops) | >=0.4.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm)             | >=3.46.0 |

## Inputs

| Name                                                                                                            | Description                                                          | Type                                                                                                                                  | Default | Required |
| --------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_devops_project_name"></a> [devops_project_name](#input_devops_project_name)                      | Name of the DevOps Project to create the service connections for.    | `string`                                                                                                                              | n/a     |   yes    |
| <a name="input_devops_service_url"></a> [devops_service_url](#input_devops_service_url)                         | Azure DevOps organization url.                                       | `string`                                                                                                                              | n/a     |   yes    |
| <a name="input_management_subscription_id"></a> [management_subscription_id](#input_management_subscription_id) | Subscription ID of the Management Subscription                       | `string`                                                                                                                              | n/a     |   yes    |
| <a name="input_personal_access_token"></a> [personal_access_token](#input_personal_access_token)                | PAT to use.                                                          | `string`                                                                                                                              | n/a     |   yes    |
| <a name="input_subscription_id"></a> [subscription_id](#input_subscription_id)                                  | Subscription ID of the Landing Zone Subscription                     | `string`                                                                                                                              | n/a     |   yes    |
| <a name="input_tenant_id"></a> [tenant_id](#input_tenant_id)                                                    | Tenant of the Customer                                               | `string`                                                                                                                              | n/a     |   yes    |
| <a name="input_terraform_state_config"></a> [terraform_state_config](#input_terraform_state_config)             | n/a                                                                  | <pre>object({<br> resource_group_name = string<br> storage_account_name = string<br> backend_service_connection = string<br> })</pre> | n/a     |   yes    |
| <a name="input_management_group_id"></a> [management_group_id](#input_management_group_id)                      | Management Group ID. Optional Parameter if association already done. | `string`                                                                                                                              | `""`    |    no    |

## Outputs

No outputs.

## Resource types

| Type                                                                                                                                                                           | Used |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- |
| [azuread_application](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application)                                                             | 1    |
| [azuread_application_password](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password)                                           | 1    |
| [azuread_service_principal](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal)                                                 | 1    |
| [azuredevops_branch_policy_build_validation](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/branch_policy_build_validation)               | 1    |
| [azuredevops_build_definition](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/build_definition)                                           | 1    |
| [azuredevops_environment](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/environment)                                                     | 1    |
| [azuredevops_git_repository](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository)                                               | 1    |
| [azuredevops_git_repository_branch](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_branch)                                 | 1    |
| [azuredevops_git_repository_file](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file)                                     | 1    |
| [azuredevops_serviceendpoint_azurerm](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm)                             | 1    |
| [azurerm_management_group_subscription_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_subscription_association) | 1    |
| [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)                                                 | 1    |

**`Used` only includes resource blocks.** `for_each` and `count` meta arguments, as well as resource blocks of modules are not considered.

## Modules

No modules.

## Resources by Files

### build_validation.tf

| Name                                                                                                                                                                  | Type     |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azuredevops_branch_policy_build_validation.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/branch_policy_build_validation) | resource |

### main.tf

| Name                                                                                                                                                                                  | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [azurerm_management_group_subscription_association.target](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_subscription_association) | resource    |
| [azurerm_storage_container.landing_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)                                           | resource    |
| [azurerm_management_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group)                                                  | data source |
| [azurerm_storage_account.terraform_state](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account)                                         | data source |

### pipeline.tf

| Name                                                                                                                                      | Type     |
| ----------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azuredevops_build_definition.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/build_definition) | resource |
| [azuredevops_environment.alz](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/environment)            | resource |

### repository.tf

| Name                                                                                                                                                | Type     |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azuredevops_git_repository.landing_zone](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository)       | resource |
| [azuredevops_git_repository_branch.init](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_branch) | resource |
| [azuredevops_git_repository_file.pipeline](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |

### service_connection.tf

| Name                                                                                                                                                    | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application)                                 | resource |
| [azuread_application_password.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password)               | resource |
| [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal)                     | resource |
| [azuredevops_serviceendpoint_azurerm.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm) | resource |

### terraform.tf

| Name                                                                                                                         | Type        |
| ---------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [azuredevops_project.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project)   | data source |
| [azurerm_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

<!-- END_TF_DOCS -->
