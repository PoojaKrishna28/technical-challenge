terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    random = {
        source = "hashicorp/random"
        version = "~>3.1.0"
    }
  }

  
  backend "azurerm" {}

}

provider "azurerm" {
  subscription_id = var.subscription_id  
  features {}
  
}
