locals {
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Basic ${base64encode(":${var.personal_access_token}")}"
  }
}

data "azuredevops_team" "default" {
  project_id = data.azuredevops_project.this.id
  name       = "${data.azuredevops_project.this.name} Team"
}

resource "azuredevops_check_approval" "this" {
  project_id           = data.azuredevops_project.this.id
  target_resource_id   = azuredevops_environment.alz.id
  target_resource_type = "environment"

  minimum_required_approvers = 1
  requester_can_approve      = true
  approvers                  = [data.azuredevops_team.default.id]

  timeout = 43200
  lifecycle {
    ignore_changes = [
      approvers
    ]
  }
}

resource "azuredevops_pipeline_authorization" "environment_permission_alz" {
  project_id  = data.azuredevops_project.this.id
  resource_id = azuredevops_environment.alz.id
  pipeline_id = azuredevops_build_definition.this.id
  type        = "environment"
}

# Allow the Service connection to be used by the pipeline (Build Definition)
resource "azuredevops_pipeline_authorization" "service_connection_permission_alz" {
  project_id  = data.azuredevops_project.this.id
  resource_id = module.service_connection_application.service_endpoint.id
  pipeline_id = azuredevops_build_definition.this.id
  type        = "endpoint"
}

# Administrative permissions for the group every time a new environment is created
resource "azuredevops_securityrole_assignment" "environment_admin" {
  scope       = "distributedtask.environmentreferencerole"
  resource_id = "${data.azuredevops_project.this.id}_${azuredevops_environment.alz.id}"
  identity_id = data.azuredevops_team.default.id
  role_name   = "Administrator"
  lifecycle {
    ignore_changes = [
      identity_id
    ]
  }
}
