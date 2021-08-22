# azure service principal info
variable "subscription_id" {
  default = "*****************"
}

# client_id or app_id
variable "client_id" {
  default = "*****************"
}

variable "client_secret" {
  default = "*****************"
}

# tenant_id or directory_id
variable "tenant_id" {
  default = "*****************"
}

# admin password
variable "admin_username" {
  default = "azureuser"
}

variable "admin_keydata" {
  default = "Terra@prasanna123"
}

variable "admin_password" {
  default = "Terra@prasanna123"
}

# service variables
variable "prefix" {
  default = "prasademo"
}

variable "location" {
  default = "eastus"
}

variable "vmsize" {
  default = "Standard_F2"
}



variable "webcount" {
  default = 2
}

variable "appcount" {
  default = 2
}

variable "dbcount" {
  default = 2
}



variable "systemtag" {
    type = string
    default = "Production"
    description = "Name of the system or environment"
}
