source "vsphere-iso" "this" {
  vcenter_server      = var.vsphere_server
  username            = var.vsphere_user
  password            = var.vsphere_password
  datacenter          = var.datacenter
  cluster             = var.cluster
  insecure_connection = true

  vm_name       = "tf-edu-ubuntu"
  guest_os_type = "ubuntu64Guest"

  ssh_username = "vagrant"
  ssh_password = "vagrant"
  ssh_host = "127.0.0.1"
  ssh_port = 2222

  CPUs            = 1
  RAM             = 1024
  RAM_reserve_all = true


  configuration_parameters = {
    "RUN.container" : "lscr.io/linuxserver/openssh-server:latest"
    "RUN.mountdmi"  : "false"
    "RUN.port.2222" : "2222"
    "RUN.env.USER_NAME" : "vagrant"
    "RUN.env.USER_PASSWORD" : "vagrant"
    "RUN.env.PASSWORD_ACCESS" : "true"
  }


  disk_controller_type = ["pvscsi"]
  datastore            = var.datastore
  storage {
    disk_size             = 16384
    disk_thin_provisioned = true
  }

  iso_paths = ["ubuntu.iso"]
  
  network_adapters {
    network      = var.network_name
  }

  floppy_files = [
    "./preseed.cfg"
  ]


}

build {
  sources = [
    "source.vsphere-iso.this"
  ]

  provisioner "shell-local" {
    inline = ["echo the address is: $PACKER_HTTP_ADDR and build name is: $PACKER_BUILD_NAME"]
  }
}
