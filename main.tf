provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource_group_AKScluster" {
  name     = "WebAPI"
  location = "uksouth"  
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = "aks-cluster-api"
  location            = azurerm_resource_group.resource_group_AKScluster.location
  resource_group_name = azurerm_resource_group.resource_group_AKScluster.name
  dns_prefix          = "aks-cluster-api"  

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2s"
  }

   service_principal {
    client_id     = var.ARM_CLIENT_ID
    client_secret = var.ARM_CLIENT_SECRET
  }

  tags = {
    environment = "Prod"
  }
}

terraform {
  backend "azurerm" {
    resource_group_name   = "BackendStorages"
    storage_account_name  = "uknewlookproduction"
    container_name        = "tfstateprod"
    key                   = "terraform.tfstate"
  }
}
