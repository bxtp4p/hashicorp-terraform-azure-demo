#============================================================================================
# Resource: Availability Set
#============================================================================================
resource "azurerm_availability_set" "avset" {
  name                         = "${var.rg_prefix}-fe-avset"
  location                     = "${var.az_location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

#============================================================================================
# Resource: VM NIC
#============================================================================================
resource "azurerm_network_interface" "nic" {
# NIC Configuration

  name                  = "${var.rg_prefix}-nic-${count.index}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  count                 = "${var.vm_count}"

  ip_configuration {
    name                                    = "ip-config"
    private_ip_address_allocation           = "Dynamic"
    subnet_id                               = "${azurerm_subnet.internal.id}"
  }
}


resource "azurerm_network_interface_nat_rule_association" "nat_nic_rule" {
  count                 = "${var.vm_count}"
  network_interface_id  = "${element(azurerm_network_interface.nic.*.id, count.index)}"
  ip_configuration_name = "ip-config"
  nat_rule_id           = "${element(azurerm_lb_nat_rule.ssh.*.id, count.index)}"
}

#============================================================================================
# Resource: VM
#============================================================================================
resource "azurerm_virtual_machine" "vm" {
  name                              = "${var.rg_prefix}-vm-${count.index}"
  location                          = "${azurerm_resource_group.rg.location}"
  resource_group_name               = "${azurerm_resource_group.rg.name}"
  availability_set_id               = "${azurerm_availability_set.avset.id}"
  network_interface_ids             = ["${element(azurerm_network_interface.nic.*.id, count.index)}"]
  vm_size                           = "${var.vm_size}"
  count                             = "${var.vm_count}"
  delete_os_disk_on_termination     = true

  os_profile {
    # This block is required for all VMs
    computer_name                   = "${var.rg_prefix}-vm-${count.index}"
    admin_username                  = "${var.vm_admin_username}"
  }
  
  os_profile_linux_config {
    #This configuration block is required for Linux VMs
    disable_password_authentication = true
    ssh_keys {
      key_data = "${file(var.vm_ssh_public_key)}"
      path = "/home/${var.vm_admin_username}/.ssh/authorized_keys" 
    }
  }

  storage_image_reference {
    # Sets up the image/os to use for this VM

    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  storage_os_disk {
    # Sets up the managed disk that the OS will be installed on
    name              = "${var.rg_prefix}-osdisk-${count.index}"
    create_option     = "FromImage"
  }

  connection {
    type        = "ssh"
    user        = "${var.vm_admin_username}"
    private_key = "${file(var.vm_ssh_private_key)}"
    host        = "${azurerm_public_ip.lbpip.fqdn}"
    port        = "${element(azurerm_lb_nat_rule.ssh.*.frontend_port,count.index)}"
  }

  provisioner "remote-exec" {
    # This provisioner is used to install java
    script      = "./provisioner-scripts/vm/init.sh"
    on_failure  = "continue"
  }
}