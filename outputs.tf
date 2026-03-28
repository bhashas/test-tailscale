# ══════════════════════════════════════════════════════════════
# OUTPUTS : Extraction des IPs pour Ansible
# ══════════════════════════════════════════════════════════════

output "vm_ip_addresses" {
  description = "Adresses IP des VMs (sans masque /18 pour Ansible)"
  value = {
    for key, vm in proxmox_virtual_environment_vm.vms :
    key => split("/", vm.initialization[0].ip_config[0].ipv4[0].address)[0]
  }
}

output "vm_details" {
  description = "Détails complets des VMs créées"
  value = {
    for key, vm in proxmox_virtual_environment_vm.vms :
    key => {
      vm_id   = vm.vm_id
      name    = vm.name
      ip      = split("/", vm.initialization[0].ip_config[0].ipv4[0].address)[0]
      started = vm.started
    }
  }
}
