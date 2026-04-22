resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "devaks"

  sku_tier = "Free"

  default_node_pool {
    name       = "system"
    vm_size    = "Standard_D2s_v3"   # AMD64 ONLY
    node_count = 1

    os_sku = "Ubuntu"

    type = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "amd64" {
  name                  = "amd64pool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id

  vm_size    = "Standard_D2s_v3"   # AMD64 ONLY
  node_count = 1

  mode    = "User"
  os_type = "Linux"
  os_sku  = "Ubuntu"

  node_labels = {
    "kubernetes.io/arch" = "amd64"
  }
}