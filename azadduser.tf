resource "azuread_user" "default" {
  count               = "${var.env_count}"
  user_principal_name = "${var.user_name}${count.index}@${var.domain}"
  display_name        = "${var.user_name}${count.index}"
  password            = "${var.user_password}${count.index}"
}

resource "azurerm_role_assignment" "user_rg" {
  count                = "${var.env_count}"
  scope                = "${data.azurerm_subscription.current.id}/resourceGroups/${element(azurerm_resource_group.default.*.name, count.index)}"
  role_definition_name = "Owner"
  principal_id         = "${element(azuread_user.default.*.id, count.index)}"
  depends_on           = ["azurerm_resource_group.default"]
}
