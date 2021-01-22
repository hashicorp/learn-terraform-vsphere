variable "username" {
  description = "vSphere username"
  type        = string
}

variable "password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "vSphere server"
  type        = string
}

variable "vsphere_dc" {
  description = "vSphere data center"
  type        = string
}

variable "datastore_name" {
  description = "vSphere datastore"
  type        = string
}

variable "resource_pool_name" {
  description = "vSphere resource pool"
  type        = string
}

variable "network_name" {
  description = "vSphere network name"
  type        = string
}

variable "centos_name" {
  description = "CentOS name (ie: template_folder/image_path)"
  type        = string
}
