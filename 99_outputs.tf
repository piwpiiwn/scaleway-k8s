output "cluster_status" {
  value = scaleway_k8s_cluster_beta.piw.status
}

output "cluster_upgrade_available" {
  value = scaleway_k8s_cluster_beta.piw.upgrade_available
}

output "wildcard_dns" {
  value = scaleway_k8s_cluster_beta.piw.wildcard_dns
}

output "kubeconfig" {
  sensitive = true
  value     = scaleway_k8s_cluster_beta.piw.kubeconfig[0].config_file
}
