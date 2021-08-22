

resource "azurerm_resource_group" "test" {
 name     = var.resource_group
 location = var.location
}

resource "azurerm_virtual_network" "test" {
 name                = var.Vnetname
 address_space       = ["10.0.0.0/16"]
 location            = azurerm_resource_group.test.location
 resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_subnet" "test2" {
 name                 = var.subnet2
 resource_group_name  = azurerm_resource_group.test.name
 virtual_network_name = azurerm_virtual_network.test.name
 address_prefixes =[ "10.0.3.0/24" ]
}

resource "azurerm_public_ip" "test" {
 name                         = var.Publicipapp
 location            = azurerm_resource_group.test.location
 resource_group_name = azurerm_resource_group.test.name
 allocation_method            = "Static"
}

resource "azurerm_lb" "test" {
 name                = var.loadbalancervarapp
 location            = azurerm_resource_group.test.location
 resource_group_name = azurerm_resource_group.test.name

 frontend_ip_configuration {
   name                 = "publicIPAddress"
   public_ip_address_id = azurerm_public_ip.test.id
 }
}

resource "azurerm_lb_backend_address_pool" "test" {
 resource_group_name = azurerm_resource_group.test.name
 loadbalancer_id     = azurerm_lb.test.id
 name                = "BackEndAddressPool"
}

resource "azurerm_network_interface" "test" {
 count               = 2
 name                = "acctni${count.index}"
 location            = azurerm_resource_group.test.location
 resource_group_name = azurerm_resource_group.test.name

 ip_configuration {
   name                          = "testConfiguration"
   subnet_id                     = azurerm_subnet.test.id
   private_ip_address_allocation = "dynamic"
 }
}

resource "azurerm_managed_disk" "test" {
 count                = 2
 name                 = "datadisk_existing_${count.index}"
 location             = azurerm_resource_group.test.location
 resource_group_name  = azurerm_resource_group.test.name
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "1023"
}

resource "azurerm_availability_set" "avset" {
 name                         = "avset"
 location                     = azurerm_resource_group.test.location
 resource_group_name          = azurerm_resource_group.test.name
 platform_fault_domain_count  = 2
 platform_update_domain_count = 2
 managed                      = true
}

resource "azurerm_windows_virtual_machine" "test" {
 count                 = 2
 name                  = "WebVM${count.index}"
 location              = azurerm_resource_group.test.location
 availability_set_id   = azurerm_availability_set.avset.id
 resource_group_name   = azurerm_resource_group.test.name
 network_interface_ids = [element(azurerm_network_interface.test.*.id, count.index)]
 size               = "Standard_F2"
 admin_username      = "adminuser"
 admin_password      = "P@$$w0rd1234!"

 # Uncomment this line to delete the OS disk automatically when deleting the VM
 # delete_os_disk_on_termination = true

 # Uncomment this line to delete the data disks automatically when deleting the VM
 # delete_data_disks_on_termination = true



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

 tags = {
   environment = "Production"
 }
}