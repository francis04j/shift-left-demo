provider "azurerm" {    
    features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.2"
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name = "trf_rg_blobstore"
    storage_account_name = "trfdanapistorageaccount"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}

variable "imageid" {
  type = string
  description = "image version id from az docker build"
}

resource "azurerm_resource_group" "dan_api" {
  name = "terraform_rg"
  location = "uksouth"
}

resource "azurerm_container_group" "dan_api" {
  name = "danapi"
  location = azurerm_resource_group.dan_api.location
  resource_group_name = azurerm_resource_group.dan_api.name

  ip_address_type     = "Public"
  dns_name_label      = "dan-api-dns"
  os_type             = "Linux"


container {
    name   = "danapi"
    image  = "francis04j/danapi:${var.imageid}"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"      
    }

    ports {
      port     = 8080
      protocol = "TCP"      
    }
    
  }
}
