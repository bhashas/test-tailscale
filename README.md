C'est un excellent exercice de mise à jour. Ton README doit être le reflet exact de la robustesse de ton code actuel. J'ai intégré la gestion de la **concurrence**, le passage au **HTTPS via Tailscale Cert**, la sécurisation **UFW** et l'ajout du secret pour la VM.

Voici ton fichier `README.md` complet et corrigé, prêt à être copié-collé :

---

```markdown
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
  <img src="https://img.shields.io/badge/UFW-Hardening-orange?style=flat-square"/>
  <img src="https://img.shields.io/badge/Ubuntu-22.04_Cloud_Init-E95420?style=flat-square&logo=ubuntu&logoColor=white"/>
  <img src="https://img.shields.io/badge/Nginx-Web_Server-009639?style=flat-square&logo=nginx&logoColor=white"/>
</p>

**Pipeline CI/CD complet : un `git push` provisionne automatiquement une VM sur Proxmox (Hetzner), la sécurise via UFW, et déploie un serveur web avec certificat SSL automatique.**

**Zéro port exposé sur internet. Accès exclusif via Mesh VPN. 100% as-code.**

---

## 📐 Architecture
```
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
                          │
                          ▼
              ┌───────────────────────────┐
              │   VM 505 (Ubuntu 22.04)   │
              │   🔒 UFW: Tailscale Only  │
              │   🌐 HTTPS: Tailscale Cert│
              │   DNS: vm-test-proxmox-1  │
              └───────────────────────────┘
```

---

## 🔄 Pipeline CI/CD (Optimisé)
**Gestion de flux** : `cancel-in-progress: false` garantit l'intégrité du State Terraform en interdisant l'annulation d'un job en cours de déploiement.

```
git push (main)
    │
    ├── [Job 1] Scan IaC : Checkov & Trivy (Export SARIF)
    │
    ├── [Job 2] Terraform : Provisionnement VM Proxmox
    │           (Remote State sur Terraform Cloud)
    │
    └── [Job 3] Ansible : Configuration & Hardening
                ├── Join Tailnet (via authkey dédiée)
                ├── SSL : Provisionnement cert via 'tailscale cert'
                ├── Nginx : Config HTTPS & Headers de sécurité
                └── UFW : Fermeture totale IP publique (Inbound Deny)
```

---

## 🛠️ Stack technique & Sécurité

### Infrastructure & Config
- **Terraform `bpg/proxmox`** — Gestion du cycle de vie des VMs.
- **Ansible** — Configuration post-déploiement et hardening.
- **Tailscale Cert** — HTTPS automatique sans exposition de port 80/443 au web public.

### Hardening (Sécurité)
- **Zero-Trust Networking** : VM accessible uniquement via `tailscale0`.
- **UFW (Firewall)** : Stratégie `Default Deny` en entrée. Seuls les flux SSH/HTTP/HTTPS via l'interface Tailscale sont autorisés.
- **Concurrency Control** : Verrouillage des runs pour éviter les corruptions de State.

---

## 🔐 Secrets GitHub

| Secret | Rôle |
|---|---|
| `TAILSCALE_AUTHKEY` | Auth key éphémère pour le Runner GitHub |
| `TAILSCALE_VM_AUTHKEY` | Auth key pour l'enregistrement de la VM cible |
| `PM_API_URL` / `TOKEN` | Accès API Proxmox via Tailscale |
| `SSH_PRIVATE_KEY` | Clé privée pour l'accès Ansible (via DNS Tailscale) |
| `TF_API_TOKEN` | Token Terraform Cloud |

---

## 🚀 Résultat & Validation

### Accès Sécurisé
Une fois déployé, le serveur n'est accessible que par son nom DNS Tailscale :
```bash
# Test du certificat SSL (Cadenas vert 🔒)
curl -v [https://vm-test-proxmox-1.your-tailnet.ts.net](https://vm-test-proxmox-1.your-tailnet.ts.net)

# Test de l'étanchéité (Pare-feu)
# L'accès via l'IP publique Hetzner doit expirer (Stealth mode)
curl --connect-timeout 5 http://<IP_PUBLIQUE_HETZNER>
# → Connection timed out
```

---

## 📊 Compétences démontrées

| Compétence | Technologie | Niveau |
|---|---|---|
| Infrastructure as Code | Terraform + Proxmox | ✅ Expert |
| Security Hardening | UFW + Zero Trust | ✅ Avancé |
| CI/CD Pipeline | GitHub Actions | ✅ Production |
| SSL/TLS Management | Tailscale HTTPS | ✅ Moderne |
| DevSecOps | Checkov + Trivy | ✅ Automatisé |

---
<img width="1366" height="667" alt="inscription" src="https://github.com/user-attachments/assets/913adb0f-4623-4908-b139-e093e7694ce1" />

## 👤 Auteur
Projet conçu pour un environnement **Hetzner Bare-Metal** orienté **Cloud Engineering** et **Sécurité Offensive/Défensive**.
```

---

### 💡 Ce qui a été corrigé/ajouté :
1.  **Titre & Badges** : Ajout du badge **UFW Hardening** et précision sur le HTTPS dans le titre.
2.  **Architecture** : Schéma mis à jour pour montrer que la VM communique via son DNS et qu'elle est protégée par UFW.
3.  **Concurrency** : Explication de pourquoi on a mis `cancel-in-progress: false` (protection du State).
4.  **UFW & SSL** : Ajout d'une section dédiée au hardening et à la validation par `curl` (très important pour ton portfolio).
5.  **Secrets** : Ajout du secret `TAILSCALE_VM_AUTHKEY` que nous avions oublié dans la version précédente.

**C'est prêt pour le `git push` ! Est-ce que tu veux que je t'aide à rédiger le message de commit pour que ton historique soit aussi propre que ton code ?**
