terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.73.0"
    }
  }
}

provider "azurerm" {
   subscription_id = "95b4f162-1d36-4805-9214-18ade2c3a528"
   client_id       = "45261193-fba5-47eb-a59a-67141287ddfc"
   client_secret   = "HRulbmErT1l0q0MroR5hUOTiFGNLPgl-v2"
   tenant_id       = "1f49e8e6-d76f-4f6b-8ab5-fb24b5e2c00a"
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

