## Variables used by packer.pkr.hcl

variable "name" {
  type = string
  default = rg-whertwec-test-eastus2
}
variable "location" {
  type = string
  default = eastus2
}
variable "ApplicationName" {
  type = string
  default = azure-ace-tech-week
}
variable "AppTypeRole" {
  type = string
  default = RG
}
variable "DataProtection" {
  type = string
  default = NotProtected
}
variable "DRTier" {
  type = string
  default = None
}
variable "Environment" {
  type = string
  default = ATS
}
variable "Location" {
  type = string
  default = USW2Z
}
variable "NotificationContact" {
  type = string
  default = willis.hertweck
}
variable "ProductCostCenter" {
  type = string
  default = ATS
}
variable "SupportResponseSLA" {
  type = string
  default = None
}
variable "WorkloadType" {
  type = string
  default = WebServer
}
variable "Owner" {
  type = string
  default = willis
}