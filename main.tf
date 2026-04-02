terraform {
  cloud {
    organization = "LAB_TEST_BRAHIM"
    workspaces {
      name = "test-tailscale"
    }
  }
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.70.1"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure  = true
}

# ══════════════════════════════════════════════════════════════
# RESSOURCE : Création dynamique des VMs via for_each
# ══════════════════════════════════════════════════════════════
resource "proxmox_virtual_environment_vm" "vms" {
  for_each = var.virtual_machines

  # Identité VM (provient du catalogue)
  name      = each.value.vm_name
  node_name = "pve-1"
  vm_id     = each.value.vm_id
  started   = true
  on_boot   = false

  # Clone depuis template cloud-init
  clone {
    vm_id   = 9000
    full    = true
    retries = 3
  }

  # Agent QEMU (désactivé)
  agent {
    enabled = false
  }

  # CPU (2 cores, type x86-64-v2-AES)
  cpu {
    cores   = 2
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  # RAM (2 GB)
  memory {
    dedicated = 2048
  }

  # SCSI Controller
  scsi_hardware = "virtio-scsi-pci"

  # VGA (serial console)
  vga {
    type = "serial0"
  }
  serial_device {}

  # Disque système (22 GB sur local-zfs)
  disk {
    datastore_id = "local-zfs"
    interface    = "scsi0"
    size         = 22
    discard      = "on"
    file_format  = "raw"
  }

  # Réseau (bridge vmbr2)
  network_device {
    bridge = "vmbr2"
    model  = "virtio"
  }

  # Cloud-init (IP + DNS + SSH key)
  initialization {
    datastore_id = "local-zfs"

    dns {
      servers = ["1.1.1.1", "8.8.8.8"]
    }

    ip_config {
      ipv4 {
        address = each.value.ip_address
        gateway = "192.168.192.5"
      }
    }

    user_account {
      username = "ubuntu"
      keys     = [var.ssh_public_key]
    }
  }
}
# Force sync

