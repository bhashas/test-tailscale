![Deploy Status](https://github.com/bhashas/test-tailscale/actions/workflows/deploy.yml/badge.svg)

# 🚀 Proxmox CI/CD Lab — Terraform + Ansible + Tailscale HTTPS + UFW

<p align="left">
<img src="https://img.shields.io/badge/Terraform-1.7-7B42BC?style=for-the-badge&logo=terraform&logoColor=white"/>
<img src="https://img.shields.io/badge/Ansible-2.20-EE0000?style=for-the-badge&logo=ansible&logoColor=white"/>
<img src="https://img.shields.io/badge/GitHub_Actions-CI%2FCD-2088FF?style=for-the-badge&logo=githubactions&logoColor=white"/>
<img src="https://img.shields.io/badge/Proxmox-8.4-E57000?style=for-the-badge&logo=proxmox&logoColor=white"/>
<img src="https://img.shields.io/badge/Tailscale-Mesh_VPN-242424?style=for-the-badge&logo=tailscale&logoColor=white"/>
</p>

<p align="left">
<img src="https://img.shields.io/badge/Checkov-IaC_Scan-brightgreen?style=flat-square"/>
<img src="https://img.shields.io/badge/Trivy-Vulnerability_Scan-blue?style=flat-square"/>
<img src="https://img.shields.io/badge/Terraform_Cloud-State_Backend-7B42BC?style=flat-square"/>
<img src="https://img.shields.io/badge/Ubuntu-22.04_Cloud_Init-E95420?style=flat-square&logo=ubuntu&logoColor=white"/>
<img src="https://img.shields.io/badge/Nginx-Web_Server-009639?style=flat-square&logo=nginx&logoColor=white"/>
</p>

**Pipeline CI/CD complet : un `git push` provisionne automatiquement une VM sur Proxmox (Hetzner), la sécurise via UFW, et déploie un serveur web avec certificat SSL automatique.**

**Zéro port exposé sur internet. Accès exclusif via Mesh VPN. 100% as-code.**

---

## 📐 Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│  Poste Dev (Ubuntu Management VM)                           │
│  git push → GitHub (Concurrency Lock: Active)               │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
                   GitHub Actions Runner
                          │
              ┌───────────┴───────────┐
              │                       │
              ▼                       ▼
       Checkov + Trivy         Tailscale Node
       (IaC Security)         (Runner joins Mesh)
              │                       │
              └───────────┬───────────┘
                          │ Tailscale encrypted tunnel
                          ▼
                  Proxmox Hetzner (100.108.39.48)
                  subnet: 192.168.192.0/18
                          │
                          ▼
              ┌───────────────────────────┐
              │   VM 505 (Ubuntu 22.04)   │
              │   🔒 UFW: Tailscale Only  │
              │   🌐 HTTPS: Tailscale Cert│
              │   DNS: vm-test-proxmox-1  │
              └───────────────────────────┘
