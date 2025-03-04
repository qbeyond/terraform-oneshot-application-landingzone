terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~>0.4"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.36"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.117"
    }
    http-full = {
      source  = "salrashid123/http-full"
      version = "~>1.3"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.devops_subscription_id
}

provider "azuread" {
}

provider "azuredevops" {
  org_service_url       = var.devops_service_url
  personal_access_token = var.personal_access_token
}

data "azuredevops_project" "this" {
  name = var.devops_project_name
}

data "azurerm_subscription" "this" {
  subscription_id = var.subscription_id
}