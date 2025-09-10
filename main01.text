terraform {
  backend "azurerm" {
    resource_group_name = "AZrg1011"
    storage_account_name = "storageweb1010"
    container_name = "qatfstate"
    key = "terraform.qatfstate"
    # access_key reads from environment variables
  }
  required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "4.27.0"
    }
  }
}
provider "azurerm" {
  # Configuration options
    features {
    }
    # no need any subscription details
    # subscription_id = $(ARM_SUBSCRIPTION_ID), client_id = $(ARM_CLIENT_SECRET), client_secret = $(ARM_CLIENT_SECRET), tenant_id = $(ARM_CLIENT_SECRET)
}
resource "azurerm_resource_group" "AZrg103" {
    name = "AZrg1031"
    location = "Central US"
    tags = {
        "name" = "RG1031"
    }
}
resource "azurerm_service_plan" "AZappSP103" {
    name = "devAZappplan1031"
    resource_group_name = azurerm_resource_group.AZrg103.name
    location = azurerm_resource_group.AZrg103.location
    sku_name = "S1"
    os_type = "Windows"
    tags = {
        "name" = "SP1031"
    }
  
}
resource "azurerm_windows_web_app" "AZwebapp103" {
    name = "AZwedapp1031"
    resource_group_name = azurerm_resource_group.AZrg103.name
    location = azurerm_resource_group.AZrg103.location
    service_plan_id = azurerm_service_plan.AZappSP103.id
    depends_on = [ azurerm_service_plan.AZappSP103 ]
    site_config {
      
    }
    tags = {
        "name" = "WebApp1031"
    }
}
