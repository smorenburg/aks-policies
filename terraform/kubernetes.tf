# Create the Kubernetes cluster, including the system node pool.
resource "azurerm_kubernetes_cluster" "default" {
  name                   = "aks-${local.suffix}"
  location               = var.location
  resource_group_name    = azurerm_resource_group.default.name
  node_resource_group    = "rg-aks-${local.suffix}"
  dns_prefix             = "aks-${local.suffix}"
  sku_tier               = var.kubernetes_cluster_sku_tier
  azure_policy_enabled   = true
  local_account_disabled = true

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
  }

  default_node_pool {
    name                         = "system"
    vm_size                      = var.kubernetes_cluster_node_pool_system_vm_size
    vnet_subnet_id               = azurerm_subnet.aks.id
    zones                        = ["1", "2", "3"]
    only_critical_addons_enabled = true
    node_count                   = 3

    upgrade_settings {
      max_surge = "1"
    }
  }

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  identity {
    type         = "SystemAssigned"
  }

  api_server_access_profile {
    authorized_ip_ranges = local.authorized_ip_ranges
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
  }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
  }
}

# Create the standard node pool.
resource "azurerm_kubernetes_cluster_node_pool" "standard" {
  name                  = "standard"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.default.id
  vm_size               = var.kubernetes_cluster_node_pool_standard_vm_size
  vnet_subnet_id        = azurerm_subnet.aks.id
  zones                 = ["1", "2", "3"]
  enable_auto_scaling   = true
  min_count             = 3
  max_count             = 9

  upgrade_settings {
    max_surge = "1"
  }
}

# Assign the cluster admin role to the current user.
resource "azurerm_role_assignment" "cluster_admin" {
  scope                = azurerm_kubernetes_cluster.default.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}
