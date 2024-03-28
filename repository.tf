resource "azuredevops_git_repository" "landing_zone" {
  project_id     = data.azuredevops_project.this.id
  name           = data.azurerm_subscription.this.display_name
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
  content = templatefile("${path.module}/templates/azure-pipeline.tftpl", {
    service_connection_tf_state         = var.terraform_state_config.backend_service_connection
    service_connection                  = module.service_connection_application.service_endpoint.service_endpoint_name
    storage_account_resource_group_name = var.terraform_state_config.resource_group_name
    storage_account_name                = var.terraform_state_config.storage_account_name
    container_name                      = lower(data.azurerm_subscription.this.display_name)
    environment                         = azuredevops_environment.alz.name
    stage                               = var.stage
    subscription_name                   = data.azurerm_subscription.this.display_name
  })
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add Pipeline Configuration"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}

resource "azuredevops_git_repository_file" "main" {
  repository_id       = azuredevops_git_repository.landing_zone.id
  file                = "main.tf"
  content             = templatefile("${path.module}/templates/main.tftpl", {})
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add main.tf"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}

resource "azuredevops_git_repository_file" "locals" {
  repository_id = azuredevops_git_repository.landing_zone.id
  file          = "locals.tf"
  content = templatefile("${path.module}/templates/locals.tftpl", {
    location                  = var.location
    subscription_logical_name = split("-", data.azurerm_subscription.this.display_name)[1]
  })
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add locals.tf"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}

resource "azuredevops_git_repository_file" "terraform" {
  repository_id = azuredevops_git_repository.landing_zone.id
  file          = "terraform.tf"
  content = templatefile("${path.module}/templates/terraform.tftpl", {
    skip_provider_registration = var.skip_provider_registration
  })
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add terraform.tf"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}

resource "azuredevops_git_repository_file" "tags" {
  repository_id = azuredevops_git_repository.landing_zone.id
  file          = "tags.tf"
  content = templatefile("${path.module}/templates/tags.tftpl", {
    tags = local.tags
  })
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add tags.tf"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}

resource "azuredevops_git_repository_file" "network" {
  count         = var.vnet_config == null ? 0 : 1
  repository_id = azuredevops_git_repository.landing_zone.id
  file          = "network.tf"
  content = templatefile("${path.module}/templates/network.tftpl", {
    vnet_config = var.vnet_config
    stage       = var.stage
  })
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add network.tf"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}

resource "azuredevops_git_repository_file" "virtual_machine" {
  count         = var.create_virtual_machine_template == true ? 1 : 0
  repository_id = azuredevops_git_repository.landing_zone.id
  file          = "virtual_machine_template.tf"
  content = templatefile("${path.module}/templates/virtual_machine.tftpl", {
    stage = var.stage
  })
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add virtual_machine_template.tf"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}

resource "azuredevops_git_repository_file" "gitignore" {
  repository_id       = azuredevops_git_repository.landing_zone.id
  file                = ".gitignore.tf"
  content             = file("${path.module}/templates/gitignore")
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add .gitignore"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}
