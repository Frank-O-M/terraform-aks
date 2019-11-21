# The Azure Active Resource Manager Terraform provider
provider "azurerm" {
  version = "=1.36.0"
}

# The Azure Active Directory Terraform provider
provider "azuread" {
  version = "=0.6.0"
}

# Reference to the current subscription.  Used when creating role assignments
data "azurerm_subscription" "current" {}

# The main resource group for this deployment
resource "azurerm_resource_group" "default" {
  count    = "${var.env_count}"
  name     = "${var.name}-${var.environment}-rg-${count.index}"
  location = "${var.location}"
}
