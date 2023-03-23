resource "azuredevops_git_repository" "landing_zone" {
  project_id = data.azuredevops_project.this.id
  name       = data.azurerm_subscription.this.display_name
  default_branch = "refs/heads/main"
  initialization {
    init_type = "Clean"
  }
}

resource "azuredevops_git_repository_branch" "init" {
  repository_id = azuredevops_git_repository.landing_zone.id
  name          = "feature/init"
  ref_branch    = azuredevops_git_repository.landing_zone.default_branch
}

resource "azuredevops_git_repository_file" "pipeline" {
  repository_id = azuredevops_git_repository.landing_zone.id
  file          = "azure-pipelines.yml"
  content       = templatefile("${path.module}/assets/azure-pipeline.tftpl", {
    service_connection_tf_state         = var.terraform_state_config.backend_service_connection
    service_connection                  = "sc-azurerm-${data.azurerm_subscription.this.display_name}"
    storage_account_resource_group_name = var.terraform_state_config.resource_group_name
    storage_account_name                = var.terraform_state_config.storage_account_name
    container_name                      = lower(data.azurerm_subscription.this.display_name)
    environment                         = data.azurerm_subscription.this.display_name
  })
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add Pipeline Configuration"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}