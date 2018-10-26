#============================================================================================
# Output: FQDN of LB
#============================================================================================
output "app_fqdn" {
  value = "${azurerm_public_ip.lbpip.fqdn}"
}
output "db_fqdn" {
  value = "${azurerm_mysql_server.db-server.fqdn}"
}
output "db_shortname" {
  value = "${azurerm_mysql_server.db-server.name}"
}
output "db_user" {
  value = "${var.db_mysql_admin_login}"
}
output "db_password" {
    value     = "${var.db_mysql_admin_password}"
    sensitive = true
}
output "db_name" {
  value = "${var.db_name}"
}
