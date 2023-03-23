resource "azuredevops_build_definition" "this" {
  project_id = data.azuredevops_project.this.id
  name       = data.azurerm_subscription.this.display_name

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.landing_zone.id
    branch_name = azuredevops_git_repository_branch.init.name
    yml_path    = "azure-pipelines.yml"
  }

  depends_on = [
    azuredevops_git_repository_file.pipeline
  ]
}

resource "azuredevops_environment" "alz" {
  description = "Automatically created environment"
  project_id = data.azuredevops_project.this.project_id
  name       = data.azurerm_subscription.this.display_name
}
