variable "do_token" {}

variable "namespace" {
  type = string
  default = "krisstech"
}

variable "do_workaround_hostname" {
  type = string
  default = "workaround.krisstech.com"
}

variable "ingress_hostname" {
  type = string
  default = "krisstech.com"  
}

variable "cert_manager_email" {
  type = string
  default = "kristaps@kriss.tech"
}