source "azure-arm" "azure_image" {
#  client_id = "willis.hertweck@cdw.com"
#  client_secret = "PUTSECRETEHERE"
  resource_group_name = "rg-whertwec-test-eastus2"
  storage_account = "whstorageaccount01"
  subscription_id = "7fef4dbc-1411-4bf2-b1da-0c276068b5d8" 
#  tenant_id = "de39842a-caba-497e-a798-7896aea43218" 

  capture_container_name = "images"
  capture_name_prefix = "packer"
  
  os_type = "Linux"
  image_publisher = "RedHat"
  image_offer     = "RHEL"
  image_sku       = "7-LVM"

  location = "eastus2"
  vm_size = "Standard_B2ms"
}

build {
  name = "testbuild"
  sources = ["azure-arm.azure_image"] 
  azure_tags = {
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

provisioner "ansible" {
    playbook_file = "../ansible/playbook.yaml"
}
}

#post-processor "ansible" {
# tags = {
  #   ApplicationName     = var.ApplicationName
  #   AppTypeRole         = var.AppTypeRole
  #   DataProtection      = var.DataProtection
  #   DRTier              = var.DRTier
  #   Environment         = var.Environment
  #   Location            = var.Location
  #   NotificationContact = var.NotificationContact
  #   ProductCostCenter   = var.ProductCostCenter
  #   SupportResponseSLA  = var.SupportResponseSLA
  #   WorkloadType        = var.WorkloadType
  #   Owner               = var.Owner
  # }
#}