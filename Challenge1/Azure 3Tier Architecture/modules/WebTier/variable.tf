variable "resource_group" {
  
  
}
variable "location" {
    
}

variable "Vnetname" {
  
}
variable "subnet1" {

default =  "Webtiersubnet"
  
}

variable "subnet2" {

default =  "Apptiersubnet"
  
}

variable "subnet3" {

default =  "Datatiersubnet"
  
}

variable "Publicip" {
  
  default = "publicIPForLB"
}

variable "loadbalancervar" {

   default = "loadBalancer"  

}

