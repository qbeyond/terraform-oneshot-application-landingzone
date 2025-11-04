data "azurerm_management_group" "this" {
  count = var.management_group_id == "" ? 0 : 1
  name  = var.management_group_id
}

resource "azurerm_management_group_subscription_association" "target" {
  count               = var.management_group_id == "" ? 0 : 1
  management_group_id = data.azurerm_management_group.this[count.index].id
  subscription_id     = data.azurerm_subscription.this.id
}

data "azurerm_storage_account" "terraform_state" {
  name                = var.terraform_state_config.storage_account_id
  resource_group_name = var.terraform_state_config.resource_group_name
}

resource "azurerm_storage_container" "landing_zone" {
  name                  = lower(data.azurerm_subscription.this.display_name)
  storage_account_id    = data.azurerm_storage_account.terraform_state.id
  container_access_type = "private"
}
