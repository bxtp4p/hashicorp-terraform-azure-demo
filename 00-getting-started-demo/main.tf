provider "azurerm" {}

resource "azurerm_resource_group" "demo" {
  name = "${var.rg-name}"
  location = "${var.rg-location}"
}

resource "azurerm_public_ip" "pip" {
  name = "pip"
  location = "${azurerm_resource_group.demo.location}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
  public_ip_address_allocation = "dynamic"
}

variable "rg-name" {
}

variable "rg-location" {
  default = "North Central US"
}
