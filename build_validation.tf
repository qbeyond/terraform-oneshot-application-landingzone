resource "azuredevops_branch_policy_build_validation" "this" {
  project_id = data.azuredevops_project.this.project_id

  settings {
    display_name                = data.azurerm_subscription.this.display_name
    build_definition_id         = azuredevops_build_definition.this.id
    valid_duration              = 0
    queue_on_source_update_only = false

    scope {
      repository_id  = azuredevops_git_repository.landing_zone.id
      match_type     = "Exact"
      repository_ref = "refs/heads/main"
    }
  }
}
