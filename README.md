
[![Deploy Status](https://github.com/bhashas/proxmox-gitops-lab/actions/workflows/deploy.yml/badge.svg)](https://github.com/bhashas/proxmox-gitops-lab/actions/workflows/deploy.yml)

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
````

-----

## 🔄 Pipeline CI/CD

**Gestion de flux** : `cancel-in-progress: false` garantit l'intégrité du State Terraform.

```text
git push (main)
    │
    ├── [Job 1] Scan IaC : Checkov & Trivy (Export SARIF)
    │
    ├── [Job 2] Terraform : Provisionnement VM Proxmox
    │           └── Clone VM template Cloud-Init (IP statique + SSH)
    │
    └── [Job 3] Ansible : Configuration & Hardening
                ├── Join Tailnet (via authkey dédiée)
                ├── SSL : Provisionnement cert via 'tailscale cert'
                ├── Nginx : Config HTTPS & Headers de sécurité
                └── UFW : Fermeture totale IP publique (Inbound Deny)
```

-----

## 🛠️ Stack technique

### Infrastructure as Code

  * **Terraform `bpg/proxmox` provider** — Provisionnement via API Proxmox.
  * **Cloud-init** — Injection clé SSH ed25519 + IP statique.
  * **Terraform Cloud** — Backend distant pour le state.

### Configuration Management & Sécurité

  * **Ansible** — Playbook idempotent pour Nginx et la sécurisation système.
  * **UFW (Firewall) — Stratégie Default Deny. Seul le trafic via tailscale0 est autorisé.**
  * **Tailscale Cert** — HTTPS automatique sans exposition de ports publics.

-----

## 📁 Structure du projet

```text
proxmox-gitops-lab/
├── .github/
│   └── workflows/
│       └── deploy.yml        # Pipeline CI/CD complet
├── ansible/
│   ├── inventory.ini         # VM cible via DNS Tailscale
│   └── install_nginx.yml     # Playbook : Nginx + SSL + UFW
├── main.tf                   # VM Proxmox + cloud-init
└── README.md
```

-----

## 🔐 Secrets GitHub

| Secret | Rôle |
| :--- | :--- |
| `TAILSCALE_AUTHKEY` | Auth key éphémère pour le Runner |
| `TAILSCALE_VM_AUTHKEY` | Auth key pour l'enregistrement de la VM cible |
| `PM_API_URL` | URL API Proxmox via Tailscale |
| `PM_API_TOKEN_ID` | ID token API Proxmox |
| `PM_API_TOKEN_SECRET` | Secret UUID du token Proxmox |
| `SSH_PRIVATE_KEY` | Clé ed25519 privée pour Ansible |
| `TF_API_TOKEN` | Token Terraform Cloud |

-----

## 🚀 Déploiement & Résultat

### Prérequis

  * Node Proxmox avec Tailscale et subnet routing activé (`192.168.192.0/18`).
  * Template Ubuntu 22.04 cloud-init (VM ID 9000).

### Validation

```bash
#Test du certificat SSL (Cadenas vert 🔒)
curl -v https://vm-test-proxmox-1.your-tailnet.ts.net
# Test du Pare-feu (Accès IP publique bloqué)
curl --connect-timeout 5 http://<IP_PUBLIQUE_HETZNER>
# → Connection timed out
```

-----

## 📊 Focus Technique

| Axe | Technologies | Implémentation |
| :--- | :--- | :--- |
| **Infrastructure as Code** | Terraform + Proxmox | Provisionnement immuable via API & Cloud-Init |
| **Configuration Management** | Ansible | Playbooks idempotents & Hardening système |
| **CI/CD Pipeline** | GitHub Actions | Workflow multi-jobs avec gestion de concurrence |
| **Networking & Sécurité** | Tailscale + UFW | VPN Mesh Zero-Trust & Firewalling strict |
| **DevSecOps** | Checkov + Trivy | Analyse statique IaC & Scan de vulnérabilités |

-----

<img width="1356" height="686" alt="image_3" src="https://github.com/user-attachments/assets/1ccb9475-f64c-4286-b7da-eabbe8230764" />

## 👤 Auteur

**Brahim Hashas** — Cloud & DevSecOps Engineer  
📩 [b.hashas@hashas.fr](mailto:b.hashas@hashas.fr)  
💼 [linkedin.com/in/brahim-hashas-221902100](https://www.linkedin.com/in/brahim-hashas-221902100/)





