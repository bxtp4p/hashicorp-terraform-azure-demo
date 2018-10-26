#============================================================================================
# Resource: Network Security Group for VMs
#============================================================================================
resource "azurerm_network_security_group" "vm-nsg" {
  name                = "${var.rg_prefix}-vm-nsg"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${var.nsg_ssh_address_prefix}"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"

  }
}





#============================================================================================
# Resource: NSG to Internal Subnet Association
#============================================================================================
resource "azurerm_subnet_network_security_group_association" "nsg_internal_subnet_association" {
  subnet_id                 = "${azurerm_subnet.internal.id}"
  network_security_group_id = "${azurerm_network_security_group.vm-nsg.id}"
}