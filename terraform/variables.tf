variable "location" {
  description = "The location (region) for the resources."
  type        = string
  default     = "westeurope"
}

variable "location_abbreviation" {
  description = "The abbreviation of the location."
  type        = map(string)
  default = {
    "westeurope"  = "weu"
    "northeurope" = "neu"
    "eastus"      = "eus"
    "westus"      = "wus"
    "ukwest"      = "ukw"
    "uksouth"     = "uks"
  }
}

variable "environment" {
  description = "The environment for the resources."
  type        = string
  default     = "dev"
}

variable "kubernetes_cluster_sku_tier" {
  description = "The SKU tier that should be used for the Kubernetes cluster."
  type        = string
  default     = "Standard"
}

variable "kubernetes_cluster_node_pool_system_vm_size" {
  description = "The size of the virtual machines for the system node pool."
  type        = string
  default     = "Standard_D2ds_v5"
}

variable "kubernetes_cluster_node_pool_standard_vm_size" {
  description = "The size of the virtual machines for the standard node pool."
  type        = string
  default     = "Standard_D2ds_v5"
}
