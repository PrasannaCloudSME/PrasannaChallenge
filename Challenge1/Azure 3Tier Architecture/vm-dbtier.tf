# Create Network Security Group and rule
resource "azurerm_network_security_group" "tfdbnsg" {
  name                = "${var.prefix}-dbnsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.tfrg.name}"

  security_rule {
      name                       = "DENY_VNET"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
      name                       = "SSH_VNET"
      priority                   = 4000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
  }

  security_rule {
      name                       = "HTTP_VNET"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "10.0.1.0/24" // replace with ASG later
      destination_address_prefix = "*"
  }

  
}

# Create network interface
resource "azurerm_network_interface" "tfdbnic" {
  count                     = "${var.dbcount}"
  name                      = "${var.prefix}-dbnic${count.index}"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.tfrg.name}"
  

  ip_configuration {
    name                          = "${var.prefix}-dbnic-conf${count.index}"
    subnet_id                     = "${azurerm_subnet.tfdbvnet.id}"
    #private_ip_address_allocation = "dynamic"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${format("10.0.4.%d", count.index + 4)}"
    
  }

  
}

resource "azurerm_availability_set" "tfdbvset" {
  name                        = "${var.prefix}-dbavset"
  location                    = "${var.location}"
  resource_group_name         = "${azurerm_resource_group.tfrg.name}"
  managed                     = "true"
  platform_fault_domain_count = 2  # default 3 cannot be used

}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "tfdbvm" {
  count                 = "${var.dbcount}"
  name                  = "${var.prefix}dbvm${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.tfrg.name}"
  network_interface_ids = ["${azurerm_network_interface.tfdbnic.*.id[count.index]}"]
  availability_set_id   = "${azurerm_availability_set.tfdbvset.id}"
  size               = "${var.vmsize}"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  

  

  /*
  # custom image
  storage_image_reference {
    id = "${var.osimageuri}"
  }
  */

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  
}
resource "azurerm_public_ip" "dbtflbpip" {
  name                         = "${var.prefix}-dbflbpip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.tfrg.name}"
  allocation_method            = "Static"
  sku                          = "Basic" # "Standard"
}
resource "azurerm_lb" "dbtflb" {
  name                = "${var.prefix}dblb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.tfrg.name}"
  sku                 = "Basic" # "Standard"

  frontend_ip_configuration {
    name                 = "dbPublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.dbtflbpip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "dbtflbbackendpool" {
  resource_group_name = "${azurerm_resource_group.tfrg.name}"
  loadbalancer_id     = "${azurerm_lb.dbtflb.id}"
  name                = "dbBackEndAddressPool"
}

resource "azurerm_lb_nat_rule" "dblbnatrule" {
  count                          = "${var.dbcount}"
  resource_group_name            = "${azurerm_resource_group.tfrg.name}"
  loadbalancer_id                = "${azurerm_lb.dbtflb.id}"
  name                           = "ssh-${count.index}"
  protocol                       = "tcp"
  frontend_port                  = "5000${count.index + 1}"
  backend_port                   = 22
  frontend_ip_configuration_name = "dbPublicIPAddress"  # "${azurerm_lb.tflb.frontend_ip_configuration.name}" not working
}

resource "azurerm_lb_rule" "dblb_rule" {
  resource_group_name            = "${azurerm_resource_group.tfrg.name}"
  loadbalancer_id                = "${azurerm_lb.dbtflb.id}"
  name                           = "dbLBRule"
  protocol                       = "tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "dbPublicIPAddress"
  enable_floating_ip             = false
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.dbtflbbackendpool.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.dblb_probe.id}"
  depends_on                     = ["azurerm_lb_probe.dblb_probe"]
}

resource "azurerm_lb_probe" "dblb_probe" {
  resource_group_name = "${azurerm_resource_group.tfrg.name}"
  loadbalancer_id     = "${azurerm_lb.dbtflb.id}"
  name                = "dbtcpProbe"
  protocol            = "tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

output "dblb_pip" {
  value = "${azurerm_public_ip.tflbpip.*.ip_address}"
}