# 🚀 Proxmox CI/CD Lab — Terraform + Ansible + Tailscale ![Deploy Status](https://github.com/bhashas/test-tailscale/actions/workflows/deploy.yml/badge.svg)

<p align="left">
  <img src="https://img.shields.io/badge/Terraform-1.7-7B42BC?style=for-the-badge&logo=terraform&logoColor=white"/>
  <img src="https://img.shields.io/badge/Ansible-2.20-EE0000?style=for-the-badge&logo=ansible&logoColor=white"/>
  <img src="https://img.shields.io/badge/GitHub_Actions-CI%2FCD-2088FF?style=for-the-badge&logo=githubactions&logoColor=white"/>
  <img src="https://img.shields.io/badge/Proxmox-8.4-E57000?style=for-the-badge&logo=proxmox&logoColor=white"/>
  <img src="https://img.shields.io/badge/Tailscale-Mesh_VPN-242424?style=for-the-badge&logo=tailscale&logoColor=white"/>
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
       Checkov + Trivy          Tailscale ephemeral
       (IaC Security)          node monté sur runner
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
---

### 🛠️ Étape 2 : La suite (Déploiement + Stack + Auteur)
Va juste à la ligne en dessous de ce que tu viens de coller et ajoute ce bloc :

```markdown
---

## 🖼️ Déploiement Réussi (Preuve de Concept)

Voici le rendu final de la plateforme. L'accès est réalisé via le tunnel **Tailscale**.

<p align="center">
  <img src="https://github.com/bhashas/test-tailscale/raw/main/ansible/image_3.png" alt="Screenshot du déploiement réussi" width="100%">
</p>

---

## 🛠️ Stack technique

- **Terraform** : Provisionnement VM (Provider bpg/proxmox).
- **Ansible** : Configuration (Nginx + Page Web).
- **Tailscale** : Tunnel sécurisé entre GitHub et Proxmox.
- **Security** : Scan IaC avec Checkov et Trivy.

---

## 📊 Compétences démontrées
- Infrastructure as Code (IaC) ✅
- Pipeline CI/CD DevSecOps ✅
- Réseaux VPN Mesh (Zero Trust) ✅

---

## 👤 Auteur
Projet réalisé par **Brahim H.** (Homelab & Cloud Engineering)
