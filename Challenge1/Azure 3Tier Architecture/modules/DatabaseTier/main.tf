

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
resource "azurerm_subnet" "test3" {
 name                 = var.subnet3
 resource_group_name  = azurerm_resource_group.test.name
 virtual_network_name = azurerm_virtual_network.test.name
 address_prefixes =[ "10.0.4.0/24" ]
}



resource "azurerm_public_ip" "test" {
 name                         = var.PublicipDB
 location                     = azurerm_resource_group.test.location
 resource_group_name          = azurerm_resource_group.test.name
 allocation_method            = "Static"
}

resource "azurerm_lb" "test" {
 name                = var.loadbalancervarDB
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
resource "azurerm_storage_account" "example" {
  name                     = "prachalenge3241"
  resource_group_name   = azurerm_resource_group.test.name
  location              = azurerm_resource_group.test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_sql_server" "test" {
 count                 = 2
 name                  = "mssqlserver${count.index}"
 location              = azurerm_resource_group.test.location
 
 resource_group_name   = azurerm_resource_group.test.name
 
 version                      = "12.0"
  administrator_login          = "mradministrator"
  administrator_login_password = "thisIsDog11"

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.example.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.example.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }

  tags = {
    environment = "production"
  }
}