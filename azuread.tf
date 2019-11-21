resource "azuread_application" "default" {
  count = "${var.env_count}"
  name  = "${var.name}-${var.environment}-count.index"
}

resource "azuread_service_principal" "default" {
  count          = "${var.env_count}"
  application_id = "${element(azuread_application.default.*.application_id, count.index)}"
}

resource "random_string" "password" {
  count   = "${var.env_count}"
  length  = 32
  special = true
}

resource "azuread_service_principal_password" "default" {
  count                = "${var.env_count}"
  service_principal_id = "${element(azuread_service_principal.default.*.id, count.index)}"
  value                = "${element(random_string.password.*.result, count.index)}"
  end_date             = "2099-01-01T01:00:00Z"
}

resource "azurerm_role_assignment" "aks_network" {
  count                = "${var.env_count}"
  scope                = "${data.azurerm_subscription.current.id}/resourceGroups/${element(azurerm_resource_group.default.*.name, count.index)}"
  role_definition_name = "Network Contributor"
  principal_id         = "${element(azuread_service_principal.default.*.id, count.index)}"
}

resource "azurerm_role_assignment" "aks_acr" {
  count                = "${var.env_count}"
  scope                = "${data.azurerm_subscription.current.id}/resourceGroups/${element(azurerm_resource_group.default.*.name, count.index)}/providers/Microsoft.ContainerRegistry/registries/${element(azurerm_container_registry.default.*.name, count.index)}"
  role_definition_name = "AcrPull"
  principal_id         = "${element(azuread_service_principal.default.*.id, count.index)}"
}
