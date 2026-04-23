resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "devaks"

  sku_tier = "Free"

  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_D2s_v3"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
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


resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"

  create_namespace = true

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}