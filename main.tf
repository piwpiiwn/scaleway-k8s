terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  zone   = "fr-par-1"
  region = "fr-par"
}

resource "scaleway_k8s_cluster_beta" "piw" {
  name    = "piwpiiwn"
  version = "1.19.3"
  cni     = "calico"
}

resource "scaleway_k8s_pool_beta" "piw" {
  cluster_id = scaleway_k8s_cluster_beta.piw.id
  name       = "piwpiiwn-pool"
  node_type  = "DEV1-M"
  size       = 1
}
