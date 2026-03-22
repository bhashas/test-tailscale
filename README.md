
# 🚀 Proxmox CI/CD Lab — Terraform + Ansible + Tailscale ![Deploy Status](https://github.com/bhashas/test-tailscale/actions/workflows/deploy.yml/badge.svg)

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

**Pipeline CI/CD complet : un `git push` depuis un poste dev provisionne automatiquement une VM sur Proxmox bare-metal Hetzner, la configure via Ansible, et déploie un serveur web.**

**Zéro port exposé sur internet. Zéro intervention manuelle. 100% as-code.**

---

## 📐 Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│  Poste Dev (Ubuntu Management VM)                           │
│  git push → GitHub                                          │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
                   GitHub Actions Runner
                          │
              ┌───────────┴───────────┐
              │                       │
              ▼                       ▼
       Checkov + Trivy         Tailscale ephemeral
       (IaC Security)         node monté sur runner
              │                       │
              └───────────┬───────────┘
                          │ Tailscale mesh VPN
                          ▼
                  Proxmox Hetzner (100.108.39.48)
                  subnet: 192.168.192.0/18
                          │
                          ▼
              ┌───────────────────────┐
              │   VM 505              │
              │   ubuntu-22.04        │
              │   192.168.192.55      │
              │   Nginx + page web    │
              └───────────────────────┘
````

-----

## 🖼️ Déploiement Réussi (Preuve de Concept)

Voici le rendu final de la plateforme une fois le pipeline terminé. L'accès est réalisé de manière sécurisée via le tunnel **Tailscale**.

\<p align="center"\>
\<img src="https://github.com/bhashas/test-tailscale/raw/main/ansible/image\_3.png" alt="Screenshot du déploiement réussi" width="100%"\>
\</p\>

-----

## 📊 Ce que ce lab démontre

| Compétence | Technologie | Niveau |
| :--- | :--- | :--- |
| Infrastructure as Code | Terraform + bpg/proxmox | ✅ Production-ready |
| Configuration Management | Ansible | ✅ Idempotent |
| CI/CD Pipeline | GitHub Actions | ✅ Multi-job |
| VPN Mesh & Networking | Tailscale + subnet routing | ✅ Zero-trust |
| IaC Security Scanning | Checkov + Trivy + SARIF | ✅ DevSecOps |

-----

## 🧰 Technologies

`Proxmox VE 8.4` · `Terraform 1.7` · `bpg/proxmox provider` · `Ansible 2.20` · `Nginx` · `Tailscale 1.94` · `GitHub Actions` · `Checkov` · `Trivy` · `Terraform Cloud` · `Ubuntu 22.04 LTS` · `Cloud-Init`

-----

## 👤 Auteur

Construit dans le cadre d'un homelab multi-site orienté pratique DevSecOps et Cloud Engineering.

