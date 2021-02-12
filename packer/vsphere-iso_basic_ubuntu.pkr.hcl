source "vsphere-iso" "this" {
  vcenter_server    = var.vsphere_server
  username          = var.vcenter_user
  password          = var.vcenter_password
  datacenter        = var.datacenter
  cluster           = var.cluster
  insecure_connection  = true

  vm_name = "tf-edu-ubuntu"
  guest_os_type = "ubuntu64Guest"
  resource_pool = var.resource_pool

  ssh_username = "vagrant"
  ssh_password = "vagrant"

  CPUs =             1
  RAM =              1024
  RAM_reserve_all = true

  disk_controller_type =  ["pvscsi"]
  datastore = var.datastore
  storage {
      disk_size =        32768
      disk_thin_provisioned = true
  }

  iso_paths = ["[vsanDatastore] Installers/ubuntu-14.04.1-server-amd64.iso"]
  // iso_checksum = "sha256:b23488689e16cad7a269eb2d3a3bf725d3457ee6b0868e00c8762d3816e25848"

  network_adapters {
      network =  var.network_name
      network_card = "vmxnet3"
  }

  floppy_files = [
    "./preseed.cfg"
  ]

  boot_command = [
    "<enter><wait><f6><wait><esc><wait>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs>",
    "/install/vmlinuz",
    " initrd=/install/initrd.gz",
    " priority=critical",
    " locale=en_US",
    " file=/media/preseed.cfg",
    "<enter>"
  ]
}

build {
  sources  = [
    "source.vsphere-iso.this"
  ]

  provisioner "shell-local" {
    inline  = ["echo the address is: $PACKER_HTTP_ADDR and build name is: $PACKER_BUILD_NAME"]
  }
}