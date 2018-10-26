#============================================================================================
# Resource: Load Balancer Public IP
#============================================================================================
resource "azurerm_public_ip" "lbpip" {
  name                         = "${var.rg_prefix}-lbpip"
  location                     = "${var.az_location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "Dynamic"
  domain_name_label            = "${var.lb_pip_dns_name}"
}





#============================================================================================
# Resource: Load Balancer 
#============================================================================================
resource "azurerm_lb" "lb" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  name                = "${var.rg_prefix}-lb"
  location            = "${var.az_location}"

  frontend_ip_configuration {
    name                 = "${var.lb_frontend_configuration_name}"
    public_ip_address_id = "${azurerm_public_ip.lbpip.id}"
  }
}





#============================================================================================
# Resource: Load Balancer Backend Address Pool (VMs)
#============================================================================================
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.lb.id}"
  name                = "BackendAddressPool"
}





#============================================================================================
# Resource: Load Balancer Health Probe
#============================================================================================
resource "azurerm_lb_probe" "lb_probe" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.lb.id}"
  name                = "tcpProbe"
  protocol            = "tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}






#============================================================================================
# Resource: Load Balancer Rule - Allow Port 80 Traffic
#============================================================================================
resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.lb.id}"
  name                           = "Port-80"
  protocol                       = "tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.lb_frontend_configuration_name}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
}






#============================================================================================
# Resource: Load Balancer NAT Rule - Allow SSH into VMs
#============================================================================================
resource "azurerm_lb_nat_rule" "ssh" {
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.lb.id}"
  name                           = "ssh-vm-${count.index}"
  protocol                       = "tcp"
  frontend_port                  = "5000${count.index}" # e.g., 50000, 500001, etc.
  backend_port                   = 22
  frontend_ip_configuration_name = "${var.lb_frontend_configuration_name}"
  count                          = "${var.vm_count}"
}





#============================================================================================
# Resource: Load Balancer Backend Address Pool Association to VM Nics
#============================================================================================
resource "azurerm_network_interface_backend_address_pool_association" "lb_backend_pool_nic_association" {
  network_interface_id        = "${element(azurerm_network_interface.nic.*.id, count.index)}"
  ip_configuration_name       = "ip-config"
  backend_address_pool_id     = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  count                       = "${var.vm_count}"
}