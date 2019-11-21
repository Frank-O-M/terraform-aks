resource "azurerm_kubernetes_cluster" "default" {
  count               = "${var.env_count}"
  name                = "${var.name}-aks-${count.index}"
  location            = "${element(azurerm_resource_group.default.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.default.*.name, count.index)}"
  dns_prefix          = "${var.dns_prefix}-${var.name}-aks-${var.environment}-${count.index}"
  depends_on          = ["azurerm_role_assignment.aks_network", "azurerm_role_assignment.aks_acr"]

  agent_pool_profile {
    name            = "default"
    count           = "${var.node_count}"
    vm_size         = "${var.node_type}"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${element(azuread_application.default.*.application_id, count.index)}"
    client_secret = "${element(azuread_service_principal_password.default.*.value, count.index)}"
  }

  role_based_access_control {
    enabled = true
  }
}
