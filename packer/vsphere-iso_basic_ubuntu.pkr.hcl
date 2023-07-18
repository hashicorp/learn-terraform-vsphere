# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

source "vsphere-iso" "this" {
  vcenter_server      = var.vsphere_server
  username            = var.vsphere_user
  password            = var.vsphere_password
  datacenter          = var.datacenter
  cluster             = var.cluster
  insecure_connection = true

  vm_name       = "tf-edu-ubuntu"
  guest_os_type = "ubuntu64Guest"

  CPUs            = 2
  RAM             = 2048
  RAM_reserve_all = true

  ssh_username = "ubuntu"
  ssh_password = "ubuntu"
  ssh_timeout  = "30m"

  /* Uncomment when running on vcsim
  ssh_host     = "127.0.0.1"
  ssh_port     = 2222

  configuration_parameters = {
    "RUN.container" : "lscr.io/linuxserver/openssh-server:latest"
    "RUN.mountdmi" : "false"
    "RUN.port.2222" : "2222"
    "RUN.env.USER_NAME" : "ubuntu"
    "RUN.env.USER_PASSWORD" : "ubuntu"
    "RUN.env.PASSWORD_ACCESS" : "true"
  }
  */

  disk_controller_type = ["pvscsi"]
  datastore            = var.datastore
  storage {
    disk_size             = 16384
    disk_thin_provisioned = true
  }

  iso_paths = ["[vsanDatastore] ISO/ubuntu-22.04.1-live-server-amd64.iso"]

  network_adapters {
    network = var.network_name
  }

  cd_files = ["./meta-data", "./user-data"]
  cd_label = "cidata"
  
  boot_command = ["<wait>e<down><down><down><end> autoinstall ds=nocloud;<F10>"]

}

build {
  sources = [
    "source.vsphere-iso.this"
  ]

  provisioner "shell-local" {
    inline = ["echo the address is: $PACKER_HTTP_ADDR and build name is: $PACKER_BUILD_NAME"]
  }
}
