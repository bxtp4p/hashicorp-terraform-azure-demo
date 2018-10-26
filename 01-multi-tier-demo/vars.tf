#============================================================================================
# General Azure Variables
#============================================================================================
variable "az_subscription_id" {}

variable "az_tenant_id" {}

variable "az_client_id" {}

variable "az_client_secret" {}

variable "az_location" { 
  default = "North Central US"
}

variable "rg_prefix" {
  description = "The prefix to use when naming the resources created in Azure."
}

variable "nsg_ssh_address_prefix" {}


#============================================================================================
# VM Variables
#============================================================================================
variable "vm_count" {}
variable "vm_size" {
  default = "Standard_D1_v2"
}
variable "vm_admin_username" {
}

variable "vm_ssh_public_key" {}
variable "vm_ssh_private_key" {}


#============================================================================================
# Load Balancer Variables
#============================================================================================
variable "lb_pip_dns_name" {
  description = "The DNS name to use for the load balancer."
}
variable "lb_frontend_configuration_name" {
  default = "LoadBalancerFrontEnd"
}


#============================================================================================
# Database Variables
#============================================================================================
variable "db_mysql_admin_login" {
  description = "The login name to use for the MySQL admin account."
}

variable "db_mysql_admin_password" {
  description = "The password for the MySQL admin account."
}

variable "db_name" {
  description = "The name of the database to create."
}

variable "db_charset" {
  default = "utf8"
}

variable "db_collation" {
  default = "utf8_unicode_ci"
}

variable "db_ip_allowed_start" {}

variable "db_ip_allowed_end" {}

variable "db_init_db_script" {}