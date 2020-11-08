
resource "scaleway_k8s_cluster_beta" "piw" {
  name    = var.cluster_name
  version = var.cluster_version
  cni     = var.cluster_cni
}

resource "scaleway_k8s_pool_beta" "piw" {
  count      = var.shutdown_workers ? 0 : 1
  cluster_id = scaleway_k8s_cluster_beta.piw.id
  name       = "workerpool"
  node_type  = var.node_type
  size       = var.num_workers
}
