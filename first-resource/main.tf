# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "firstresource" {
  name     = "example-resources"
  location = "West Europe"
}

#create virtual network
resource "azurerm_virtual_network" "Vnet" {
  name                = "myVnet"
  location            = azurerm_resource_group.firstresource.location
  resource_group_name = azurerm_resource_group.firstresource.name
  address_space       = ["10.0.0.0/16"]
}

# create subnet

resource "azurerm_subnet" "subnet1" {
  name                 = "SubNet1"
  resource_group_name  = azurerm_resource_group.firstresource.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "SubNet2"
  resource_group_name  = azurerm_resource_group.firstresource.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsgrp"
  location            = azurerm_resource_group.firstresource.location
  resource_group_name = azurerm_resource_group.firstresource.name

  security_rule {
    name                       = "allowtcp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}