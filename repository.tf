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
    terraform_version                   = var.terraform_version
    create_virtual_machine              = var.create_virtual_machine_template
    vm_win_hostname                     = upper(var.vm_win.hostname)
    vm_ux_hostname                      = upper(var.vm_ux.hostname)
    vm_ux_public_key_name               = var.vm_ux.public_key_name
    sql                                 = var.sql
    application_name                    = lower(split("-", data.azurerm_subscription.this.display_name)[1])
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
  content = templatefile("${path.module}/templates/main.tftpl", {
    rg_config = var.rg_config
  })
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
    location         = var.location
    dns_servers      = join("\", \"", var.vnet_config.dns_server)
    stage            = split("-", data.azurerm_subscription.this.display_name)[0]
    application_name = split("-", data.azurerm_subscription.this.display_name)[1]
    env_num          = split("-", data.azurerm_subscription.this.display_name)[2]
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
  content = templatefile("${path.module}/templates/terraform.tftpl", {})
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

resource "azuredevops_git_repository_file" "nsg" {
  count         = var.vnet_config != null && var.vnet_config.nsg == true ? 1 : 0
  repository_id = azuredevops_git_repository.landing_zone.id
  file          = "nsg.tf"
  content = templatefile("${path.module}/templates/nsg.tftpl", {
    vnet_config = var.vnet_config
  })
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add nsg.tf"
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
    sql         = var.sql
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
  count         = var.create_virtual_machine_template == true && (var.vm_win.hostname != "" || var.vm_ux.hostname != "") ? 1 : 0
  repository_id = azuredevops_git_repository.landing_zone.id
  file          = "vm.tf"
  content = templatefile("${path.module}/templates/vm.tftpl", {
    vm_win = var.vm_win
    vm_ux  = var.vm_ux
  })
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add vm template file"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}

resource "azuredevops_git_repository_file" "sql" {
  count         = var.sql.create ? 1 : 0
  repository_id = azuredevops_git_repository.landing_zone.id
  file          = "sql.tf"
  content = templatefile("${path.module}/templates/sql.tftpl", {
    sql              = var.sql
    application_name = lower(split("-", data.azurerm_subscription.this.display_name)[1])
  })
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add sql.tf"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}

resource "azuredevops_git_repository_file" "variables" {
  count = (var.create_virtual_machine_template == true && (var.vm_win.hostname != "" || (var.vm_ux.hostname != "" && var.vm_ux.public_key_name == "" ))) || (var.sql.create) ? 1 : 0
  repository_id = azuredevops_git_repository.landing_zone.id
  file          = "variables.tf"
  content = templatefile("${path.module}/templates/variables.tftpl", {
    vm_win_hostname       = upper(var.vm_win.hostname)
    vm_ux_hostname        = upper(var.vm_ux.hostname)
    vm_ux_public_key_name = var.vm_ux.public_key_name
    sql                   = var.sql
    application_name      = lower(split("-", data.azurerm_subscription.this.display_name)[1])
  })
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add variables template file"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}

resource "azuredevops_git_repository_file" "gitignore" {
  repository_id       = azuredevops_git_repository.landing_zone.id
  file                = ".gitignore"
  content             = file("${path.module}/templates/gitignore")
  branch              = "refs/heads/${azuredevops_git_repository_branch.init.name}"
  commit_message      = "Add .gitignore"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [commit_message]
  }
}