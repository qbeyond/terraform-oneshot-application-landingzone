terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      #version = ">=0.4.0"
      version = ">=1.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      #version = ">=2.36.0"
      version = "~> 2.39.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      #version = "~>3.63"
      #version = ">=3.90.0"
      version = ">= 4.0.0"
    }
    http-full = {
      source  = "salrashid123/http-full"
      #version = "~>1.3"
      version = "1.3.1"
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