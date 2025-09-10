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
resource "azurerm_resource_group" "AZrg103" {
    name = "AZrg1031"
    location = "Central US"
}
# ✅ App Service Plan
resource "azurerm_service_plan" "plan101" {
    name                = "internal-app-plan"
    resource_group_name = azurerm_resource_group.AZrg103.name
    location            = azurerm_resource_group.AZrg103.location
    os_type             = "Windows"
    sku_name            = "S1"
      tags = {
        "name" = "SP1031"
    }
}

# ✅ Web App (Windows) with IP restriction
resource "azurerm_windows_web_app" "WebApp101" {
  name                = "internal-webapp-demo"
  resource_group_name = azurerm_resource_group.AZrg103.name
  location            = azurerm_resource_group.AZrg103.location
  service_plan_id     = azurerm_service_plan.plan101.id
  depends_on = [ azurerm_service_plan.plan101 ]
  site_config {
    minimum_tls_version = "1.2"
    # IP Restriction
    ip_restriction {
      ip_address = "106.222.228.233/32" # Replace with your VPN/VM public IP
      action     = "Allow"
      priority   = 100
      name       = "VPN_Only"
    }

    ip_restriction {
      ip_address = "0.0.0.0/0"
      action     = "Deny"
      priority   = 200
      name       = "DenyAll"
    }
  }
  https_only = true
}