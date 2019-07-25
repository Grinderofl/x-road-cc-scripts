# X-Road Central Server Installation (Manual)

[TODO] For automated installation, see [readme-arm.md](readme-arm.md)

# Steps

##1) Set up Resource Group in Azure

`x-road-rnd`

##2) Deploy Virtual Machine with Ansible installation script

```json
{
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
            "defaultValue": "[resourceGroup().location]",
            "type": "String",
            "metadata": {
                "description": "Location for all resources."
            }
        },
        "virtualMachineName": {
            "type": "String"
        },
        "virtualMachineSize": {
            "defaultValue": "Standard_DS1_v2",
            "allowedValues": [
                "Standard_B1ms",
                "Standard_B1s",
                "Standard_B2s",
                "Standard_DS1_v2"
            ],
            "type": "String"
        },
        "adminUsername": {
            "type": "String"
        },
        "adminPassword": {
            "type": "SecureString"
        }
    },
    "variables": {
        "nsgId": "[resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', variables('networkSecurityGroupName'))]",
        "vnetId": "[resourceId(resourceGroup().name,'Microsoft.Network/virtualNetworks', variables('virtualNetworkName'))]",
        "subnetRef": "[concat(variables('vnetId'), '/subnets/', variables('subnetName'))]",
        "networkInterfaceName": "ansibleVMnic",
        "networkSecurityGroupName": "ansible-nsg",
        "subnetName": "default",
        "virtualNetworkName": "ansible-vnet",
        "publicIpAddressName": "ansible-ip",
        "publicIpAddressType": "Dynamic",
        "publicIpAddressSku": "Basic",
        "osDiskType": "Premium_LRS"
    },
    "resources": [
        {
            "type": "Microsoft.Network/networkInterfaces",
            "apiVersion": "2018-04-01",
            "name": "[variables('networkInterfaceName')]",
            "location": "[parameters('location')]",
            "dependsOn": [
                "[concat('Microsoft.Network/networkSecurityGroups/', variables('networkSecurityGroupName'))]",
                "[concat('Microsoft.Network/virtualNetworks/', variables('virtualNetworkName'))]",
                "[concat('Microsoft.Network/publicIpAddresses/', variables('publicIpAddressName'))]"
            ],
            "tags": {},
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipconfig1",
                        "properties": {
                            "subnet": {
                                "id": "[variables('subnetRef')]"
                            },
                            "privateIPAllocationMethod": "Dynamic",
                            "publicIpAddress": {
                                "id": "[resourceId(resourceGroup().name, 'Microsoft.Network/publicIpAddresses', variables('publicIpAddressName'))]"
                            }
                        }
                    }
                ],
                "networkSecurityGroup": {
                    "id": "[variables('nsgId')]"
                }
            }
        },
        {
            "type": "Microsoft.Network/networkSecurityGroups",
            "apiVersion": "2018-08-01",
            "name": "[variables('networkSecurityGroupName')]",
            "location": "[parameters('location')]",
            "tags": {},
            "properties": {
                "securityRules": [
                    {
                        "name": "SSH",
                        "properties": {
                            "priority": 300,
                            "protocol": "TCP",
                            "access": "Allow",
                            "direction": "Inbound",
                            "sourceAddressPrefix": "*",
                            "sourcePortRange": "*",
                            "destinationAddressPrefix": "*",
                            "destinationPortRange": "22"
                        }
                    }
                ]
            }
        },
        {
            "type": "Microsoft.Network/virtualNetworks",
            "apiVersion": "2018-08-01",
            "name": "[variables('virtualNetworkName')]",
            "location": "[parameters('location')]",
            "tags": {},
            "properties": {
                "addressSpace": {
                    "addressPrefixes": [
                        "10.0.0.0/24"
                    ]
                },
                "subnets": [
                    {
                        "name": "default",
                        "properties": {
                            "addressPrefix": "10.0.0.0/24"
                        }
                    }
                ]
            }
        },
        {
            "type": "Microsoft.Network/publicIpAddresses",
            "apiVersion": "2018-08-01",
            "name": "[variables('publicIpAddressName')]",
            "location": "[parameters('location')]",
            "tags": {},
            "sku": {
                "name": "[variables('publicIpAddressSku')]"
            },
            "properties": {
                "publicIpAllocationMethod": "[variables('publicIpAddressType')]"
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines",
            "apiVersion": "2018-06-01",
            "name": "[parameters('virtualMachineName')]",
            "location": "[parameters('location')]",
            "dependsOn": [
                "[concat('Microsoft.Network/networkInterfaces/', variables('networkInterfaceName'))]"
            ],
            "tags": {},
            "properties": {
                "hardwareProfile": {
                    "vmSize": "[parameters('virtualMachineSize')]"
                },
                "storageProfile": {
                    "osDisk": {
                        "createOption": "FromImage",
                        "managedDisk": {
                            "storageAccountType": "[variables('osDiskType')]"
                        }
                    },
                    "imageReference": {
                        "publisher": "Canonical",
                        "offer": "UbuntuServer",
                        "sku": "18.04-LTS",
                        "version": "latest"
                    }
                },
                "networkProfile": {
                    "networkInterfaces": [
                        {
                            "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('networkInterfaceName'))]"
                        }
                    ]
                },
                "osProfile": {
                    "computerName": "[parameters('virtualMachineName')]",
                    "adminUsername": "[parameters('adminUsername')]",
                    "adminPassword": "[parameters('adminPassword')]"
                }
            }
        },
        {
            "name": "[concat(parameters('virtualMachineName'),'/CustomScript')]",
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "location": "[parameters('location')]",
            "apiVersion": "2015-06-15",
            "dependsOn": [
                "[concat('Microsoft.Compute/virtualMachines/', parameters('virtualMachineName'))]"
            ],
            "properties": {
                "publisher": "Microsoft.Azure.Extensions",
                "type": "CustomScript",
                "typeHandlerVersion": "2.0",
                "autoUpgradeMinorVersion": true,
                "settings": {
                    "fileUris": [ "https://raw.githubusercontent.com/Microsoft/azuredevopslabs/master/labs/vstsextend/ansible/armtemplate/install_ansible.sh"]
                },
                "protectedSettings" : {
                    "commandToExecute": "sh install_ansible.sh"
                }
            }
        }
    ],
    "outputs": {
        "adminUsername": {
            "type": "string",
            "value": "[parameters('adminUsername')]"
        }
    }
}
```

Template parameters:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
      "location": {
        "value": "[resourceGroup().location]"
      },
      "virtualMachineName": {
        "value": "x-road-cc"
      },
      "virtualMachineSize": {
        "value": "Standard_B1s"
      },
      "adminUsername": {
        "value": "<your admin username here>"
      },
      "adminPassword": {
        "value": "<your admin password here>"
      }
    }
  }
```

## 3) Log into virtual machine and install X-Road Central Server

