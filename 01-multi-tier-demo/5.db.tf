#============================================================================================
# Resource: MySQL Server
#============================================================================================
resource "azurerm_mysql_server" "db-server" {
  name                = "${var.rg_prefix}-mysql-server"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  sku {
    name      = "GP_Gen5_2"
    capacity  = 2
    tier      = "GeneralPurpose"
    family    = "Gen5"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login           = "${var.db_mysql_admin_login}"
  administrator_login_password  = "${var.db_mysql_admin_password}"
  version                       = "5.7"
  ssl_enforcement               = "Disabled"
}





#============================================================================================
# Resource: MySQL Server VNET Rule - Allow traffic only from this VNET
#============================================================================================
resource "azurerm_mysql_virtual_network_rule" "db-vnet-rule" {
  name                = "mysql-vnet-rule"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  server_name         = "${azurerm_mysql_server.db-server.name}"
  subnet_id           = "${azurerm_subnet.internal.id}"
}




#============================================================================================
# Resource: DB Server Firewall Allowed IPs
#============================================================================================
resource "azurerm_mysql_firewall_rule" "db-ip-rule" {
  name                = "corporate"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  server_name         = "${azurerm_mysql_server.db-server.name}"
  start_ip_address    = "${var.db_ip_allowed_start}"
  end_ip_address      = "${var.db_ip_allowed_end}"
}





#============================================================================================
# Resource: MySQL DB - Application DB
#============================================================================================
resource "azurerm_mysql_database" "db" {
  name                = "${var.db_name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  server_name         = "${azurerm_mysql_server.db-server.name}"
  charset             = "${var.db_charset}"
  collation           = "${var.db_collation}"  
  

  provisioner "local-exec" {
    command = "${var.db_init_db_script}"

    environment {
      DB_FQDN       = "${azurerm_mysql_server.db-server.fqdn}"
      DB_USER       = "${var.db_mysql_admin_login}"
      DB_PASSWORD   = "${var.db_mysql_admin_password}"
      DB_NAME       = "${var.db_name}"
      DB_SHORTNAME  = "${azurerm_mysql_server.db-server.name}"
    }
  }
}