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

resource "azuredevops_git_repository_file" "main" {
  repository_id = azuredevops_git_repository.landing_zone.id
  file          = "main.tf"
  content       = templatefile("${path.module}/assets/main.tftpl", {})
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add Terraform.tf"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}

resource "azuredevops_git_repository_file" "locals" {
  repository_id = azuredevops_git_repository.landing_zone.id
  file          = "locals.tf"
  content       = templatefile("${path.module}/assets/locals.tftpl", {
    location = var.location
  })
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add Terraform.tf"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}

resource "azuredevops_git_repository_file" "terraform" {
  repository_id = azuredevops_git_repository.landing_zone.id
  file          = "terraform.tf"
  content       = templatefile("${path.module}/assets/terraform.tftpl", {})
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add Terraform.tf"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}

resource "azuredevops_git_repository_file" "vnet" {
  repository_id = azuredevops_git_repository.landing_zone.id
  file          = "vnet.tf"
  content       = templatefile("${path.module}/assets/vnet.tftpl", {
    stage                  = var.stage
    vnet_address_space     = var.alz_vnet_config.vnet_address_space
    snet_address_prefixes  = var.alz_vnet_config.snet_address_prefixes
    snet_usecase           = var.alz_vnet_config.snet_usecase
  })
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add Vnet.tf"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}

resource "azuredevops_branch_policy_min_reviewers" "this" {
  project_id = azuredevops_project.alz.id

  enabled  = true
  blocking = true

  settings {
    reviewer_count                         = 1
    submitter_can_vote                     = false
    last_pusher_cannot_approve             = true
    allow_completion_with_rejects_or_waits = false
    on_push_reset_approved_votes           = true # OR on_push_reset_all_votes = true
    on_last_iteration_require_vote         = false

    scope {
      repository_id  = null # All repositories in the project
      match_type     = "DefaultBranch"
    }
  }
  depends_on = [
    time_sleep.wait_1_minute
  ]
}