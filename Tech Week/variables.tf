#variables used in the main.tf file and their types
#
  variable "name" {
      type = string
  }
  variable "location"{
      type = string
  }
  variable "ApplicationName" {
      type = string
  }
  variable "AppTypeRole" {
      type = string
  }
  variable "DataProtection" {
      type = string
  }
  variable "DRTier" {
      type = string
  }
  variable "Environment" {
      type = string
  }
  variable "Location" {
      type = string
  }
  variable "NotificationContact" {
      type = string
  }
  variable "ProductCostCenter" {
      type = string
  }
  variable "SupportResponseSLA" {
      type = string
  }
  variable "WorkloadType" {
      type = string
  }
  variable "Owner" {
      type = string
  }
  variable "vm_name" {
      type = string
  }
  variable "subnets" {
      type = map(object({
          name = string 
          address_space = string}))