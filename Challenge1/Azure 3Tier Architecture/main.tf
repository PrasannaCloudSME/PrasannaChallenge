terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.73.0"
    }
  }
}

provider "azurerm" {
   subscription_id = "************************"
   client_id       = "************************"
   client_secret   = "************************"
   tenant_id       = "************************"
features {}
   
 }

module "Webtier" {
  source         = "./modules/WebTier"
  
}

module "ApplicationTier" {
  source         = "./modules/ApplicationTier"
  
}

module "DatabaseTier" {
  source         = "./modules/DatabaseTier"
  
}

