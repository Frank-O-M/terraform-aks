locals {
  acr_name = "${replace(var.dns_prefix, "-", "")}${replace(var.name, "-", "")}acr"
}
resource "azurerm_container_registry" "default" {
  count               = "${var.env_count}"
  name                = "${local.acr_name}${count.index}"
  resource_group_name = "${element(azurerm_resource_group.default.*.name, count.index)}"
  location            = "${element(azurerm_resource_group.default.*.location, count.index)}"
  sku                 = "Standard"
  admin_enabled       = false
}
