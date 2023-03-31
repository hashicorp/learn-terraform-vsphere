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

  ssh_username = "ubuntu"
  ssh_password = "ubuntu"
  ssh_timeout  = "30m"

  CPUs            = 1
  RAM             = 1024
  RAM_reserve_all = true

  disk_controller_type = ["pvscsi"]
  datastore            = var.datastore
  storage {
    disk_size             = 16384
    disk_thin_provisioned = true
  }

  iso_paths = ["[vsanDatastore] ISO/ubuntu-22.04.1-live-server-amd64.iso"]

  network_adapters {
    network      = var.network_name
    network_card = "vmxnet3"
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
