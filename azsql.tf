resource "azurerm_sql_server" "default" {
  count                        = "${var.env_count}"
  name                         = "azsattestsqlserver${count.index}"
  resource_group_name          = "${element(azurerm_resource_group.default.*.name, count.index)}"
  location                     = "${element(azurerm_resource_group.default.*.location, count.index)}"
  version                      = "12.0"
  administrator_login          = "${var.user_name}${count.index}"
  administrator_login_password = "${var.user_password}-${count.index}"
  depends_on                   = ["azurerm_resource_group.default"]
}

resource "azurerm_sql_database" "default" {
  count                            = "${var.env_count}"
  name                             = "azsattestdatabase${count.index}"
  resource_group_name              = "${element(azurerm_resource_group.default.*.name, count.index)}"
  location                         = "${element(azurerm_resource_group.default.*.location, count.index)}"
  server_name                      = "${element(azurerm_sql_server.default.*.name, count.index)}"
  edition                          = "Standard"
  requested_service_objective_name = "S0"
  depends_on                       = ["azurerm_resource_group.default"]
}
