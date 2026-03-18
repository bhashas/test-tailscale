resource "proxmox_vm_qemu" "vm_test" {
  name        = "vm-test-tailscale"
  target_node = "pve-1"
  vmid        = 505

  clone       = "ubuntu-22.04-template"
  full_clone  = true

  cores   = 1
  memory  = 1024
  cpu     = "host"

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Voici la correction pour la version 3.x du provider
  disks {
    scsi {
      scsi0 {
        disk {
          size    = "10G"
          storage = "local-lvm"
        }
      }
    }
  }
}
