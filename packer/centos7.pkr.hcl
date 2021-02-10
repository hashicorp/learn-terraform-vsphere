variable "vsphere_server" {
  type    = string
  default = ""
}

variable "username" {
  type    = string
  default = ""
}

variable "password" {
  type    = string
  default = ""
}

variable "datacenter" {
  type    = string
  default = "PacketDatacenter"
}

variable "datastore" {
  type    = string
  default = "datastore1"
}

variable "network_name" {
  type    = string
  default = "VM Network"
}

variable "resource_pool" {
  type    = string
  default = "Demo-ResourcePool"
}

# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/from-1.5/blocks/source
source "vsphere-iso" "CentOS7" {
  CPUs                = 2
  RAM                 = 1024
  boot_command        = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos7.cfg<enter><wait>"]
  boot_wait           = "10s"
  convert_to_template = true
  datacenter          = "${var.datacenter}"
  datastore           = "${var.datastore}"
  guest_os_type       = "centos7_64Guest"
  http_directory      = "preseeds"
  http_port_max       = 9001
  http_port_min       = 9001
  insecure_connection = "true"
  iso_checksum        = "659691c28a0e672558b003d223f83938f254b39875ee7559d1a4a14c79173193"
  iso_urls            = ["iso/CentOS-7-x86_64-Minimal-2003.iso", "https://mirrors.mit.edu/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-2003.iso"]
  network_adapters {
    network      = "user `network_name`"
    network_card = "vmxnet3"
  }
  notes            = "Build via Packer"
  password         = "${var.password}"
  resource_pool    = "${var.resource_pool}"
  shutdown_command = "echo 'vagrant'|sudo -S /sbin/halt -h -p"
  ssh_password     = "vagrant"
  ssh_port         = 22
  ssh_username     = "vagrant"
  ssh_wait_timeout = "10m"
  storage {
    disk_size             = 20000
    disk_thin_provisioned = true
  }
  username       = "${var.username}"
  vcenter_server = "${var.vsphere_server}"
  vm_name        = "CentOS7"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/from-1.5/blocks/build
build {
  description = "CentOS 7 Template"

  sources = ["source.vsphere-iso.CentOS7"]


  # could not parse template for following block: "template: hcl2_upgrade:2:40: executing \"hcl2_upgrade\" at <.Vars>: can't evaluate field Vars in type struct { HTTPIP string; HTTPPort string }"
  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    script          = "scripts/setup.sh"
  }
}
