terraform {
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
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
}
data "azurerm_resource_group" "AZrg101" {
    name = "AZrg1011"
}
# ✅ App Service Plan
resource "azurerm_service_plan" "plan" {
  name                = "internal-app-plan"
  resource_group_name = data.azurerm_resource_group.AZrg101.name
  location            = data.azurerm_resource_group.AZrg101.location
  os_type             = "Windows"
  sku_name            = "F1"
}

# ✅ Web App (Windows)
resource "azurerm_windows_web_app" "WebApp101" {
  name                = "internal-webapp-demo"
  resource_group_name = data.azurerm_resource_group.AZrg101.name
  location            = data.azurerm_resource_group.AZrg101.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    minimum_tls_version = "1.2"
  }

  https_only = true
}

# ✅ Private Endpoint (restrict Web App inside VNet only)
resource "azurerm_private_endpoint" "pe101" {
  name                = "webapp-private-endpoint"
  location            = data.azurerm_resource_group.AZrg101.location
  resource_group_name = data.azurerm_resource_group.AZrg101.name
  subnet_id           = var.XYZ_subnet_id # existing subnet id to fetch from keyvault

  private_service_connection {
    name                           = "webapp-privateservice"
    private_connection_resource_id = azurerm_windows_web_app.WebApp101.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}