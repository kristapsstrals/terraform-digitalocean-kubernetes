variable "do_token" {}

variable "cluster_name" {
  type = string
  default = "krisstech"
}

variable "cluster_region" {
  type = string
  default = "fra1"
}

variable "cluster_tags" {
  type = list(string)
  default = ["dev"]
}

variable "cluster_min_nodes" {
  type = number
  default = 1
}

variable "cluster_max_nodes" {
  type = number
  default = 3
}

variable "cluster_node_count" {
  type = number
  default = 1
}

variable "cluster_node_size" {
  type = string
  default = "s-1vcpu-2gb"
}