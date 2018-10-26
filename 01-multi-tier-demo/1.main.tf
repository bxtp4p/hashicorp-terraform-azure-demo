#============================================================================================
# Provider: AzureRM
#============================================================================================
provider "azurerm" {
  # Adding a version constraint to prevent auto-upgrades from introducing breaking changes
  version         = "~> 1.17"

  subscription_id = "${var.az_subscription_id}"
  tenant_id       = "${var.az_tenant_id}"
  client_id       = "${var.az_client_id}"
  client_secret   = "${var.az_client_secret}"
 }




 
#============================================================================================
# Resource: Resource Group
#============================================================================================
resource "azurerm_resource_group" "rg" {
# Resource Group Configuration

  name          = "${var.rg_prefix}-resources"
  location      = "${var.az_location}"
}





#============================================================================================
# Resource: Virtual Network
#============================================================================================
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.rg_prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}





#============================================================================================
# Resource: Internal Subnet
#============================================================================================
resource "azurerm_subnet" "internal" {
  name                        = "${var.rg_prefix}-internal"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  virtual_network_name        = "${azurerm_virtual_network.vnet.name}"
  address_prefix              = "10.0.2.0/24"
  service_endpoints           =["Microsoft.Sql"]
}