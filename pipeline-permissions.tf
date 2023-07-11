locals {
  request_headers = {
    Content-Type = "application/json"
    Authorization = "Basic ${base64encode(":${var.personal_access_token}")}"
  }
}

data "azuredevops_team" "default" {
  project_id = azuredevops_project.this.id
  name       = "${azuredevops_project.this.name} Team"
}

data "http" "approval_and_check_alz" {
  provider = http-full
  method = "POST"
  url = "${var.devops_service_url}/${azuredevops_project.this.id}/_apis/pipelines/checks/configurations?api-version=7.0-preview.1"

  request_headers = local.request_headers

  request_body = jsonencode(
    {
      type = {
        id = "8c6f20a7-a545-4486-9777-f762fafe0d4d"
        name = "Approval"
      }
      settings = {
        approvers = [
          {
            displayName = data.azuredevops_team.default.name,
            id = data.azuredevops_team.default.id
          }
        ]
        executionOrder = "anyOrder"
        instructions = ""
        blockedApprovers = []
        minRequiredApprovers = 1
        requesterCannotBeApprover = false
      }
      resource = {
        type = "environment"
        id = azuredevops_environment.alz.id
        name = azuredevops_environment.alz.name
      }
      timeout = 43200
    }
  )
}

data "http" "environment_permission_alz" {
  provider = http-full
  method = "PATCH"
  url = "${var.devops_service_url}/${azuredevops_project.this.id}/_apis/pipelines/pipelinepermissions/environment/${azuredevops_environment.this.id}?api-version=7.0-preview.1"
  
  request_headers = local.request_headers
  request_body = jsonencode(
    {
      pipelines = [
        {
          id = azuredevops_build_definition.this.id
          authorized = true
        }
      ]
    }
  )
}

resource "azuredevops_resource_authorization" "service_connection_permission_alz" {
  project_id  = azuredevops_project.this.id
  definition_id = azuredevops_build_definition.this.id
  resource_id = module.service_connection_alz.service_endpoint.id
  authorized  = true
}

data "http" "environment_user_permission_alz" {
  provider = http-full
  method = "PUT"
  url = "${var.devops_service_url}/_apis/securityroles/scopes/distributedtask.environmentreferencerole/roleassignments/resources/${azuredevops_project.alz.id}_${azuredevops_environment.alz.id}?api-version=7.0-preview.1"
  
  request_headers = local.request_headers
  request_body = jsonencode(
    [
      {
        userId = data.azuredevops_team.default.id
        roleName = "Administrator"
      }
    ]
  )
}