terraform {
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg-1" {
  name     = var.name
  location = var.location
  tags = {
    ApplicationName     = var.ApplicationName
    AppTypeRole         = var.AppTypeRole
    DataProtection      = var.DataProtection
    DRTier              = var.DRTier
    Environment         = var.Environment
    Location            = var.Location
    NotificationContact = var.NotificationContact
    ProductCostCenter   = var.ProductCostCenter
    SupportResponseSLA  = var.SupportResponseSLA
    WorkloadType        = var.WorkloadType
    Owner               = var.Owner
  }
}

resource "azurerm_virtual_network" "vn-1" {
  name                = "virtualNetwork1"
  resource_group_name = azurerm_resource_group.rg-1.name
  location            = azurerm_resource_group.rg-1.location
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
  dynamic "subnet" {
    for_each = var.subnets
    content {
      name           = subnet.value["name"]
      address_prefix = subnet.value["address_space"]
    }
  }
}

# resource "azurerm_subnet" "internal-test-subnet" {
#   name                 = "internal-subnet"
#   resource_group_name  = azurerm_resource_group.rg-1.name
#   virtual_network_name = azurerm_virtual_network.vn-1.name
#   address_prefixes     = ["10.0.2.0/24"]
# }

locals {
  sublist = tolist(azurerm_virtual_network.vn-1.subnet)
}

resource "azurerm_network_interface" "main" {
  name                = "vm.nic"
  location            = azurerm_resource_group.rg-1.location
  resource_group_name = azurerm_resource_group.rg-1.name

  ip_configuration {
    name                          = "testconfig"
    subnet_id                     =  local.sublist.0.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = var.vm_name
  location              = azurerm_resource_group.rg-1.location
  resource_group_name   = azurerm_resource_group.rg-1.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_B2ms"

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
    admin_username = "whertwec"
    admin_password = "Password123!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

resource "azurerm_network_security_group" "secure-group1" {
  name                = "networksecuritygroup"
  location            = azurerm_resource_group.rg-1.location
  resource_group_name = azurerm_resource_group.rg-1.name

  security_rule {
    name                   = "rule_one"
    priority               = "100"
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "80"
    destination_port_range = "80"
    source_address_prefix  = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = "whstorageaccount01"
  resource_group_name      = azurerm_resource_group.rg-1.name
  location                 = azurerm_resource_group.rg-1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "Storage"
}

resource "azurerm_frontdoor" "frontdoor" {
  name                                         = "frontdoor-service"
  location                                     = "Global"
  resource_group_name                          = azurerm_resource_group.rg-1.name
  enforce_backend_pools_certificate_name_check = false

  frontend_endpoint {
    name      = "frontdoor-service"
    host_name = "frontdoor-service.azurefd.net"
  }

  routing_rule {
    name               = "routingrule1"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["frontdoor-service"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "test-backend"
    }
  }

  backend_pool_load_balancing {
    name = "backend-load-balancer"
  }

  backend_pool_health_probe {
    name = "backend-health-probe"
  }

  backend_pool {
    name = "test-backend"
    backend {
      host_header = "wwww.google.com"
      address     = "www.google.com"
      http_port   = 80
      https_port  = 443
    }
    load_balancing_name = "backend-load-balancer"
    health_probe_name   = "backend-health-probe"
  }
}

resource "azurerm_app_service_plan" "app-service" {
  name                = "example-app"
  location            = azurerm_resource_group.rg-1.location
  resource_group_name = azurerm_resource_group.rg-1.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}