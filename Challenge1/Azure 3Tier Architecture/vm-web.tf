# Create Network Security Group and rule
resource "azurerm_network_security_group" "tfwebnsg" {
  name                = "${var.prefix}-webnsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.tfrg.name}"

  security_rule {
    name                       = "web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  
}

# Create network interface
resource "azurerm_network_interface" "tfwebnic" {
  count                     = "${var.webcount}"
  name                      = "${var.prefix}-webnic${count.index}"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.tfrg.name}"
  

  ip_configuration {
    name                          = "${var.prefix}-webnic-config${count.index}"
    subnet_id                     = "${azurerm_subnet.tfwebvnet.id}"
    #private_ip_address_allocation = "dynamic"
    private_ip_address_allocation = "Static"
    
    private_ip_address            = "${format("10.0.1.%d", count.index + 4)}"

    
    

    
  }

  
}

resource "azurerm_availability_set" "tfwebavset" {
  name                        = "${var.prefix}-webavset"
  location                    = "${var.location}"
  resource_group_name         = "${azurerm_resource_group.tfrg.name}"
  managed                     = "true"
  platform_fault_domain_count = 2 # default 3 not working in some regions like Korea

  
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "tfwebvm" {
  count                 = "${var.webcount}"
  name                  = "${var.prefix}webvm${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.tfrg.name}"
  network_interface_ids = ["${azurerm_network_interface.tfwebnic.*.id[count.index]}"]
  size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.tfwebavset.id}"
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




resource "azurerm_public_ip" "tflbpip" {
  name                         = "${var.prefix}-flbpip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.tfrg.name}"
  allocation_method            = "Static"
  sku                          = "Basic" # "Standard"
}

resource "azurerm_lb" "tflb" {
  name                = "${var.prefix}lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.tfrg.name}"
  sku                 = "Basic" # "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.tflbpip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "tflbbackendpool" {
  resource_group_name = "${azurerm_resource_group.tfrg.name}"
  loadbalancer_id     = "${azurerm_lb.tflb.id}"
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_nat_rule" "lbnatrule" {
  count                          = "${var.webcount}"
  resource_group_name            = "${azurerm_resource_group.tfrg.name}"
  loadbalancer_id                = "${azurerm_lb.tflb.id}"
  name                           = "ssh-${count.index}"
  protocol                       = "tcp"
  frontend_port                  = "5000${count.index + 1}"
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"  # "${azurerm_lb.tflb.frontend_ip_configuration.name}" not working
}

resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name            = "${azurerm_resource_group.tfrg.name}"
  loadbalancer_id                = "${azurerm_lb.tflb.id}"
  name                           = "LBRule"
  protocol                       = "tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  enable_floating_ip             = false
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.tflbbackendpool.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
  depends_on                     = ["azurerm_lb_probe.lb_probe"]
}

resource "azurerm_lb_probe" "lb_probe" {
  resource_group_name = "${azurerm_resource_group.tfrg.name}"
  loadbalancer_id     = "${azurerm_lb.tflb.id}"
  name                = "tcpProbe"
  protocol            = "tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

output "weblb_pip" {
  value = "${azurerm_public_ip.tflbpip.*.ip_address}"
}
