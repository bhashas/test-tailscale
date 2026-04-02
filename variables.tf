# ══════════════════════════════════════════════════════════════
# VARIABLES PROXMOX (existantes - ne pas toucher)
# ══════════════════════════════════════════════════════════════
variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "ssh_public_key" {
  type = string
}

# ══════════════════════════════════════════════════════════════
# CATALOGUE DES MACHINES VIRTUELLES
# ══════════════════════════════════════════════════════════════
variable "virtual_machines" {
  description = "Catalogue des VMs à créer/gérer sur Proxmox"
  type = map(object({
    vm_id       = number
    vm_name     = string
    ip_address  = string
    description = string
  }))

  default = {
    # ─────────────────────────────────────────
    # VM 505 — Production actuelle (Test)
    # ─────────────────────────────────────────
    "505" = {
      vm_id       = 505
      vm_name     = "vm-test-tailscale-final"
      ip_address  = "192.168.192.55/18"
      description = "VM de test Tailscale - Production"
    }

    # ─────────────────────────────────────────
    # VM 506 — Portfolio (Futur déploiement)
    # ─────────────────────────────────────────
    "506" = {
      vm_id       = 506
      vm_name     = "vm-portfolio-webserver"
      ip_address  = "192.168.192.56/18"
      description = "VM Portfolio - Serveur web vitrine"
    }
  }
}
