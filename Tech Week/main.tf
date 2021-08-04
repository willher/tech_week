terraform {
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg-1" {
  name = var.name
  location = var.location
  tags = {
    ApplicationName = var.ApplicationName
    AppTypeRole = var.AppTypeRole
    DataProtection = var.DataProtection
    DRTier = var.DRTier
    Environment = var.Environment
    Location = var.Location
    NotificationContact = var.NotificationContact
    ProductCostCenter = var.ProductCostCenter
    SupportResponseSLA = var.SupportResponseSLA
    WorkloadType = var.WorkloadType
    Owner = var.Owner
  }
}

resource "azurerm_virtual_network" "vn-1" {
  name = "virtualNetwork1"
  resource_group_name = azurerm_resource_group.rg-1.name
  location = azurerm_resource_group.rg-1.location
  address_space = ["10.0.0.0/16"]
  dns_servers = ["10.0.0.4", "10.0.0.5"]
  dynamic "subnet" {
    for_each = var.subnets
    content {
      name = subnet.value["name"]
      address_prefix = subnets.value["address_prefix"]
    }
  }

resource "azurerm_subnet" "internal" {
  name = "internal"
  resource_group_name = azurerm_resource_group.rg-1.name
  vitual_network_name = azurerm_virtual_network.vn-1.name
  address_prefix = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name = "${var.prefix}.nic"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.rg-1.name

  ip_configurateion {
    name = "testconfig"
    subnet_id = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name = var.vm_name
  location = azurerm_resource_group.rg1.location
  resource_group_name   = azurerm_resource_group.rg1.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size = "Standard_B2ms"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "admin"
    admin_password = "Password123!"
  }
  os_profile_linux_config {
    disable_password_authentication = true
  }
  tags = {
    environment = "staging"
  }
}