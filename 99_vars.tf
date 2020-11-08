variable "shutdown_workers" {
  type    = bool
  default = false
}

variable "num_workers" {
  type    = number
  default = 1
}

variable "cluster_version" {
  type    = string
  default = "1.19.3"
}

variable "node_type" {
  type    = string
  default = "DEV1-M"
}

variable "cluster_name" {
  type = string
}

variable "cluster_cni" {
  type    = string
  default = "calico"
}
