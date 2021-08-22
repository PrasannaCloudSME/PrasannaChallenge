***Azure Instance Metadata Service***

The Azure Instance Metadata Service (IMDS) provides information about currently running virtual machine instances. 
You can use it to manage and configure your virtual machines. 
This information includes the SKU, storage, network configurations, and upcoming maintenance events.
IMDS is a REST API that's available at a well-known, non-routable IP address (169.254.169.254). You can only access it from within the VM. 


**The below script is to execute in azure VM**



Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | ConvertTo-Json | Out-File -FilePath C:\Users\PrasannaAzureVminstance.json




**Below is the output of the above script in Json formate**


{
    "compute":  {
                    "azEnvironment":  "AzurePublicCloud",
                    "customData":  "",
                    "evictionPolicy":  "",
                    "isHostCompatibilityLayerVm":  "false",
                    "licenseType":  "",
                    "location":  "eastus",
                    "name":  "example-vm",
                    "offer":  "WindowsServer",
                    "osProfile":  {
                                      "adminUsername":  "adminuser",
                                      "computerName":  "example-vm",
                                      "disablePasswordAuthentication":  ""
                                  },
                    "osType":  "Windows",
                    "placementGroupId":  "",
                    "plan":  {
                                 "name":  "",
                                 "product":  "",
                                 "publisher":  ""
                             },
                    "platformFaultDomain":  "0",
                    "platformUpdateDomain":  "0",
                    "priority":  "Regular",
                    "provider":  "Microsoft.Compute",
                    "publicKeys":  [

                                   ],
                    "publisher":  "MicrosoftWindowsServer",
                    "resourceGroupName":  "prasannaTerraformRG",
                    "resourceId":  "/subscriptions/95b4f162-1d36-4805-9214-18ade2c3a528/resourceGroups/prasannaTerraformRG/providers/Microsoft.Compute/virtualMachines/example-vm",
                    "securityProfile":  {
                                            "secureBootEnabled":  "false",
                                            "virtualTpmEnabled":  "false"
                                        },
                    "sku":  "2016-Datacenter",
                    "storageProfile":  {
                                           "dataDisks":  "",
                                           "imageReference":  "@{id=; offer=WindowsServer; publisher=MicrosoftWindowsServer; sku=2016-Datacenter; version=latest}",
                                           "osDisk":  "@{caching=ReadWrite; createOption=FromImage; diffDiskSettings=; diskSizeGB=127; encryptionSettings=; image=; managedDisk=; name=example-vm_OsDisk_1_da18d866d72c4b99a944944dee231f37; osType=Windows; vhd=; writeAcceleratorEnabled=false}",
                                           "resourceDisk":  "@{size=32768}"
                                       },
                    "subscriptionId":  "95b4f162-1d36-4805-9214-18ade2c3a528",
                    "tags":  "Cost Center:Shared Service;Environment:Development;Owner:Prasanna;Project:infrastructure as a code",
                    "tagsList":  [
                                     "@{name=Cost Center; value=Shared Service}",
                                     "@{name=Environment; value=Development}",
                                     "@{name=Owner; value=Prasanna}",
                                     "@{name=Project; value=infrastructure as a code}"
                                 ],
                    "userData":  "",
                    "version":  "14393.4583.2108010852",
                    "vmId":  "7f924adc-3f24-4bdc-828e-3a41c1097362",
                    "vmScaleSetName":  "",
                    "vmSize":  "Standard_F2",
                    "zone":  ""
                },
    "network":  {
                    "interface":  [
                                      "@{ipv4=; ipv6=; macAddress=0022481DDE8E}"
                                  ]
                }
}




