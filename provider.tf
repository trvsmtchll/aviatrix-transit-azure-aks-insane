provider "aviatrix" {
  controller_ip           = var.controller_ip
  username                = var.username
  password                = var.password
  skip_version_validation = true
  version                 = "2.18"
}

provider "azurerm" {
  version = "=2.30.0"
  features {}
}
