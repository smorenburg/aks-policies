output "oidc_issuer_url" {
  description = "The OpenID Connect issuer URL."
  value       = azurerm_kubernetes_cluster.default.oidc_issuer_url
}

output "azurerm_user_assigned_identity_tf_runner_client_id" {
  description = "The tf-runner managed identity client identifier."
  value       = azurerm_user_assigned_identity.tf_runner.client_id
}

output "azurerm_user_assigned_identity_argo_client_id" {
  description = "The Argo Workflows managed identity client identifier."
  value       = azurerm_user_assigned_identity.argo.client_id
}

output "azurerm_key_vault_default_id" {
  description = "The key vault identifier."
  value       = azurerm_key_vault.default.id
}
