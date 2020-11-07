output "kubeconfig" {
  value = scaleway_k8s_cluster_beta.piw.kubeconfig[0].config_file
}
